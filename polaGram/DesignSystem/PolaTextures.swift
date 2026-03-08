//
//  PolaTextures.swift
//  polaGram
//
//  Realistic paper texture and frame effects.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI

// ═══════════════════════════════════════════════════════════════════════════
// MARK: - Pola Frame Texture
// ═══════════════════════════════════════════════════════════════════════════
/// Adds realistic paper texture and wear to the pola frame.
///
/// Layers multiple subtle effects to simulate authentic matte photo paper:
/// - Paper fiber texture (noise pattern)
/// - Edge wear from handling (vignette darkening)
/// - Subtle color variation (breaks up flat white)
/// - Micro-scratches on surface
/// - Embossed border around photo area
/// - Physical thickness with inner shadows
///
/// Usage:
/// ```swift
/// Color.polaFrameBackground
///     .overlay(PolaFrameTexture(scale: scale, photoAreaRect: photoRect))
/// ```
struct PolaFrameTexture: View {
    let scale: CGFloat
    /// The rect of the photo area for embossed border positioning
    let photoAreaSize: CGSize
    let photoAreaOffset: CGPoint

    // Texture colors
    private let wearColor = Color(red: 0.75, green: 0.72, blue: 0.68)
    private let scratchColor = Color(red: 0.85, green: 0.82, blue: 0.78)

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            ZStack {
                // ─────────────────────────────────────────────────────────────
                // Layer 1: Subtle color variation (warm gradient)
                // ─────────────────────────────────────────────────────────────
                // Breaks up the flat white with slight warmth toward center
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 0.99, blue: 0.96).opacity(0.4),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: max(size.width, size.height) * 0.7
                )

                // ─────────────────────────────────────────────────────────────
                // Layer 2: Edge wear vignette (handling marks)
                // ─────────────────────────────────────────────────────────────
                // Edges are slightly darker from being touched/held
                Rectangle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.clear,
                                Color.clear,
                                wearColor.opacity(0.04),
                                wearColor.opacity(0.08)
                            ],
                            center: .center,
                            startRadius: min(size.width, size.height) * 0.3,
                            endRadius: max(size.width, size.height) * 0.7
                        )
                    )

                // ─────────────────────────────────────────────────────────────
                // Layer 3: Paper fiber texture (noise simulation)
                // ─────────────────────────────────────────────────────────────
                // Overlapping semi-transparent shapes create noise-like texture
                Canvas { context, canvasSize in
                    // Deterministic "noise" using grid of varied opacity dots
                    let gridSize: CGFloat = 4
                    let cols = Int(canvasSize.width / gridSize)
                    let rows = Int(canvasSize.height / gridSize)

                    for row in 0..<rows {
                        for col in 0..<cols {
                            // Pseudo-random based on position
                            let hash = (row * 31 + col * 17) & 0xFF
                            let opacity = Double(hash) / 255.0 * 0.025

                            let rect = CGRect(
                                x: CGFloat(col) * gridSize,
                                y: CGFloat(row) * gridSize,
                                width: gridSize,
                                height: gridSize
                            )
                            context.fill(
                                Path(ellipseIn: rect.insetBy(dx: 1, dy: 1)),
                                with: .color(.black.opacity(opacity))
                            )
                        }
                    }
                }
                .blendMode(.multiply)

                // ─────────────────────────────────────────────────────────────
                // Layer 4: Micro-scratches
                // ─────────────────────────────────────────────────────────────
                // Very faint surface wear from handling
                Canvas { context, canvasSize in
                    let scratches: [(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)] = [
                        (0.15, 0.20, 0.45, 0.22, 0.015),
                        (0.70, 0.35, 0.85, 0.38, 0.012),
                        (0.25, 0.75, 0.55, 0.73, 0.018),
                        (0.80, 0.85, 0.95, 0.82, 0.010),
                        (0.05, 0.50, 0.20, 0.52, 0.014),
                        (0.60, 0.10, 0.75, 0.08, 0.016),
                    ]

                    for scratch in scratches {
                        var path = Path()
                        path.move(to: CGPoint(x: canvasSize.width * scratch.0, y: canvasSize.height * scratch.1))
                        path.addLine(to: CGPoint(x: canvasSize.width * scratch.2, y: canvasSize.height * scratch.3))
                        context.stroke(
                            path,
                            with: .color(scratchColor.opacity(scratch.4)),
                            lineWidth: 0.5 * scale
                        )
                    }
                }

                // ─────────────────────────────────────────────────────────────
                // Layer 5: Physical thickness (edge highlights only)
                // ─────────────────────────────────────────────────────────────
                // Subtle light-catching on bottom/right edges

                VStack(spacing: 0) {
                    Spacer()
                    // Bottom edge highlight (light catching raised edge)
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 1.5 * scale)
                }

                HStack(spacing: 0) {
                    Spacer()
                    // Right edge highlight
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.10)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 1 * scale)
                }

                // ─────────────────────────────────────────────────────────────
                // Layer 6: Embossed border around photo area
                // ─────────────────────────────────────────────────────────────
                // Raised ridge where photo meets frame
                embossedPhotoBorder(frameSize: size)
            }
        }
        .allowsHitTesting(false)
    }

    /// Creates a subtle embossed border effect around the photo area
    @ViewBuilder
    private func embossedPhotoBorder(frameSize: CGSize) -> some View {
        let inset = PolaLayout.framePadding * scale
        let photoSize = photoAreaSize.width

        ZStack {
            // Subtle highlight on bottom and right edges of photo cutout
            // Bottom highlight
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.12)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: photoSize, height: 1 * scale)
                .position(x: frameSize.width / 2, y: inset + photoSize - 0.5 * scale)

            // Right highlight
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.08)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 1.5 * scale, height: photoSize)
                .position(x: frameSize.width - inset - 0.75 * scale, y: inset + photoSize / 2)
        }
    }
}

