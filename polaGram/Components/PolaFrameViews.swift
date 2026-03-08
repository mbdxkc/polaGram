//
//  PolaFrameViews.swift
//  polaGram
//
//  Pola frame components including interactive and static versions.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Pola Frame

/// Interactive pola frame with photo, caption, and development animation.
struct PolaFrame: View {
    let photoImage: Image?
    @Binding var caption: String
    let scale: CGFloat
    let onAddPhoto: () -> Void
    let onEditCaption: () -> Void
    let onClearPhoto: () -> Void
    let isDeveloping: Bool
    let developmentProgress: Double
    let activeFilter: PolaFilter?

    // Parallax offsets from device tilt (0 on macOS)
    var parallaxX: CGFloat = 0
    var parallaxY: CGFloat = 0

    @FocusState private var isCaptionFocused: Bool
    @State private var isFramePressed = false
    @State private var currentPlaceholder = PolaStrings.randomCaptionPlaceholder
    @State private var floatOffset: CGFloat = 0
    /// Filter opacity for fade-in after development completes
    @State private var filterOpacity: Double = 0.0

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
                        .overlay(
                            // Pola development overlay - white that fades away
                            Rectangle()
                                .fill(.white)
                                .opacity(isDeveloping ? 1.0 - developmentProgress : 0.0)
                                .allowsHitTesting(false)
                        )
                        .overlay(
                            // Development progress indicator (subtle bottom bar)
                            GeometryReader { geo in
                                if isDeveloping {
                                    VStack {
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Rectangle()
                                                .fill(Color.polaDateStamp.opacity(0.6))
                                                .frame(width: geo.size.width * developmentProgress)
                                            Spacer(minLength: 0)
                                        }
                                        .frame(height: 2)
                                    }
                                }
                            }
                        )
                        .overlay(
                            // "Shake it" UX Hint
                            Group {
                                if isDeveloping {
                                    Text("shake it")
                                        .font(.custom("Noteworthy-Bold", size: 28 * scale))
                                        .foregroundColor(.black.opacity(0.15 * (1.0 - developmentProgress)))
                                }
                            }
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    PlaceholderView(scale: scale)
                }

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
            .overlay(alignment: .topTrailing) {
                // Clear photo button (only when photo exists and not developing)
                if photoImage != nil && !isDeveloping {
                    Button {
                        #if canImport(UIKit)
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        #endif
                        onClearPhoto()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12 * scale, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 28 * scale, height: 28 * scale)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.5))
                            )
                    }
                    .accessibilityLabel(PolaStrings.clearPhotoLabel)
                    .accessibilityHint(PolaStrings.clearPhotoHint)
                    .padding(8 * scale)
                }
            }
            .padding(.top, PolaLayout.framePadding * scale)
            .padding(.horizontal, PolaLayout.framePadding * scale)
            .contentShape(Rectangle())
            .onTapGesture {
                if photoImage == nil {
                    onAddPhoto()
                }
            }

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
                scale: scale,
                onTap: onEditCaption
            )
            .padding(.horizontal, (PolaLayout.framePadding * scale) + (PolaLayout.baseRem * scale))
        }
        .frame(width: PolaLayout.frameWidth * scale, height: PolaLayout.frameHeight * scale)
        .background(
            Color.polaFrameBackground.overlay(
                // Realistic paper texture and wear effects
                PolaFrameTexture(
                    scale: scale,
                    photoAreaSize: CGSize(width: PolaLayout.photoSize * scale, height: PolaLayout.photoSize * scale),
                    photoAreaOffset: CGPoint(x: PolaLayout.framePadding * scale, y: PolaLayout.framePadding * scale)
                )
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale)
                .strokeBorder(
                    LinearGradient(colors: [.white.opacity(0.35), .clear, .black.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.5
                )
        )
        .cornerRadius(PolaLayout.cornerRadius * scale)
        .overlay(
            // Vintage Filter Overlay (on entire frame)
            PolaFilterOverlay(filter: activeFilter, scale: scale, opacity: filterOpacity)
        )
        .clipShape(RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale))
        .shadow(color: .black.opacity(0.4), radius: 35 * scale, x: 0, y: 18 * scale)
        .shadow(color: .black.opacity(0.2), radius: 12 * scale, x: 0, y: 6 * scale)
        .shadow(color: .black.opacity(0.1), radius: 3 * scale, x: 0, y: 2 * scale)
        .scaleEffect(isFramePressed ? 0.98 : 1.0)
        .offset(x: parallaxX, y: floatOffset + parallaxY)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFramePressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isFramePressed = true }
                .onEnded { _ in isFramePressed = false }
        )
        .accessibilityElement(children: .contain)
        .accessibilityHint(PolaStrings.addPhotoHint)
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                floatOffset = -5 * scale
            }
        }
        .onChange(of: isDeveloping) { wasDeveloping, isNowDeveloping in
            if wasDeveloping && !isNowDeveloping {
                // Development just finished - fade in the filter
                withAnimation(.easeIn(duration: 1.5)) {
                    filterOpacity = 1.0
                }
            } else if !wasDeveloping && isNowDeveloping {
                // New photo started developing - reset filter opacity
                filterOpacity = 0.0
            }
        }
    }
}

// MARK: - Static Pola Frame (for rendering/saving)

/// Simplified version of PolaFrame without bindings or callbacks.
/// Used by ImageRenderer to create saveable images.
struct StaticPolaFrame: View {
    let photoImage: Image?
    let caption: String
    let scale: CGFloat
    let activeFilter: PolaFilter?
    var showWatermark: Bool = false

    private let formattedDateString: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: Date())
    }()

    var body: some View {
        VStack(spacing: 0) {
            // Photo Area - uses frame background color for seamless look
            ZStack(alignment: .bottomTrailing) {
                Color.polaFrameBackground

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
                }

                // Date stamp
                if photoImage != nil {
                    Text(formattedDateString)
                        .font(.system(size: PolaLayout.dateStampSize * scale, weight: .medium, design: .monospaced))
                        .foregroundColor(.polaDateStamp.opacity(0.85))
                        .padding(.trailing, PolaLayout.dateStampTrailing * scale)
                        .padding(.bottom, PolaLayout.dateStampBottom * scale)
                }

                // Watermark (bottom-left)
                if showWatermark && photoImage != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Text("polaGram")
                                .font(.system(size: 8 * scale, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                                .padding(.leading, 6 * scale)
                                .padding(.bottom, 4 * scale)
                            Spacer()
                        }
                    }
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

            // Caption - faded, rubbed-off Sharpie aesthetic
            ZStack {
                if !caption.isEmpty {
                    let captionBoxHeight = PolaLayout.captionHeight * scale * 0.75
                    Text(caption)
                        .font(.custom("Noteworthy-Bold", size: captionBoxHeight * 0.85))
                        .foregroundColor(.black.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.3)
                        .lineSpacing(1 * scale)
                        .kerning(-0.5)
                        .blur(radius: 0.25)
                        .mask(
                            LinearGradient(
                                stops: [
                                    .init(color: .black.opacity(0.7), location: 0),
                                    .init(color: .black, location: 0.3),
                                    .init(color: .black.opacity(0.85), location: 0.6),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .black.opacity(0.75), location: 1.0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(Double.random(in: -4.0...4.0)))
                        .padding(.bottom, captionBoxHeight * 0.06)
                }
            }
            .frame(height: PolaLayout.captionHeight * scale * 0.82)
            .padding(.horizontal, (PolaLayout.framePadding * scale) + (PolaLayout.baseRem * scale))
        }
        .frame(width: PolaLayout.frameWidth * scale, height: PolaLayout.frameHeight * scale)
        .background(
            Color.polaFrameBackground.overlay(
                // Realistic paper texture (same as interactive frame)
                PolaFrameTexture(
                    scale: scale,
                    photoAreaSize: CGSize(width: PolaLayout.photoSize * scale, height: PolaLayout.photoSize * scale),
                    photoAreaOffset: CGPoint(x: PolaLayout.framePadding * scale, y: PolaLayout.framePadding * scale)
                )
            )
        )
        .overlay(
            // Vintage filter overlay (coffee stains, folds, etc.)
            PolaFilterOverlay(filter: activeFilter, scale: scale)
        )
        .clipShape(RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale))
        .overlay(
            RoundedRectangle(cornerRadius: PolaLayout.cornerRadius * scale)
                .strokeBorder(
                    LinearGradient(colors: [.white.opacity(0.35), .clear, .black.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.5
                )
        )
    }
}

// MARK: - WornText

/// Broken Hemingway typewriter effect for caption text.
/// Each character gets individual styling to simulate imperfect handwriting.
struct WornText: View {
    let text: String
    let maxFontSize: CGFloat
    let rotation: Double
    let availableWidth: CGFloat

    // Seed for deterministic randomness (based on text hash)
    private var seed: Int {
        text.hashValue & 0x7FFFFFFF
    }

    // Calculate font size that fills the caption box
    private var calculatedFontSize: CGFloat {
        let charWidthRatio: CGFloat = 0.48
        let maxCharsPerLine = availableWidth / (maxFontSize * charWidthRatio)

        if CGFloat(text.count) <= maxCharsPerLine {
            return maxFontSize
        }

        let scaleFactor = maxCharsPerLine / CGFloat(text.count)
        return max(maxFontSize * scaleFactor, maxFontSize * 0.35)
    }

    var body: some View {
        let fontSize = calculatedFontSize
        let textSeed = seed

        // Bold compensation: smaller text gets heavier ink
        let scaleFactor = fontSize / maxFontSize
        let boldBoost = 1.0 - scaleFactor

        let blurRadius = max(0.1, 0.3 - (boldBoost * 0.2))
        let shadowOpacity = 0.05 + (boldBoost * 0.12)

        VStack(alignment: .center, spacing: fontSize * 0.05) {
            ForEach(text.split(separator: "\n").map(String.init), id: \.self) { line in
                HStack(spacing: 0) {
                    ForEach(Array(line.enumerated()), id: \.offset) { idx, ch in
                        let char = String(ch)
                        let style = CharStyle(index: idx, seed: textSeed)

                        // Apply bold boost to ink density
                        let boostedInk = min(1.0, style.inkDensity + (boldBoost * 0.25))

                        // Scale baseline drop by font size
                        let scaledDrop = style.baselineDrop * fontSize

                        // Letter spacing based on type
                        let letterSpacing: CGFloat = {
                            switch style.spacingType {
                            case 0: return -fontSize * 0.08
                            case 1: return -fontSize * 0.04
                            case 2: return fontSize * 0.01
                            default: return fontSize * 0.03
                            }
                        }()

                        Text(char)
                            .font(.custom("Noteworthy-Bold", size: fontSize))
                            .foregroundColor(Color.black.opacity(0.9))
                            .opacity(boostedInk)
                            .baselineOffset(-scaledDrop)
                            .rotationEffect(.degrees(style.tilt))
                            .offset(x: style.xJitter * fontSize)
                            .blur(radius: blurRadius)
                            .shadow(color: .black.opacity(shadowOpacity), radius: 0.3, x: 0.5, y: 0.5)
                            .blendMode(.multiply)
                            .padding(.leading, idx == 0 ? 0 : letterSpacing)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
        .lineLimit(3)
        .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Placeholder View

/// Placeholder shown when no photo is selected.
struct PlaceholderView: View {
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
        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(PolaStrings.photoPlaceholderLabel)
        .accessibilityHint(PolaStrings.addPhotoHint)
    }
}

// MARK: - Caption Area

/// Caption display and edit area on the pola frame.
struct CaptionArea: View {
    @Binding var caption: String
    @FocusState.Binding var isCaptionFocused: Bool
    let currentPlaceholder: String
    let scale: CGFloat
    let onTap: () -> Void

    @State private var placeholderOpacity: Double = 0.22
    @State private var placeholderRotation: Double = 0
    @State private var userTextRotation: Double = 0

    var body: some View {
        ZStack {
            if caption.isEmpty {
                Text(currentPlaceholder)
                    .font(.custom("AvenirNextCondensed-Light", size: PolaLayout.placeholderTextSize * scale))
                    .foregroundColor(.black.opacity(0.25))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(2 * scale)
                    .kerning(0.5)
                    .blur(radius: 0.35)
                    .rotationEffect(.degrees(placeholderRotation))
                    .padding(.bottom, 4 * scale)
                    .onAppear {
                        placeholderOpacity = 0.22
                        placeholderRotation = Double.random(in: -1.2...1.2)
                    }
            } else {
                // Broken Hemingway typewriter aesthetic
                GeometryReader { geo in
                    let verticalPadding = geo.size.height * 0.12
                    let usableHeight = geo.size.height - (verticalPadding * 2)

                    WornText(
                        text: caption,
                        maxFontSize: usableHeight * 0.85,
                        rotation: userTextRotation,
                        availableWidth: geo.size.width
                    )
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .padding(.bottom, geo.size.height * 0.06)
                    .onAppear {
                        if userTextRotation == 0 && !caption.isEmpty {
                            userTextRotation = Double.random(in: -4.0...4.0)
                        }
                    }
                }
            }
        }
        .frame(height: PolaLayout.captionHeight * scale * 0.82)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .accessibilityHint(PolaStrings.captionAccessibilityHint)
    }
}
