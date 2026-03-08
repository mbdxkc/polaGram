//
//  ChampagneBubbles.swift
//  polaGram
//
//  Animated particle system for festive champagne bubble effect.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI

// MARK: - Champagne Bubbles

/// Creates a festive champagne bubble effect that rises from the bottom of
/// the screen and converges toward the center.
struct ChampagneBubbles: View {
    @State private var bubbles: [Bubble] = []
    @State private var spawnCounter: Int = 0
    @State private var spawnEveryNFrames: Int = 1
    @State private var bubbleTimer: Timer? = nil

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
            }
            .onDisappear {
                // Fix: Invalidate timer when view disappears to prevent memory leak
                bubbleTimer?.invalidate()
                bubbleTimer = nil
            }
        }
        .allowsHitTesting(false)
    }

    private func startBubbleStream(screenSize: CGSize) {
        guard bubbles.isEmpty || spawnEveryNFrames == 0 else { return }

        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true) { _ in
            spawnCounter += 1

            if spawnCounter >= spawnEveryNFrames {
                spawnCounter = 0

                let newBubble = Bubble(
                    id: UUID(),
                    startX: CGFloat.random(in: 0...screenSize.width),
                    screenHeight: screenSize.height,
                    screenWidth: screenSize.width
                )
                bubbles.append(newBubble)

                if bubbles.count > 150 {
                    bubbles.removeFirst()
                }
            }

            if spawnEveryNFrames < 5 && Int.random(in: 0...30) == 0 {
                spawnEveryNFrames += 1
            }
        }
    }
}

// MARK: - Bubble Model

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

// MARK: - Bubble View

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
