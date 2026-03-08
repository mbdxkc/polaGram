//
//  Colors.swift
//  polaGram
//
//  Color palette for polaGram's visual identity.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Color Tokens

extension Color {

    // ─────────────────────────────────────────────────────────────────────────
    // Brand Colors - Balanced Pink/Coral Scheme
    // ─────────────────────────────────────────────────────────────────────────

    /// Medium pink - primary brand color (softened)
    /// Hex: #E87DA0 (Dusty Rose)
    static let polaPink = Color(red: 0.91, green: 0.49, blue: 0.63)

    /// Light pink - highlights, button glow states (warmer)
    /// Hex: #F4B8C5 (Blush)
    static let polaPinkLight = Color(red: 0.96, green: 0.72, blue: 0.77)

    /// Hot/vivid pink - active states, emphasis (coral tint)
    /// Hex: #E85A7E (Coral Rose)
    static let polaPinkHot = Color(red: 0.91, green: 0.35, blue: 0.49)

    // ─────────────────────────────────────────────────────────────────────────
    // Background Colors - Balanced Moody Gradient
    // ─────────────────────────────────────────────────────────────────────────

    /// Gradient center - warm gray with subtle warmth
    static let polaGradientCenter = Color(red: 0.55, green: 0.53, blue: 0.55)

    /// Gradient middle - muted mauve
    static let polaGradientMid = Color(red: 0.29, green: 0.25, blue: 0.29)

    /// Gradient edge - deep charcoal with warmth
    static let polaGradientEdge = Color(red: 0.18, green: 0.16, blue: 0.18)

    // ─────────────────────────────────────────────────────────────────────────
    // UI Accents - Silver/Blue Tones
    // ─────────────────────────────────────────────────────────────────────────

    /// Light silver - primary text, icons
    static let polaSilverLight = Color(red: 0.85, green: 0.88, blue: 0.92)

    /// Dark silver - secondary text, subtle elements
    static let polaSilverDark = Color(red: 0.75, green: 0.80, blue: 0.88)

    // ─────────────────────────────────────────────────────────────────────────
    // Frame Colors - Pola Aesthetics (Dark Mode Aware)
    // ─────────────────────────────────────────────────────────────────────────

    /// Pola frame background - cream white
    static let polaFrameBackground = Color(
        light: Color(red: 0.99, green: 0.98, blue: 0.94),
        dark:  Color(red: 0.96, green: 0.95, blue: 0.91)
    )

    /// Photo area background - visible when no photo loaded
    static let polaPhotoBackground = Color(
        light: Color(red: 0.96, green: 0.95, blue: 0.92),
        dark:  Color(red: 0.13, green: 0.12, blue: 0.11)
    )

    // ─────────────────────────────────────────────────────────────────────────
    // Accent Colors
    // ─────────────────────────────────────────────────────────────────────────

    /// Date stamp color - orange/peach tone
    static let polaDateStamp = Color(red: 0.91, green: 0.61, blue: 0.42)

    // ─────────────────────────────────────────────────────────────────────────
    // Adaptive Color Helper
    // ─────────────────────────────────────────────────────────────────────────

    /// Creates an adaptive color that changes based on light/dark mode.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self.init(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}
