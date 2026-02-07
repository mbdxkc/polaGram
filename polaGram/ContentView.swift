//
//  ContentView.swift
//  polaGram
//
//  Created by valdez campos on 2/5/26.
//
//  A Polaroid-style photo sharing app with an authentic aesthetic.
//  Combines retro design with modern SwiftUI architecture.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Overview
/**
 polaGram Design System
 =====================
 
 This file contains the complete UI implementation and design token system for polaGram.
 The app creates Polaroid-style photo frames with handwritten captions and vintage date stamps.
 
 Architecture
 - SwiftUI-based, component-driven, and cross-platform (iOS, iPadOS, macOS)
 - Token-based design: centralized colors, typography, and layout constants
 - Responsive scaling via GeometryReader (clamped to min/max)
 
 Components
 1. ContentView: Root with gradient background, header, Polaroid frame, and action menu
 2. PolaBackground: Animated gradient, vignette, bubbles, and film grain overlay
 3. PolaHeader/PolaLogo: Brand presentation
 4. PolaFrame: Polaroid frame with photo area, caption, and date stamp
 5. CaptionArea/PlaceholderView: Subcomponents for the frame
 6. ActionMenu/ActionButton: Bottom action bar
 7. SplashScreen: Launch overlay with dismiss gestures
 
 Not Yet Implemented (Actions/IO)
 - Photo picker integration, loading, and saving
 - Sharing to Messages/Instagram, haptics, parallax, ripple effects
 */

// MARK: - Color Tokens
extension Color {
    // Brand - Pink Gradient Scheme
    static let polaPink       = Color(red: 1.0, green: 0.41, blue: 0.71) // #FF69B4
    static let polaPinkLight  = Color(red: 1.0, green: 0.69, blue: 0.84) // #FFB0D5
    static let polaPinkHot    = Color(red: 1.0, green: 0.08, blue: 0.58) // #FF1494

    // Background - Warm Moody Tones
    static let polaGradientCenter = Color(red: 0.49, green: 0.53, blue: 0.59)
    static let polaGradientMid    = Color(red: 0.33, green: 0.27, blue: 0.31)
    static let polaGradientEdge   = Color(red: 0.37, green: 0.18, blue: 0.18)

    // UI Accents - Silver/Blue
    static let polaSilverLight = Color(red: 0.85, green: 0.88, blue: 0.92)
    static let polaSilverDark  = Color(red: 0.75, green: 0.80, blue: 0.88)

    // Frame & Photo (Dark Mode Aware)
    static let polaFrameBackground = Color(
        light: Color(red: 0.99, green: 0.98, blue: 0.94),
        dark:  Color(red: 0.96, green: 0.95, blue: 0.91)
    )

    static let polaPhotoBackground = Color(
        light: Color(red: 0.96, green: 0.95, blue: 0.92),
        dark:  Color(red: 0.13, green: 0.12, blue: 0.11)
    )

    // Accent
    static let polaDateStamp = Color(red: 0.91, green: 0.61, blue: 0.42) // #E89B6C

    // Helper initializer for adaptive colors
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self.init(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}

// MARK: - Strings
struct PolaStrings {
    // Branding
    static let appTitle   = "polaGram"
    static let appTagline = "share what matters"

    // Placeholders (exactly 42 characters each)
    static let captionPlaceholders = [
        "holy shit, i can't believe this happened omg",
        "this moment right here changed everything fr",
        "felt cute might delete later idk lol omg wow",
        "vibes were immaculate not gonna lie honestly",
        "this is exactly what i needed today for real",
        "never forget this feeling right here forever",
        "pretty sure this was the best day of my life",
        "no bc this actually means everything to me rn",
        "genuinely can't stop thinking about this ngl",
        "this energy is immaculate i'm not even lying",
        "lowkey the highlight of my entire year tbh fr",
        "actually obsessed with this moment right here",
        "the way this made me feel literally insane fr",
        "can't explain how much this means to me omg x",
        "drunk thoughts but this is everything to me x",
        "we were so fucked up but this was perfect lol",
        "blacked out but somehow remember this moment x",
        "definitely got too turnt but worth it ngl tbh",
        "woke up thinking about this and i'm deceased x",
        "still not over whatever the fuck this was tbh",
        "this hit different and i'm still not okay omg",
        "the energy was unmatched i'm literally crying",
        "absolutely unhinged behavior but i love it fr",
        "chaotic energy but make it aesthetic somehow x",
        "feral over this and i have zero regrets at all",
        "losing my shit over this in the best way tbh",
        "this unlocked something in me i can't explain",
        "main character energy and i'm here for it fr x",
        "no thoughts just vibes and this exact moment x",
        "the serotonin boost i needed so desperately fr",
        "core memory unlocked and i'm emotional about x",
        "this is my roman empire now apparently so yeah",
        "rotting in bed thinking about this all day lol",
        "delulu is the solulu and this proves it facts",
        "mentally i'm still here and will be forever x",
        "gave me whiplash in the best way possible fr x",
        "screaming crying throwing up over this moment",
        "my therapist will hear about this next session",
        "didn't expect to feel this way but here we are",
        "universe really said it's your moment babe go x",
        "manifested this energy and it actually worked x",
        "living for this chaos and refusing to apologize"
    ]

    static var randomCaptionPlaceholder: String {
        captionPlaceholders.randomElement() ?? captionPlaceholders[0]
    }

    // Action labels
    static let messageButton   = "message"
    static let instagramButton = "instagram"
    static let saveButton      = "save"

    // Accessibility
    static let addPhotoHint            = "double tap to select or capture a photo"
    static let selectedPhotoLabel      = "selected photo"
    static let captionAccessibilityHint = "double tap to edit caption"
    static let shareViaMessagesLabel   = "share via messages"
    static let shareToInstagramLabel   = "share to instagram"
    static let saveToPhotosLabel       = "save to photos"
}

// MARK: - Layout Tokens
struct PolaLayout {
    // Frame
    static let frameWidth: CGFloat  = 312
    static let frameHeight: CGFloat = 392
    static let photoSize: CGFloat   = 280

    // Spacing & Padding
    static let framePadding: CGFloat = 16
    static let captionHeight: CGFloat = 80
    static let headerTopPadding: CGFloat = 60

    // Visual Details
    static let cornerRadius: CGFloat = 5
    static let borderWidth: CGFloat = 1
    static let dividerOpacity: Double = 0.08
    static let backgroundPinkOpacity: Double = 0.06
    static let frameTextureOpacity: Double = 0.02
    static let filmGrainOpacity: Double = 0.03

    // Typography Sizes
    static let titleSize: CGFloat = 48
    static let subtitleSize: CGFloat = 18
    static let captionSize: CGFloat = 15
    static let dateStampSize: CGFloat = 11
    static let placeholderTextSize: CGFloat = 13

    // Date Stamp Positioning
    static let dateStampTrailing: CGFloat = 12
    static let dateStampBottom: CGFloat = 10

    // Action Menu
    static let menuHeight: CGFloat = 80
    static let menuIconSize: CGFloat = 28
    static let menuSpacing: CGFloat = 50
    static let menuBottomPadding: CGFloat = 20

    // Responsive Scaling
    static let referenceWidth: CGFloat = 360
    static let minScale: CGFloat = 0.85
    static let maxScale: CGFloat = 1.3
}

// MARK: - Fonts
extension Font {
    static func polaTitle(size: CGFloat = 36) -> Font {
        .custom("BradleyHandITCTT-Bold", size: size)
    }
    static func polaBody(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Regular", size: size)
    }
    static func polaBodyBold(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Bold", size: size)
    }
}

// MARK: - ContentView
struct ContentView: View {
    // State
    @State private var photoImage: Image? = nil
    @State private var caption: String = ""
    @State private var showSplash: Bool = true

    var body: some View {
        ZStack {
            mainContent.opacity(showSplash ? 0 : 1)

            if showSplash {
                SplashScreen()
                    .transition(.opacity)
                    .zIndex(1)
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                if value.translation.width < -50 || value.translation.height < -50 {
                                    dismissSplash()
                                }
                            }
                    )
                    .onTapGesture { dismissSplash() }
            }
        }
    }

    // Main content with responsive scale and safe-area aware paddings
    private var mainContent: some View {
        GeometryReader { geometry in
            let scale = scaleFactor(for: geometry.size)

            ZStack {
                PolaBackground(scale: scale)

                VStack(spacing: 0) {
                    PolaHeader()
                        .padding(.top, max(PolaLayout.headerTopPadding, geometry.safeAreaInsets.top + 20))

                    Spacer()

                    PolaFrame(photoImage: photoImage, caption: $caption, scale: scale)

                    Spacer()

                    ActionMenu(scale: scale, hasPhoto: photoImage != nil)
                        .padding(.bottom, max(PolaLayout.menuBottomPadding * scale, geometry.safeAreaInsets.bottom + 10 * scale))
                }
            }
        }
    }

    // Helpers
    private func dismissSplash() {
        withAnimation(.easeOut(duration: 0.5)) { showSplash = false }
    }

    private func scaleFactor(for size: CGSize) -> CGFloat {
        let base = size.width / PolaLayout.referenceWidth
        return min(max(base, PolaLayout.minScale), PolaLayout.maxScale)
    }
}

// MARK: - Background
struct PolaBackground: View {
    let scale: CGFloat
    @State private var animateGradient = false

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    .polaGradientCenter.opacity(0.9),
                    .polaPink.opacity(PolaLayout.backgroundPinkOpacity),
                    .polaGradientMid,
                    .polaGradientEdge
                ]),
                center: animateGradient ? UnitPoint(x: 0.35, y: 0.4) : UnitPoint(x: 0.65, y: 0.6),
                startRadius: 100 * scale,
                endRadius: 500 * scale
            )
            .ignoresSafeArea()
            .drawingGroup()
            .onAppear {
                withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }

            FilmGrainOverlay()
                .ignoresSafeArea()

            ChampagneBubbles()

            // Top & Bottom vignettes
            VStack {
                LinearGradient(
                    colors: [.black, .black.opacity(0.6), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200 * scale)
                .ignoresSafeArea(edges: .top)

                Spacer()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.4), .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150 * scale)
                .ignoresSafeArea(edges: .bottom)
            }
            .drawingGroup()
        }
    }
}

// MARK: - Film Grain Overlay
struct FilmGrainOverlay: View {
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.02))
            .blendMode(.overlay)
            .drawingGroup()
    }
}

// MARK: - Champagne Bubbles
struct ChampagneBubbles: View {
    @State private var bubbles: [Bubble] = []
    @State private var spawnInterval: TimeInterval = 0.006
    @State private var lastSpawnTime: Date = Date()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    BubbleView(
                        bubble: bubble,
                        screenHeight: geometry.size.height,
                        screenWidth: geometry.size.width
                    )
                }
            }
            .onAppear {
                startBubbleStream(screenSize: geometry.size)
                startSpawnRateTransition()
            }
        }
        .allowsHitTesting(false)
    }

    private func startBubbleStream(screenSize: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if shouldSpawnBubble() {
                let randomX = CGFloat.random(in: 0...screenSize.width)
                let newBubble = Bubble(
                    id: UUID(),
                    startX: randomX,
                    screenHeight: screenSize.height,
                    screenWidth: screenSize.width
                )
                bubbles.append(newBubble)
                if bubbles.count > 500 { bubbles.removeFirst() }
            }
        }
    }

    private func shouldSpawnBubble() -> Bool {
        let now = Date()
        if now.timeIntervalSince(lastSpawnTime) >= spawnInterval {
            lastSpawnTime = now
            return true
        }
        return false
    }

    private func startSpawnRateTransition() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if spawnInterval < 0.15 {
                spawnInterval += 0.00144 // (0.15 - 0.006) / 100
            } else {
                timer.invalidate()
            }
        }
    }
}

struct Bubble: Identifiable {
    let id: UUID
    let startX: CGFloat
    let screenHeight: CGFloat
    let screenWidth: CGFloat
    let duration: Double = Double.random(in: 5...7)
    let size: CGFloat = CGFloat.random(in: 4...10)
    let rotation: Double = Double.random(in: 0...360)
    let color: Color = [.white, .white.opacity(0.7), .polaPinkLight.opacity(0.7), .polaSilverLight.opacity(0.5)].randomElement()!
}

struct BubbleView: View {
    let bubble: Bubble
    let screenHeight: CGFloat
    let screenWidth: CGFloat

    @State private var yPosition: CGFloat = 0
    @State private var xPosition: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 1.5

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        bubble.color.opacity(0.4),
                        bubble.color.opacity(0.15),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: bubble.size / 2
                )
            )
            .frame(width: bubble.size * scale, height: bubble.size * scale)
            .position(x: bubble.startX + xPosition, y: bubble.screenHeight - yPosition)
            .opacity(opacity)
            .onAppear { animateBubble() }
    }

    private func animateBubble() {
        let centerX = screenWidth / 2
        let distanceFromCenter = bubble.startX - centerX
        let targetXOffset = -distanceFromCenter * 0.8
        let drift = CGFloat.random(in: -15...15)

        withAnimation(.easeIn(duration: 0.2)) { opacity = 1.0 }
        withAnimation(.easeInOut(duration: bubble.duration)) {
            yPosition = bubble.screenHeight + 50
            xPosition = targetXOffset + drift
        }
        withAnimation(.easeOut(duration: bubble.duration)) { scale = 0.2 }

        DispatchQueue.main.asyncAfter(deadline: .now() + bubble.duration * 0.7) {
            withAnimation(.easeOut(duration: bubble.duration * 0.3)) { opacity = 0 }
        }
    }
}

// MARK: - Header
struct PolaHeader: View {
    var body: some View {
        VStack(spacing: -12) {
            PolaLogo().drawingGroup()

            Text(PolaStrings.appTagline)
                .font(.polaBody(size: PolaLayout.subtitleSize))
                .kerning(1.5)
                .foregroundStyle(
                    LinearGradient(colors: [.polaSilverLight, .polaSilverDark], startPoint: .leading, endPoint: .trailing)
                )
                .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.5)
                .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: 0.5)
                .shadow(color: .black.opacity(0.2), radius: 0.5, x: 0, y: 0.5)
                .offset(y: -4)
        }
    }
}

struct PolaLogo: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("pola")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(colors: [.polaSilverDark, .polaPinkLight], startPoint: .bottom, endPoint: .top)
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
            Text("Gram")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(colors: [.polaPinkLight, .polaPinkHot], startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
        }
        .shadow(color: .polaPinkLight.opacity(0.3), radius: 10, x: 0, y: 0)
    }
}

// MARK: - Polaroid Frame
struct PolaFrame: View {
    let photoImage: Image?
    @Binding var caption: String
    let scale: CGFloat

    @FocusState private var isCaptionFocused: Bool
    @State private var isFramePressed = false
    @State private var currentPlaceholder = PolaStrings.randomCaptionPlaceholder
    @State private var floatOffset: CGFloat = 0

    // Cached formatted date to avoid recomputation
    private let formattedDateString: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: Date())
    }()

    var body: some View {
        VStack(spacing: 0) {
            // Photo Area
            ZStack(alignment: .bottomTrailing) {
                Color.polaPhotoBackground

                if let photoImage = photoImage {
                    photoImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: PolaLayout.photoSize * scale, height: PolaLayout.photoSize * scale)
                        .clipped()
                        .overlay(
                            Rectangle()
                                .fill(.white.opacity(PolaLayout.filmGrainOpacity))
                                .blendMode(.screen)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    PlaceholderView(scale: scale)
                }

                // Inner shadow
                Rectangle()
                    .fill(.black.opacity(0.03))
                    .frame(width: PolaLayout.photoSize * scale, height: PolaLayout.photoSize * scale)
                    .allowsHitTesting(false)

                // Date stamp (only when photo exists)
                if photoImage != nil {
                    Text(formattedDateString)
                        .font(.system(size: PolaLayout.dateStampSize * scale, weight: .medium, design: .monospaced))
                        .foregroundColor(.polaDateStamp.opacity(0.85))
                        .padding(.trailing, PolaLayout.dateStampTrailing * scale)
                        .padding(.bottom, PolaLayout.dateStampBottom * scale)
                }
            }
            .frame(width: PolaLayout.photoSize * scale, height: PolaLayout.photoSize * scale)
            .clipShape(RoundedRectangle(cornerRadius: 4 * scale))
            .padding(.top, PolaLayout.framePadding * scale)
            .padding(.horizontal, PolaLayout.framePadding * scale)

            // Divider
            Rectangle()
                .fill(Color.black.opacity(PolaLayout.dividerOpacity))
                .frame(height: PolaLayout.borderWidth)
                .padding(.horizontal, PolaLayout.framePadding * scale)

            // Caption Area
            CaptionArea(
                caption: $caption,
                isCaptionFocused: $isCaptionFocused,
                currentPlaceholder: currentPlaceholder,
                scale: scale
            )
        }
        .frame(width: PolaLayout.frameWidth * scale, height: PolaLayout.frameHeight * scale)
        .background(
            Color.polaFrameBackground.overlay(
                Rectangle().fill(Color.black.opacity(PolaLayout.frameTextureOpacity)).blendMode(.multiply)
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale)
                .strokeBorder(
                    LinearGradient(colors: [.white.opacity(0.3), .clear, .black.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .cornerRadius(PolaLayout.cornerRadius * scale)
        .shadow(color: .black.opacity(0.4), radius: 35 * scale, x: 0, y: 18 * scale)
        .shadow(color: .black.opacity(0.2), radius: 12 * scale, x: 0, y: 6 * scale)
        .shadow(color: .black.opacity(0.1), radius: 3 * scale, x: 0, y: 2 * scale)
        .scaleEffect(isFramePressed ? 0.98 : 1.0)
        .offset(y: floatOffset)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFramePressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isFramePressed = true }
                .onEnded { _ in isFramePressed = false }
        )
        .accessibilityElement(children: .contain)
        .accessibilityHint(PolaStrings.addPhotoHint)
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatOffset = -3 * scale
            }
        }
    }
}

// MARK: - Placeholder View
private struct PlaceholderView: View {
    let scale: CGFloat

    var body: some View {
        VStack(spacing: 12 * scale) {
            // Logo watermark (with platform-specific fallback)
            #if canImport(UIKit)
            if UIImage(named: "pG_logo") != nil {
                Image("pG_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: PolaLayout.photoSize * scale * 0.7)
                    .opacity(0.15)
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 100 * scale))
                    .foregroundColor(.gray.opacity(0.15))
            }
            #else
            if let _ = NSImage(named: "pG_logo") {
                Image("pG_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: PolaLayout.photoSize * scale * 0.7)
                    .opacity(0.15)
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 100 * scale))
                    .foregroundColor(.gray.opacity(0.15))
            }
            #endif

            Text("tap to snap")
                .font(.polaBody(size: PolaLayout.placeholderTextSize * scale))
                .foregroundColor(.gray.opacity(0.95))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Caption Area
private struct CaptionArea: View {
    @Binding var caption: String
    @FocusState.Binding var isCaptionFocused: Bool
    let currentPlaceholder: String
    let scale: CGFloat

    @State private var placeholderOpacity: Double = 0.22
    @State private var placeholderRotation: Double = 0
    @State private var userTextRotation: Double = 0

    var body: some View {
        ZStack {
            if caption.isEmpty {
                Text(currentPlaceholder)
                    .font(.custom("BradleyHandITCTT-Bold", size: PolaLayout.captionSize * scale))
                    .foregroundColor(.black.opacity(placeholderOpacity))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(2 * scale)
                    .kerning(0.5)
                    .blur(radius: 0.3)
                    .onAppear {
                        placeholderOpacity = 0.22
                    }
            }

            TextField("", text: $caption, axis: .vertical)
                .font(.custom("BradleyHandITCTT-Bold", size: PolaLayout.captionSize * scale))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3...4)
                .lineSpacing(2 * scale)
                .kerning(0.5)
                .padding(.horizontal, 38 * scale)
                .padding(.vertical, 10 * scale)
                .frame(height: PolaLayout.captionHeight * scale)
                .focused($isCaptionFocused)
                .onChange(of: caption) { _, newValue in
                    if newValue.count > 42 { caption = String(newValue.prefix(42)) }
                }
                .accessibilityHint(PolaStrings.captionAccessibilityHint)

            if isCaptionFocused {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(caption.count)/42")
                            .font(.polaBody(size: 10 * scale))
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.trailing, 8 * scale)
                            .padding(.bottom, 4 * scale)
                    }
                }
                .frame(height: PolaLayout.captionHeight * scale)
            }
        }
        .frame(height: PolaLayout.captionHeight * scale)
    }
}

// MARK: - Action Menu
struct ActionMenu: View {
    let scale: CGFloat
    let hasPhoto: Bool

    var body: some View {
        HStack(spacing: PolaLayout.menuSpacing * scale) {
            ActionButton(icon: "message.fill", label: PolaStrings.messageButton, accessibilityLabel: PolaStrings.shareViaMessagesLabel, scale: scale, isEnabled: hasPhoto)
            ActionButton(icon: "camera.fill", label: PolaStrings.instagramButton, accessibilityLabel: PolaStrings.shareToInstagramLabel, scale: scale, isEnabled: hasPhoto)
            ActionButton(icon: "square.and.arrow.down.fill", label: PolaStrings.saveButton, accessibilityLabel: PolaStrings.saveToPhotosLabel, scale: scale, isEnabled: hasPhoto)
        }
        .frame(height: PolaLayout.menuHeight * scale)
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let label: String
    let accessibilityLabel: String
    let scale: CGFloat
    let isEnabled: Bool

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 8 * scale) {
            Image(systemName: icon)
                .font(.system(size: PolaLayout.menuIconSize * scale))
                .foregroundStyle(
                    LinearGradient(
                        colors: isPressed ? [.polaPinkLight, .polaPinkLight] : [.polaSilverLight, .polaSilverDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: isPressed ? .polaPink.opacity(0.5) : .clear, radius: 10, x: 0, y: 0)

            Text(label)
                .font(.polaBody(size: 12 * scale))
                .foregroundColor(isPressed ? .polaPinkLight : .polaSilverLight)
        }
        .opacity(isEnabled ? 1.0 : 0.4)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        .allowsHitTesting(isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if isEnabled { isPressed = true } }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Splash Screen
struct SplashScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / PolaLayout.referenceWidth
            ZStack {
                PolaBackground(scale: scale)
                VStack(spacing: 16 * scale) {
                    #if canImport(UIKit)
                    if UIImage(named: "pG_logo") != nil {
                        Image("pG_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280 * scale)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .shadow(color: .polaPinkLight.opacity(0.3), radius: 20, x: 0, y: 0)
                    } else {
                        PolaLogo()
                            .scaleEffect(logoScale * 1.5)
                            .opacity(logoOpacity)
                    }
                    #else
                    if let _ = NSImage(named: "pG_logo") {
                        Image("pG_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280 * scale)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .shadow(color: .polaPinkLight.opacity(0.3), radius: 20, x: 0, y: 0)
                    } else {
                        PolaLogo()
                            .scaleEffect(logoScale * 1.5)
                            .opacity(logoOpacity)
                    }
                    #endif

                    Text("swipe to snap")
                        .font(.polaBody(size: 24 * scale))
                        .kerning(1.5)
                        .foregroundStyle(
                            LinearGradient(colors: [.polaSilverLight, .polaSilverDark], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.5)
                        .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: 0.5)
                        .opacity(textOpacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.6)) { textOpacity = 1.0 }
        }
    }
}

#Preview { ContentView() }

