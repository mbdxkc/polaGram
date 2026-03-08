//
//  SoundManager.swift
//  polaGram
//
//  Provides audio and haptic feedback using iOS system sounds.
//  Note: System sounds require physical device with ringer on.
//

import AVFoundation
import AudioToolbox
#if canImport(UIKit)
import UIKit
#endif

final class SoundManager {
    static let shared = SoundManager()
    var soundsEnabled = true

    // iOS system sound IDs - see iphonedev.wiki/AudioServices
    private enum Sound: SystemSoundID {
        case shutter = 1108
        case tock = 1104
        case swoosh = 1001
        case success = 1407
    }

    private init() {
        #if canImport(UIKit)
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    // MARK: - Sounds

    /// Splash screen: camera click + swoosh
    func playWelcome() {
        guard soundsEnabled else { return }
        #if canImport(UIKit)
        AudioServicesPlaySystemSound(Sound.shutter.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            AudioServicesPlaySystemSound(Sound.swoosh.rawValue)
        }
        #endif
    }

    /// Photo capture shutter
    func playShutter() {
        guard soundsEnabled else { return }
        #if canImport(UIKit)
        AudioServicesPlaySystemSound(Sound.shutter.rawValue)
        #endif
    }

    /// Development animation tick
    func playDevelopTick() {
        guard soundsEnabled else { return }
        #if canImport(UIKit)
        AudioServicesPlaySystemSound(Sound.tock.rawValue)
        #endif
    }

    /// Save confirmation
    func playSaveConfirmation() {
        guard soundsEnabled else { return }
        #if canImport(UIKit)
        AudioServicesPlaySystemSound(Sound.success.rawValue)
        #endif
    }

    /// Swoosh sound for share/send completion
    func playSwoosh() {
        guard soundsEnabled else { return }
        #if canImport(UIKit)
        AudioServicesPlaySystemSound(Sound.swoosh.rawValue)
        #endif
    }

    // MARK: - Haptics

    enum HapticStyle { case light, medium, success }

    func playHaptic(_ style: HapticStyle = .light) {
        #if canImport(UIKit)
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        #endif
    }
}
