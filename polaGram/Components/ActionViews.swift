//
//  ActionViews.swift
//  polaGram
//
//  Bottom action menu and button components.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Action Menu

/// Bottom action bar with share, save, and gallery buttons.
struct ActionMenu: View {
    let scale: CGFloat
    let hasPhoto: Bool
    let onMessage: () -> Void
    let onInstagram: () -> Void
    let onSave: () -> Void
    let onGallery: () -> Void
    @Binding var showWatermark: Bool

    @State private var showWatermarkIndicator = false

    var body: some View {
        HStack(spacing: 0) {
            ActionButton(icon: "message.fill", label: PolaStrings.messageButton, accessibilityLabel: PolaStrings.shareViaMessagesLabel, scale: scale, isEnabled: hasPhoto, action: onMessage)
            Spacer()
            ActionButton(icon: "camera.fill", label: PolaStrings.instagramButton, accessibilityLabel: PolaStrings.shareToInstagramLabel, scale: scale, isEnabled: hasPhoto, action: onInstagram)
            Spacer()
            // Save button with watermark toggle on long press
            ActionButton(icon: "square.and.arrow.down.fill", label: PolaStrings.saveButton, accessibilityLabel: PolaStrings.saveToPhotosLabel, scale: scale, isEnabled: hasPhoto, action: onSave)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            showWatermark.toggle()
                            showWatermarkIndicator = true
                            SoundManager.shared.playHaptic(.light)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showWatermarkIndicator = false
                            }
                        }
                )
            Spacer()
            ActionButton(icon: "square.grid.2x2", label: PolaStrings.galleryButton, accessibilityLabel: PolaStrings.galleryLabel, scale: scale, isEnabled: true, action: onGallery)
        }
        .frame(width: PolaLayout.frameWidth * scale, height: PolaLayout.menuHeight * scale)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Actions")
        .overlay(
            // Watermark toggle feedback
            Group {
                if showWatermarkIndicator {
                    Text(showWatermark ? "Watermark ON" : "Watermark OFF")
                        .font(.polaBodyBold(size: 12 * scale))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12 * scale)
                        .padding(.vertical, 6 * scale)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8 * scale)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: showWatermarkIndicator)
        )
    }
}

// MARK: - Action Button

/// Individual action button with ripple effect.
struct ActionButton: View {
    let icon: String
    let label: String
    let accessibilityLabel: String
    let scale: CGFloat
    let isEnabled: Bool
    let action: () -> Void

    @State private var isPressed = false
    @State private var rippleScale: CGFloat = 0
    @State private var rippleOpacity: Double = 0

    var body: some View {
        VStack(spacing: 8 * scale) {
            ZStack {
                // Ripple effect
                Circle()
                    .fill(Color.polaPink.opacity(0.3))
                    .scaleEffect(rippleScale)
                    .opacity(rippleOpacity)
                    .frame(width: 50 * scale, height: 50 * scale)

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
            }

            Text(label)
                .font(.polaBodyBold(size: 14 * scale))
                .foregroundColor(isPressed ? .polaPinkLight : .white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
        }
        .opacity(isEnabled ? 1.0 : 0.4)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Double tap to \(label)")
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        .allowsHitTesting(isEnabled)
        .onTapGesture {
            if isEnabled {
                // Trigger ripple animation
                triggerRipple()
                action()
                #if canImport(UIKit)
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                #endif
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if isEnabled { isPressed = true } }
                .onEnded { _ in isPressed = false }
        )
    }

    private func triggerRipple() {
        rippleScale = 0.5
        rippleOpacity = 0.6

        withAnimation(.easeOut(duration: 0.4)) {
            rippleScale = 2.0
            rippleOpacity = 0
        }
    }
}
