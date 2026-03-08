//
//  ShakeDetector.swift
//  polaGram
//
//  CoreMotion observers for shake detection and parallax effects.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
import CoreMotion
import Combine

// MARK: - Shake Detector

/// Monitors the device accelerometer for shake gestures.
/// Used to accelerate the photo development animation.
class ShakeDetector: ObservableObject {
    private let motionManager = CMMotionManager()
    private var cancellables = Set<AnyCancellable>()

    @Published var shakeIntensity: Double = 0.0

    init() {
        startDetecting()
    }

    deinit {
        stopDetecting()
    }

    private func startDetecting() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 0.1

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil else { return }

            let acceleration = data.acceleration
            let magnitude = sqrt(
                pow(acceleration.x, 2) +
                pow(acceleration.y, 2) +
                pow(acceleration.z, 2)
            )

            if magnitude > 2.0 {
                let intensity = min((magnitude - 2.0) / 2.0, 1.0)
                self?.shakeIntensity = intensity
            } else {
                self?.shakeIntensity = 0.0
            }
        }
    }

    private func stopDetecting() {
        motionManager.stopAccelerometerUpdates()
    }
}

// MARK: - Parallax Manager

/// Tracks device orientation for subtle parallax effects on the pola frame.
class ParallaxManager: ObservableObject {
    private let motionManager = CMMotionManager()

    @Published var xOffset: CGFloat = 0
    @Published var yOffset: CGFloat = 0

    private let maxOffset: CGFloat = 10

    init() {
        startTracking()
    }

    deinit {
        stopTracking()
    }

    private func startTracking() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion, error == nil else { return }

            let roll = motion.attitude.roll
            let pitch = motion.attitude.pitch

            let targetX = CGFloat(-roll) * 15
            let targetY = CGFloat(pitch - 0.5) * 12

            withAnimation(.easeOut(duration: 0.15)) {
                self.xOffset = max(-self.maxOffset, min(self.maxOffset, targetX))
                self.yOffset = max(-self.maxOffset, min(self.maxOffset, targetY))
            }
        }
    }

    private func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
}

#endif
