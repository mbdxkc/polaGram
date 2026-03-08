//
//  BackgroundViews.swift
//  polaGram
//
//  Animated background gradient and film grain overlay.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI

// MARK: - Pola Background

/// Animated gradient background with vignette effects.
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

/// Subtle film grain texture overlay.
struct FilmGrainOverlay: View {
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.02))
            .blendMode(.overlay)
            .drawingGroup()
    }
}
