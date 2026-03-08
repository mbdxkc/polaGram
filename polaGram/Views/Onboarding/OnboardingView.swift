//
//  OnboardingView.swift
//  polaGram
//
//  First-time user tutorial. Shows 4 steps: Capture, Develop, Caption, Share.
//  Displayed once after splash screen, persisted via @AppStorage.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentStep = 0

    private let steps: [(icon: String, title: String, description: String)] = [
        ("camera.viewfinder", "Capture", "Tap the pola frame to take a photo or choose from your library"),
        ("iphone.radiowaves.left.and.right", "Develop", "Watch your photo develop like a real instant pic. Shake to speed it up!"),
        ("pencil.line", "Caption", "Tap below the photo to add a handwritten caption"),
        ("square.and.arrow.up", "Share", "Save to Photos, send via Messages, or share to Instagram Stories")
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture { nextStep() }

            VStack(spacing: 32) {
                Spacer()
                tutorialCard
                Spacer()
                navigationButtons
            }
        }
        .transition(.opacity)
    }

    // MARK: - Tutorial Card

    private var tutorialCard: some View {
        VStack(spacing: 24) {
            stepIndicator

            Image(systemName: steps[currentStep].icon)
                .font(.system(size: 60, weight: .light))
                .foregroundStyle(
                    LinearGradient(colors: [.polaPinkLight, .polaPink], startPoint: .top, endPoint: .bottom)
                )
                .frame(height: 80)
                .id(currentStep)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))

            Text(steps[currentStep].title)
                .font(.polaTitle(size: 28))
                .foregroundColor(.white)

            Text(steps[currentStep].description)
                .font(.polaBody(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom),
                            lineWidth: 1
                        )
                )
        )
    }

    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<steps.count, id: \.self) { index in
                Circle()
                    .fill(index == currentStep ? Color.polaPink : Color.white.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentStep ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentStep)
            }
        }
    }

    // MARK: - Navigation

    private var navigationButtons: some View {
        HStack {
            Button {
                SoundManager.shared.playHaptic(.light)
                dismiss()
            } label: {
                Text("Skip")
                    .font(.polaBody(size: 16))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(width: 80)

            Spacer()

            Button { nextStep() } label: {
                Text(currentStep < steps.count - 1 ? "Next" : "Get Started")
                    .font(.polaBodyBold(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(
                            LinearGradient(colors: [.polaPink, .polaPinkLight], startPoint: .leading, endPoint: .trailing)
                        )
                    )
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 48)
    }

    // MARK: - Actions

    private func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) { currentStep += 1 }
            SoundManager.shared.playHaptic(.light)
        } else {
            dismiss()
        }
    }

    private func dismiss() {
        SoundManager.shared.playHaptic(.success)
        hasSeenOnboarding = true
        withAnimation(.easeOut(duration: 0.3)) { isPresented = false }
    }
}
