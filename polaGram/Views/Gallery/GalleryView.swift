//
//  GalleryView.swift
//  polaGram
//
//  Displays saved polas in a swipeable stack with "pile of photos" aesthetic.
//  Tap to view details, swipe to browse. Only renders 3 cards at a time.
//

import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

struct GalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedPola.createdAt, order: .reverse) private var savedPolas: [SavedPola]

    @State private var selectedPola: SavedPola?
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var isAnimating = false
    @State private var hasInteracted = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Spacer()
                if savedPolas.isEmpty { emptyState } else { polaPile }
                Spacer()
                swipeHint
            }
        }
        .fullScreenCover(item: $selectedPola) { pola in
            PolaDetailView(savedPola: pola) {
                if currentIndex >= savedPolas.count && currentIndex > 0 {
                    currentIndex = savedPolas.count - 1
                }
                selectedPola = nil
            }
        }
        .onChange(of: savedPolas.count) { oldCount, newCount in
            if newCount < oldCount && currentIndex >= newCount && newCount > 0 {
                currentIndex = newCount - 1
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                SoundManager.shared.playHaptic(.light)
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(PolaStrings.closeGalleryLabel)

            Spacer()

            Text("Gallery")
                .font(.polaTitle(size: 28))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.polaSilverLight, .polaPinkLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Spacer()

            if !savedPolas.isEmpty {
                Text("\(min(currentIndex + 1, savedPolas.count))/\(savedPolas.count)")
                    .font(.polaBody(size: 14))
                    .foregroundColor(.polaSilverDark.opacity(0.6))
                    .frame(width: 44, height: 44)
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(.polaSilverDark.opacity(0.5))

            VStack(spacing: 8) {
                Text("No polas yet")
                    .font(.polaTitle(size: 24))
                    .foregroundColor(.polaSilverLight)

                Text("Save a pola to see it here")
                    .font(.polaBody(size: 16))
                    .foregroundColor(.polaSilverDark.opacity(0.7))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Gallery is empty. Save a pola to see it here.")
    }

    // MARK: - Swipe Hint

    @ViewBuilder
    private var swipeHint: some View {
        if !savedPolas.isEmpty && !hasInteracted {
            Text("Swipe to browse")
                .font(.polaBodyBold(size: 14))
                .foregroundColor(.polaSilverLight.opacity(0.6))
                .padding(.bottom, 40)
                .transition(.opacity)
                .accessibilityHidden(true)
        } else if !savedPolas.isEmpty {
            Color.clear.frame(height: 40).padding(.bottom, 40)
        }
    }

    // MARK: - Pola Pile

    private var polaPile: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let safeIndex = min(max(currentIndex, 0), max(savedPolas.count - 1, 0))

            ZStack {
                // Next card (underneath, shown when swiping left)
                if safeIndex + 1 < savedPolas.count && dragOffset < 0 {
                    PolaPileCard(savedPola: savedPolas[safeIndex + 1], index: safeIndex + 1)
                        .zIndex(0)
                }

                // Previous card (underneath, shown when swiping right)
                if safeIndex > 0 && dragOffset > 0 {
                    PolaPileCard(savedPola: savedPolas[safeIndex - 1], index: safeIndex - 1)
                        .zIndex(0)
                }

                // Current card (top)
                if savedPolas.indices.contains(safeIndex) {
                    PolaPileCard(savedPola: savedPolas[safeIndex], index: safeIndex)
                        .offset(x: dragOffset)
                        .zIndex(1)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .contentShape(Rectangle())
            .gesture(swipeGesture(screenWidth: screenWidth, safeIndex: safeIndex))
            .simultaneousGesture(tapGesture(safeIndex: safeIndex))
        }
        .frame(height: 420)
        .accessibilityLabel("Pola \(min(currentIndex + 1, savedPolas.count)) of \(savedPolas.count)")
        .accessibilityHint("Swipe left or right to browse, double tap to view details")
    }

    // MARK: - Gestures

    private func swipeGesture(screenWidth: CGFloat, safeIndex: Int) -> some Gesture {
        DragGesture(minimumDistance: 15)
            .onChanged { value in
                guard !isAnimating else { return }
                isDragging = true
                let translation = value.translation.width

                // Rubber band at edges
                if (safeIndex == 0 && translation > 0) ||
                   (safeIndex == savedPolas.count - 1 && translation < 0) {
                    dragOffset = translation * 0.3
                } else {
                    dragOffset = translation
                }
            }
            .onEnded { value in
                guard !isAnimating else { return }
                isDragging = false

                let threshold: CGFloat = 80
                let velocity = value.predictedEndTranslation.width - value.translation.width

                if (value.translation.width < -threshold || velocity < -150) && safeIndex < savedPolas.count - 1 {
                    navigate(direction: .next, screenWidth: screenWidth)
                } else if (value.translation.width > threshold || velocity > 150) && safeIndex > 0 {
                    navigate(direction: .previous, screenWidth: screenWidth)
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func tapGesture(safeIndex: Int) -> some Gesture {
        TapGesture()
            .onEnded {
                guard !isDragging && !isAnimating && savedPolas.indices.contains(safeIndex) else { return }
                selectedPola = savedPolas[safeIndex]
            }
    }

    // MARK: - Navigation

    private enum Direction { case next, previous }

    private func navigate(direction: Direction, screenWidth: CGFloat) {
        isAnimating = true
        SoundManager.shared.playHaptic(.light)

        if !hasInteracted {
            withAnimation(.easeOut(duration: 0.3)) { hasInteracted = true }
        }

        let offset = direction == .next ? -screenWidth - 50 : screenWidth + 50
        withAnimation(.easeOut(duration: 0.25)) { dragOffset = offset }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.none) {
                currentIndex += direction == .next ? 1 : -1
                dragOffset = 0
            }
            isAnimating = false
        }
    }
}

// MARK: - Pile Card

struct PolaPileCard: View {
    let savedPola: SavedPola
    let index: Int

    private static let rotations: [Double] = [-3.5, 2.5, -2.0, 4.0, -1.5, 3.0, -4.0, 1.5]
    private var rotation: Double { Self.rotations[index % Self.rotations.count] }

    var body: some View {
        #if canImport(UIKit)
        if let uiImage = UIImage(data: savedPola.imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 380)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: .black.opacity(0.6), radius: 12, x: 4, y: 6)
                .rotationEffect(.degrees(rotation))
                .transition(.identity)
        }
        #endif
    }
}
