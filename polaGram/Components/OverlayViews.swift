//
//  OverlayViews.swift
//  polaGram
//
//  Splash screen and caption editor overlay views.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Splash Screen

/// Animated splash screen shown on app launch.
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
            // Play welcome snap sound
            SoundManager.shared.playWelcome()

            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.6)) { textOpacity = 1.0 }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(PolaStrings.splashScreenLabel)
        .accessibilityHint(PolaStrings.splashScreenHint)
    }
}

// MARK: - Caption Editor Overlay

/// Minimal overlay for editing caption text.
/// Keeps the pola frame visible beneath.
struct CaptionEditorOverlay: View {
    @Binding var caption: String
    @Binding var isPresented: Bool
    @State private var editedCaption: String = ""

    private func scaleFactor(for size: CGSize) -> CGFloat {
        let base = size.width / PolaLayout.referenceWidth
        return min(max(base, PolaLayout.minScale), PolaLayout.maxScale)
    }

    var body: some View {
        GeometryReader { geometry in
            let scale = scaleFactor(for: geometry.size)

            ZStack {
                // Semi-transparent backdrop - pola frame shows through
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        SoundManager.shared.playHaptic(.light)
                        isPresented = false
                    }

                VStack {
                    Spacer()

                    // Floating caption card
                    VStack(spacing: 16 * scale) {
                        // Header
                        HStack {
                            Text("say something")
                                .font(.custom("AvenirNext-Regular", size: 24 * scale))
                                .foregroundColor(.black.opacity(0.8))

                            Spacer()

                            Text("\(editedCaption.count)/24")
                                .font(.custom("AvenirNext-Regular", size: 14 * scale))
                                .foregroundColor(editedCaption.count > 20 ? .polaPinkHot : .gray)
                                .animation(.easeInOut(duration: 0.2), value: editedCaption.count > 20)
                        }

                        // Simple TextField instead of TextEditor
                        TextField("type here...", text: $editedCaption)
                            .font(.custom("AvenirNextCondensed-Light", size: 22 * scale))
                            .foregroundColor(.black.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18 * scale)
                            .padding(.horizontal, 20 * scale)
                            .background(
                                RoundedRectangle(cornerRadius: 8 * scale)
                                    .fill(Color.white)
                            )
                            #if canImport(UIKit)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            #endif
                            .onChange(of: editedCaption) { _, newValue in
                                if newValue.count > 24 {
                                    editedCaption = String(newValue.prefix(24))
                                    #if canImport(UIKit)
                                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                                    generator.impactOccurred()
                                    #endif
                                }
                            }

                        // Buttons
                        HStack(spacing: 12 * scale) {
                            Button {
                                SoundManager.shared.playHaptic(.light)
                                isPresented = false
                            } label: {
                                Text("cancel")
                                    .font(.polaBodyBold(size: 16 * scale))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(14 * scale)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8 * scale)
                                            .fill(Color.white.opacity(0.8))
                                    )
                            }

                            Button {
                                caption = editedCaption
                                SoundManager.shared.playHaptic(.success)
                                isPresented = false
                            } label: {
                                Text("done")
                                    .font(.polaBodyBold(size: 16 * scale))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(14 * scale)
                                    .background(
                                        LinearGradient(
                                            colors: [.polaPink, .polaPinkHot],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(8 * scale)
                            }
                        }
                    }
                    .padding(20 * scale)
                    .background(
                        RoundedRectangle(cornerRadius: 16 * scale)
                            .fill(Color.polaFrameBackground)
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
                    )
                    .padding(.horizontal, 16 * scale)
                    .padding(.bottom, max(20 * scale, geometry.safeAreaInsets.bottom + 10))
                }
            }
        }
        .onAppear {
            editedCaption = caption
        }
    }
}
