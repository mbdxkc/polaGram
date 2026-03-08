//
//  Layout.swift
//  polaGram
//
//  Layout constants for consistent spacing and sizing.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI

// MARK: - Layout Tokens

struct PolaLayout {

    // ─────────────────────────────────────────────────────────────────────────
    // Pola Frame Dimensions
    // ─────────────────────────────────────────────────────────────────────────

    static let frameWidth: CGFloat = 312
    static let frameHeight: CGFloat = 392
    static let photoSize: CGFloat = 280

    // ─────────────────────────────────────────────────────────────────────────
    // Spacing & Padding
    // ─────────────────────────────────────────────────────────────────────────

    static let framePadding: CGFloat = 16
    static let captionHeight: CGFloat = 80
    static let headerTopPadding: CGFloat = 60
    static let baseRem: CGFloat = 16

    // ─────────────────────────────────────────────────────────────────────────
    // Visual Details
    // ─────────────────────────────────────────────────────────────────────────

    static let cornerRadius: CGFloat = 5
    static let borderWidth: CGFloat = 1
    static let dividerOpacity: Double = 0.08
    static let backgroundPinkOpacity: Double = 0.06
    static let frameTextureOpacity: Double = 0.02
    static let filmGrainOpacity: Double = 0.03

    // ─────────────────────────────────────────────────────────────────────────
    // Typography Sizes
    // ─────────────────────────────────────────────────────────────────────────

    static let titleSize: CGFloat = 48
    static let subtitleSize: CGFloat = 18
    static let dateStampSize: CGFloat = 11
    static let placeholderTextSize: CGFloat = 13

    // ─────────────────────────────────────────────────────────────────────────
    // Date Stamp Position
    // ─────────────────────────────────────────────────────────────────────────

    static let dateStampTrailing: CGFloat = 12
    static let dateStampBottom: CGFloat = 10

    // ─────────────────────────────────────────────────────────────────────────
    // Action Menu
    // ─────────────────────────────────────────────────────────────────────────

    static let menuHeight: CGFloat = 80
    static let menuIconSize: CGFloat = 28
    static let menuSpacing: CGFloat = 50
    static let menuBottomPadding: CGFloat = 20

    // ─────────────────────────────────────────────────────────────────────────
    // Responsive Scaling
    // ─────────────────────────────────────────────────────────────────────────

    static let referenceWidth: CGFloat = 360
    static let minScale: CGFloat = 0.85
    static let maxScale: CGFloat = 1.3
}
