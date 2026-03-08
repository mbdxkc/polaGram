//
//  CharStyle.swift
//  polaGram
//
//  Deterministic pseudo-random character styling for WornText effect.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI

// ═══════════════════════════════════════════════════════════════════════════
// MARK: - CharStyle (Deterministic Pseudo-Random)
// ═══════════════════════════════════════════════════════════════════════════
/// Generates per-character styling for WornText's typewriter effect.
///
/// Each character gets unique styling based on its position (index) and
/// the text content (seed). This creates the "broken typewriter" effect
/// while ensuring:
///
/// 1. **Determinism**: Same text always renders the same way
/// 2. **Performance**: No random() calls in view body
/// 3. **Testability**: Outputs can be verified in unit tests
///
/// Properties Generated:
/// ┌─────────────┬──────────────────┬─────────────────────────┐
/// │ Property    │ Range            │ Effect                  │
/// ├─────────────┼──────────────────┼─────────────────────────┤
/// │ inkDensity  │ 0.45 - 0.85      │ Opacity (worn ribbon)   │
/// │ baselineDrop│ -0.03 - 0.18     │ Vertical offset (stuck) │
/// │ tilt        │ -4.8° - +4.8°    │ Rotation (misaligned)   │
/// │ spacingType │ 0-4              │ Letter spacing variant  │
/// │ xJitter     │ ±0.02            │ Horizontal jitter       │
/// └─────────────┴──────────────────┴─────────────────────────┘
///
/// Algorithm:
/// Uses bit-shifted hash of (index × 31 + seed) to generate stable values.
/// The seed comes from the text string's hashValue.
struct CharStyle {
    /// Ink density/opacity for this character (0.45 - 0.85)
    let inkDensity: Double

    /// Vertical baseline offset (positive = dropped below baseline)
    let baselineDrop: CGFloat

    /// Rotation angle in degrees (-4.8 to +4.8)
    let tilt: Double

    /// Letter spacing variant (0-4, maps to different spacing amounts)
    let spacingType: Int

    /// Horizontal position jitter (subtle carriage slip effect)
    let xJitter: CGFloat

    /// Generates character style from position and text seed.
    ///
    /// - Parameters:
    ///   - index: Character position in the string (0-based)
    ///   - seed: Hash value derived from the full text string
    ///
    /// - Note: Unit tests in CharStyleTests.swift verify determinism and bounds.
    init(index: Int, seed: Int) {
        // Generate stable hash from index and seed
        // Multiplier 31 spreads values well; mask ensures positive
        let hash = (index * 31 + seed) & 0x7FFFFFFF

        // Extract different values from different bit ranges of hash
        // This gives us multiple "random" values from one hash

        // Ink density: 0.45 + (0-39)/100 = 0.45 - 0.84
        inkDensity = 0.45 + Double((hash % 40)) / 100.0

        // Tilt: (0-95 - 48) / 10 = -4.8 to +4.7 degrees
        tilt = Double((hash >> 4) % 96 - 48) / 10.0

        // Spacing type: 0-4 (used to select spacing variant in WornText)
        spacingType = (hash >> 8) % 5

        // X jitter: (0-19 - 10) / 500 = -0.02 to +0.018
        xJitter = CGFloat((hash >> 12) % 20 - 10) / 500.0

        // Stuck key effect: ~12.5% of characters (1 in 8)
        // These characters drop noticeably below baseline
        let isStuckKey = (hash >> 16) % 8 == 0

        if isStuckKey {
            // Stuck: drop 8-17% of font size below baseline
            baselineDrop = CGFloat((hash >> 20) % 10 + 8) / 100.0
        } else {
            // Normal: slight variation -3% to +4%
            baselineDrop = CGFloat((hash >> 20) % 8 - 3) / 100.0
        }
    }
}
