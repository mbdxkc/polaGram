//
//  Fonts.swift
//  polaGram
//
//  Custom typography helpers using system-bundled fonts.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI

// MARK: - Font Tokens

extension Font {

    /// Handwritten style for headers and branding.
    static func polaTitle(size: CGFloat = 36) -> Font {
        .custom("BradleyHandITCTT-Bold", size: size)
    }

    /// Clean condensed font for body text and labels.
    static func polaBody(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Regular", size: size)
    }

    /// Bold condensed font for buttons and emphasis.
    static func polaBodyBold(size: CGFloat = 14) -> Font {
        .custom("AvenirNextCondensed-Bold", size: size)
    }
}
