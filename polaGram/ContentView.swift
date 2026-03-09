//
//  ContentView.swift
//  polaGram
//
//  Main view: splash -> capture -> develop -> caption -> share
//  See README.md for full documentation.
//

import SwiftUI
import SwiftData
import PhotosUI
#if canImport(UIKit)
import UIKit
import CoreMotion
import Photos
import Combine
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
import Photos
typealias PlatformImage = NSImage
#endif

// MARK: - ContentView

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    // Photo & UI
    @State private var photoImage: Image? = nil
    @State private var caption = ""
    @State private var showSplash = true
    @State private var showOnboarding = false
    @State private var showCaptionEditor = false
    @State private var showGallery = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("showWatermark") private var showWatermark = true

    // Development animation
    @State private var isDeveloping = false
    @State private var developmentProgress = 0.0
    @State private var developmentTimer: Timer? = nil
    @State private var activeFilters: [PolaFilter] = []

    // Photo picker
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false

    // iOS only
    #if canImport(UIKit)
    @StateObject private var shakeDetector = ShakeDetector()
    @StateObject private var parallaxManager = ParallaxManager()
    @State private var showCamera = false
    @State private var showPhotoSourceSheet = false
    @State private var messageImageItem: MessageImageItem? = nil
    #endif

    // Alerts
    @State private var showSaveAlert = false
    @State private var saveAlertTitle = ""
    @State private var saveAlertMessage = ""

    // MARK: - Body

    var body: some View {
        ZStack {
            mainContent.opacity(showSplash ? 0 : 1)
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
                    .zIndex(1)
                    .gesture(DragGesture(minimumDistance: 50).onEnded { value in
                        if value.translation.width < -50 || value.translation.height < -50 { dismissSplash() }
                    })
                    .onTapGesture { dismissSplash() }
            }

            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding).zIndex(1.5)
            }

            if showCaptionEditor {
                CaptionEditorOverlay(caption: $caption, isPresented: $showCaptionEditor)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .zIndex(2)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showCaptionEditor)
        .animation(.easeInOut(duration: 0.3), value: showOnboarding)
        .fullScreenCover(isPresented: $showGallery) { GalleryView() }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { _, newItem in Task { await loadPhoto(from: newItem) } }

        #if canImport(UIKit)
        .sheet(isPresented: $showCamera) {
            CameraView(image: $photoImage, onPhotoTaken: { startPhotoDevelopment() })
        }
        .confirmationDialog("Add Photo", isPresented: $showPhotoSourceSheet) {
            Button("Take Photo") { if UIImagePickerController.isSourceTypeAvailable(.camera) { showCamera = true } }
            Button("Choose from Library") { showPhotoPicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .onChange(of: shakeDetector.shakeIntensity) { _, intensity in
            guard isDeveloping && intensity > 0.1 else { return }
            developmentProgress = min(1.0, developmentProgress + intensity * 0.05)
            UIImpactFeedbackGenerator(style: intensity > 0.5 ? .medium : .light).impactOccurred()
            if developmentProgress >= 1.0 {
                finishDevelopment()
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        .sheet(item: $messageImageItem) { item in
            MessageComposer(image: item.image) { sent in
                messageImageItem = nil
                if sent {
                    SoundManager.shared.playSwoosh()
                    SoundManager.shared.playHaptic(.success)
                }
            }
        }
        #endif
        .alert(saveAlertTitle, isPresented: $showSaveAlert) { Button("OK", role: .cancel) {} } message: { Text(saveAlertMessage) }
        .onDisappear {
            developmentTimer?.invalidate()
            developmentTimer = nil
            #if canImport(UIKit)
            // Nudge ShakeDetector to trigger cleanup (actual stop in deinit)
            shakeDetector.objectWillChange.send()
            #endif
        }
    }

    // MARK: - Main Content

    private var mainContent: some View {
        GeometryReader { geometry in
            let scale = scaleFactor(for: geometry.size)
            ZStack {
                PolaBackground(scale: scale)
                VStack(spacing: 0) {
                    PolaHeader()
                        .padding(.top, max(PolaLayout.headerTopPadding, geometry.safeAreaInsets.top + 10))
                    Spacer()
                    #if canImport(UIKit)
                    PolaFrame(
                        photoImage: photoImage, caption: $caption, scale: scale,
                        onAddPhoto: addPhoto, onEditCaption: { showCaptionEditor = true }, onClearPhoto: clearPhoto,
                        isDeveloping: isDeveloping, developmentProgress: developmentProgress, activeFilters: activeFilters,
                        parallaxX: parallaxManager.xOffset, parallaxY: parallaxManager.yOffset
                    )
                    #else
                    PolaFrame(
                        photoImage: photoImage, caption: $caption, scale: scale,
                        onAddPhoto: addPhoto, onEditCaption: { showCaptionEditor = true }, onClearPhoto: clearPhoto,
                        isDeveloping: isDeveloping, developmentProgress: developmentProgress, activeFilters: activeFilters
                    )
                    #endif
                    Spacer()
                    ActionMenu(
                        scale: scale, hasPhoto: photoImage != nil,
                        onMessage: sharePolaViaMessages, onInstagram: sharePolaToInstagram,
                        onSave: savePolaToPhotos, onGallery: { showGallery = true }, showWatermark: $showWatermark
                    )
                    .padding(.bottom, max(PolaLayout.menuBottomPadding * scale, geometry.safeAreaInsets.bottom + 10 * scale))
                }
            }
        }
    }

    // MARK: - Helpers

    private func dismissSplash() {
        withAnimation(.easeOut(duration: 0.5)) {
            showSplash = false
            if !hasSeenOnboarding { showOnboarding = true }
        }
    }

    private func scaleFactor(for size: CGSize) -> CGFloat {
        let base = size.width / PolaLayout.referenceWidth
        return min(max(base, PolaLayout.minScale), PolaLayout.maxScale)
    }

    @MainActor
    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item = item,
              let data = try? await item.loadTransferable(type: Data.self) else { return }
        #if canImport(UIKit)
        if let uiImage = UIImage(data: data) { photoImage = Image(uiImage: uiImage); startPhotoDevelopment() }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: data) { photoImage = Image(nsImage: nsImage); startPhotoDevelopment() }
        #endif
    }

    // MARK: - Development Animation

    private func startPhotoDevelopment() {
        SoundManager.shared.playShutter()
        SoundManager.shared.playHaptic(.medium)
        isDeveloping = true
        developmentProgress = 0.0
        activeFilters = PolaFilter.randomFilters()

        let interval = 0.1, increment = interval / 20.0
        var ticks = 0
        developmentTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if developmentProgress < 1.0 {
                developmentProgress += increment
                ticks += 1
                if ticks % 20 == 0 { SoundManager.shared.playDevelopTick() }
            } else {
                finishDevelopment()
            }
        }
    }

    private func finishDevelopment() {
        developmentTimer?.invalidate()
        developmentTimer = nil
        isDeveloping = false
        developmentProgress = 1.0
    }

    private func clearPhoto() {
        photoImage = nil
        caption = ""
        isDeveloping = false
        developmentProgress = 0.0
        developmentTimer?.invalidate()
        developmentTimer = nil
        selectedPhotoItem = nil
        activeFilters = []
    }

    private func addPhoto() {
        #if canImport(UIKit)
        if UIImagePickerController.isSourceTypeAvailable(.camera) { showPhotoSourceSheet = true }
        else { showPhotoPicker = true }
        #else
        showPhotoPicker = true
        #endif
    }

    // MARK: - Save & Share

    private func savePolaToPhotos() {
        guard photoImage != nil else { return }

        #if canImport(UIKit)
        Task { @MainActor in
            do {
                let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                guard status == .authorized || status == .limited else {
                    saveAlertTitle = "Permission Required"
                    saveAlertMessage = "Please enable Photos access in Settings to save your pola."
                    showSaveAlert = true
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    return
                }

                let currentCaption = caption, currentPhoto = photoImage
                let currentFilters = activeFilters, currentWatermark = showWatermark
                let renderer = ImageRenderer(content:
                    StaticPolaFrame(
                        photoImage: currentPhoto,
                        caption: currentCaption,
                        scale: 2.0,
                        activeFilters: currentFilters,
                        showWatermark: currentWatermark
                    )
                        .frame(width: PolaLayout.frameWidth * 2.0, height: PolaLayout.frameHeight * 2.0)
                )

                renderer.scale = 1.0 // Already scaled in the view

                guard let uiImage = renderer.uiImage else {
                    throw NSError(domain: "polaGram", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to render image"])
                }

                guard let jpegData = uiImage.jpegData(compressionQuality: 0.95) else {
                    throw NSError(domain: "polaGram", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create JPEG data"])
                }

                // Save to Photos
                try await PHPhotoLibrary.shared().performChanges {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: jpegData, options: nil)
                }

                // Save to local gallery (SwiftData)
                let savedPola = SavedPola(
                    imageData: jpegData,
                    caption: currentCaption,
                    filterRawValues: currentFilters.map { $0.rawValue }
                )
                modelContext.insert(savedPola)

                saveAlertTitle = "Success!"
                saveAlertMessage = "Your pola has been saved to Photos."
                showSaveAlert = true

                // Play save confirmation sound, swoosh, and haptic
                SoundManager.shared.playSaveConfirmation()
                SoundManager.shared.playHaptic(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    SoundManager.shared.playSwoosh()
                }

            } catch {
                saveAlertTitle = "Save Failed"
                saveAlertMessage = "Error: \(error.localizedDescription)"
                showSaveAlert = true

                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
        #elseif canImport(AppKit)
        Task { @MainActor in
            // Capture current values
            let currentCaption = caption
            let currentPhoto = photoImage
            let currentFilters = activeFilters
            let currentWatermark = showWatermark

            // Render the pola frame using ImageRenderer
            let renderer = ImageRenderer(content:
                StaticPolaFrame(
                    photoImage: currentPhoto,
                    caption: currentCaption,
                    scale: 1.0,
                    activeFilters: currentFilters,
                    showWatermark: currentWatermark
                )
            )

            renderer.scale = 3.0 // High quality for macOS

            guard let nsImage = renderer.nsImage else {
                saveAlertTitle = "Render Failed"
                saveAlertMessage = "Unable to create pola image."
                showSaveAlert = true
                return
            }

            // macOS: Use save panel
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.jpeg, .png]
            savePanel.nameFieldStringValue = "pola-\(Date().timeIntervalSince1970).jpg"
            savePanel.message = "Save your pola"

            let response = await savePanel.begin()

            if response == .OK, let url = savePanel.url {
                do {
                    if let tiffData = nsImage.tiffRepresentation,
                       let bitmapImage = NSBitmapImageRep(data: tiffData),
                       let jpegData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: 0.95]) {
                        try jpegData.write(to: url)

                        // Save to local gallery (SwiftData)
                        let savedPola = SavedPola(
                            imageData: jpegData,
                            caption: currentCaption,
                            filterRawValues: currentFilters.map { $0.rawValue }
                        )
                        modelContext.insert(savedPola)

                        saveAlertTitle = "Success!"
                        saveAlertMessage = "Your pola has been saved."
                        showSaveAlert = true
                    }
                } catch {
                    saveAlertTitle = "Save Failed"
                    saveAlertMessage = "Error: \(error.localizedDescription)"
                    showSaveAlert = true
                }
            }
        }
        #endif
    }

    private func sharePolaViaMessages() {
        #if canImport(UIKit)
        guard photoImage != nil else { return }
        let renderer = ImageRenderer(content:
            StaticPolaFrame(
                photoImage: photoImage, caption: caption, scale: 2.0,
                activeFilters: activeFilters, showWatermark: showWatermark
            )
            .frame(width: PolaLayout.frameWidth * 2.0, height: PolaLayout.frameHeight * 2.0)
        )
        renderer.scale = 1.0
        if let uiImage = renderer.uiImage { messageImageItem = MessageImageItem(image: uiImage) }
        #endif
    }

    private func sharePolaToInstagram() {
        #if canImport(UIKit)
        guard photoImage != nil else { return }
        guard let url = URL(string: "instagram-stories://share?source_application=mediaBrilliance.polaGram"),
              UIApplication.shared.canOpenURL(url) else {
            saveAlertTitle = "Instagram Not Found"
            saveAlertMessage = "Please install Instagram to share your pola to Stories."
            showSaveAlert = true
            return
        }

        let renderer = ImageRenderer(content:
            StaticPolaFrame(
                photoImage: photoImage, caption: caption, scale: 2.0,
                activeFilters: activeFilters, showWatermark: showWatermark
            )
            .frame(width: PolaLayout.frameWidth * 2.0, height: PolaLayout.frameHeight * 2.0)
        )
        renderer.scale = 1.0
        guard let uiImage = renderer.uiImage, let imageData = uiImage.pngData() else { return }

        UIPasteboard.general.setItems([[
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor": "#1A1A1A",
            "com.instagram.sharedSticker.backgroundBottomColor": "#4A3030"
        ]], options: [.expirationDate: Date().addingTimeInterval(300)])

        UIApplication.shared.open(url) { success in
            if success {
                SoundManager.shared.playSwoosh()
                SoundManager.shared.playHaptic(.success)
            }
        }
        #endif
    }
}

#Preview { ContentView() }
