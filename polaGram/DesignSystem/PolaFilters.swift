//
//  PolaFilters.swift
//  polaGram
//
//  Vintage filter effects that make polas look aged, worn, and lived-in.
//  Extracted from DesignTokens.swift for maintainability.
//

import SwiftUI

// ═══════════════════════════════════════════════════════════════════════════
// MARK: - Pola Filters (Vintage/Worn Effects)
// ═══════════════════════════════════════════════════════════════════════════
/// Vintage filter effects that make polas look aged, worn, and lived-in.
///
/// 50% of photos get no filter (pristine), 50% get a random effect.
/// Effects include: coffee stains, burn marks, folds, water damage, etc.
///
/// Usage:
/// ```swift
/// @State private var activeFilters: [PolaFilter] = []
///
/// // On photo load:
/// activeFilters = PolaFilter.randomFilters()
///
/// // In view:
/// photoImage.overlay(PolaFilterOverlay(filters: activeFilters, scale: scale))
/// ```
enum PolaFilter: Int, CaseIterable {
    // ─────────────────────────────────────────────────────────────────────────
    // Coffee Stains (1-10)
    // ─────────────────────────────────────────────────────────────────────────
    case coffeeRingTopLeft = 1
    case coffeeRingTopRight = 2
    case coffeeRingBottomLeft = 3
    case coffeeRingBottomRight = 4
    case coffeeRingCenter = 5
    case coffeeRingDouble = 6
    case coffeeRingTriple = 7
    case coffeeSpillCorner = 8
    case coffeeSpillEdge = 9
    case coffeeDripStain = 10

    // ─────────────────────────────────────────────────────────────────────────
    // Burn/Heat Damage (11-18)
    // ─────────────────────────────────────────────────────────────────────────
    case burnEdgeBottom = 11
    case burnEdgeCorner = 12
    case burnEdgeTop = 13
    case burnSpotCenter = 14
    case burnSpotRandom = 15
    case heatWarp = 16
    case cigaretteBurn = 17
    case matchBurn = 18

    // ─────────────────────────────────────────────────────────────────────────
    // Folds & Creases (19-26)
    // ─────────────────────────────────────────────────────────────────────────
    case foldHorizontal = 19
    case foldVertical = 20
    case foldDiagonal = 21
    case foldCorner = 22
    case creaseMultiple = 23
    case bentCorner = 24
    case dogEar = 25
    case wrinkled = 26

    // ─────────────────────────────────────────────────────────────────────────
    // Water Damage (27-32)
    // ─────────────────────────────────────────────────────────────────────────
    case waterStainEdge = 27
    case waterStainCorner = 28
    case waterRipple = 29
    case rainDrops = 30
    case waterDamageHeavy = 31
    case moistureBubble = 32

    // ─────────────────────────────────────────────────────────────────────────
    // Age & Sun Damage (33-40)
    // ─────────────────────────────────────────────────────────────────────────
    case yellowedAge = 33
    case fadedSun = 34
    case bleachedCorner = 35
    case vintageSepia = 36
    case dustyOld = 37
    case scratchedSurface = 38
    case fingerprints = 39
    case stickyResidue = 40

    // ─────────────────────────────────────────────────────────────────────────
    // Tears & Physical Damage (41-46)
    // ─────────────────────────────────────────────────────────────────────────
    case tornEdge = 41
    case peelingSurface = 42
    case crackedEmulsion = 43
    case scrapeMarks = 44
    case dentedFrame = 45
    case pocketWorn = 46

    // ─────────────────────────────────────────────────────────────────────────
    // Light & Exposure (47-50)
    // ─────────────────────────────────────────────────────────────────────────
    case lightLeak = 47
    case lightLeakWarm = 48
    case overexposedEdge = 49
    case chemicalSpill = 50

    /// Returns a random filter 80% of the time, nil (pristine pola) 20% of the time.
    /// DEPRECATED: Use randomFilters() for stacked effects
    static func randomFilter() -> PolaFilter? {
        // 20% chance of pristine pola (no effect)
        guard Int.random(in: 1...5) != 1 else { return nil }
        return Self.allCases.randomElement()
    }

    /// Returns an array of random filters with stacking probability:
    /// - 20% pristine (no effects)
    /// - 40% get 1 effect
    /// - 20% get 2 effects
    /// - 10% get 3 effects
    /// - 5% get 4 effects
    /// - 4% get 5 effects
    /// - 1% "mangled" - angry ex crumpled and tried to burn it
    static func randomFilters() -> [PolaFilter] {
        let roll = Int.random(in: 1...100)

        let effectCount: Int
        switch roll {
        case 1:
            // 1% - The "angry ex" mangled treatment
            return mangledFilters()
        case 2...5:
            // 4% - 5 effects
            effectCount = 5
        case 6...10:
            // 5% - 4 effects
            effectCount = 4
        case 11...20:
            // 10% - 3 effects
            effectCount = 3
        case 21...40:
            // 20% - 2 effects
            effectCount = 2
        case 41...80:
            // 40% - 1 effect
            effectCount = 1
        default:
            // 20% - pristine, no effects
            return []
        }

        return pickUniqueFilters(count: effectCount)
    }

    /// Pick N unique random filters
    private static func pickUniqueFilters(count: Int) -> [PolaFilter] {
        var available = Self.allCases.shuffled()
        var result: [PolaFilter] = []

        for _ in 0..<min(count, available.count) {
            if let filter = available.popLast() {
                result.append(filter)
            }
        }

        return result
    }

    /// The "angry ex" treatment - a mangled mess with many stacked effects.
    /// Like someone crumpled it up, tried to burn it, spilled coffee on it,
    /// maybe ran it through a washing machine, but you can still sort of make out the image.
    private static func mangledFilters() -> [PolaFilter] {
        var filters: [PolaFilter] = []

        // Always include heavy damage indicators
        // Multiple burns (at least 2-3)
        let burns: [PolaFilter] = [.burnEdgeBottom, .burnEdgeCorner, .burnEdgeTop, .cigaretteBurn, .matchBurn, .burnSpotRandom]
        filters.append(contentsOf: burns.shuffled().prefix(Int.random(in: 2...4)))

        // Multiple folds/creases (crumpled up)
        let folds: [PolaFilter] = [.foldHorizontal, .foldVertical, .foldDiagonal, .creaseMultiple, .wrinkled, .bentCorner]
        filters.append(contentsOf: folds.shuffled().prefix(Int.random(in: 3...5)))

        // Coffee/liquid damage
        let stains: [PolaFilter] = [.coffeeRingTopLeft, .coffeeRingBottomRight, .coffeeSpillCorner, .coffeeDripStain, .waterDamageHeavy]
        filters.append(contentsOf: stains.shuffled().prefix(Int.random(in: 2...3)))

        // Age and wear
        let aged: [PolaFilter] = [.yellowedAge, .dustyOld, .scratchedSurface, .pocketWorn, .tornEdge, .peelingSurface]
        filters.append(contentsOf: aged.shuffled().prefix(Int.random(in: 2...4)))

        // Maybe some chemical/light damage for extra chaos
        if Bool.random() {
            filters.append([.chemicalSpill, .lightLeak, .lightLeakWarm, .overexposedEdge].randomElement()!)
        }

        // Shuffle the final result for random layering order
        return filters.shuffled()
    }

    /// Human-readable name for the filter (for debugging/accessibility)
    var displayName: String {
        switch self {
        case .coffeeRingTopLeft: return "Coffee Ring (Top Left)"
        case .coffeeRingTopRight: return "Coffee Ring (Top Right)"
        case .coffeeRingBottomLeft: return "Coffee Ring (Bottom Left)"
        case .coffeeRingBottomRight: return "Coffee Ring (Bottom Right)"
        case .coffeeRingCenter: return "Coffee Ring (Center)"
        case .coffeeRingDouble: return "Double Coffee Rings"
        case .coffeeRingTriple: return "Triple Coffee Rings"
        case .coffeeSpillCorner: return "Coffee Spill"
        case .coffeeSpillEdge: return "Coffee Edge Stain"
        case .coffeeDripStain: return "Coffee Drip"
        case .burnEdgeBottom: return "Burned Edge"
        case .burnEdgeCorner: return "Burned Corner"
        case .burnEdgeTop: return "Burned Top"
        case .burnSpotCenter: return "Burn Spot"
        case .burnSpotRandom: return "Burn Marks"
        case .heatWarp: return "Heat Warped"
        case .cigaretteBurn: return "Cigarette Burn"
        case .matchBurn: return "Match Burn"
        case .foldHorizontal: return "Horizontal Fold"
        case .foldVertical: return "Vertical Fold"
        case .foldDiagonal: return "Diagonal Fold"
        case .foldCorner: return "Corner Fold"
        case .creaseMultiple: return "Multiple Creases"
        case .bentCorner: return "Bent Corner"
        case .dogEar: return "Dog-eared"
        case .wrinkled: return "Wrinkled"
        case .waterStainEdge: return "Water Stain"
        case .waterStainCorner: return "Water Damage"
        case .waterRipple: return "Water Ripple"
        case .rainDrops: return "Rain Drops"
        case .waterDamageHeavy: return "Heavy Water Damage"
        case .moistureBubble: return "Moisture Bubble"
        case .yellowedAge: return "Yellowed with Age"
        case .fadedSun: return "Sun Faded"
        case .bleachedCorner: return "Bleached"
        case .vintageSepia: return "Vintage Sepia"
        case .dustyOld: return "Dusty"
        case .scratchedSurface: return "Scratched"
        case .fingerprints: return "Fingerprints"
        case .stickyResidue: return "Sticky Residue"
        case .tornEdge: return "Torn Edge"
        case .peelingSurface: return "Peeling"
        case .crackedEmulsion: return "Cracked"
        case .scrapeMarks: return "Scraped"
        case .dentedFrame: return "Dented"
        case .pocketWorn: return "Pocket Worn"
        case .lightLeak: return "Light Leak"
        case .lightLeakWarm: return "Warm Light Leak"
        case .overexposedEdge: return "Overexposed Edge"
        case .chemicalSpill: return "Chemical Spill"
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// MARK: - Pola Filter Overlay
// ═══════════════════════════════════════════════════════════════════════════
/// Renders visual vintage/worn effects on top of photos.
///
/// Each filter creates a distinct aged, worn, or damaged look using SwiftUI
/// overlays, gradients, shapes, and blend modes. Effects are designed to be
/// subtle enough to enhance photos without overwhelming them.
///
/// Usage:
/// ```swift
/// photoImage
///     .overlay(PolaFilterOverlay(filters: activeFilters, scale: scale))
/// ```
struct PolaFilterOverlay: View {
    let filters: [PolaFilter]
    let scale: CGFloat
    /// Opacity for fade-in animation after development completes (0.0 to 1.0)
    var opacity: Double = 1.0

    /// Legacy initializer for single filter (backwards compatibility)
    init(filter: PolaFilter?, scale: CGFloat, opacity: Double = 1.0) {
        self.filters = filter.map { [$0] } ?? []
        self.scale = scale
        self.opacity = opacity
    }

    /// New initializer for multiple filters
    init(filters: [PolaFilter], scale: CGFloat, opacity: Double = 1.0) {
        self.filters = filters
        self.scale = scale
        self.opacity = opacity
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Color Constants for Vintage Effects
    // ─────────────────────────────────────────────────────────────────────────

    /// Coffee brown color for stains
    private let coffeeColor = Color(red: 0.36, green: 0.25, blue: 0.15)

    /// Light coffee color for translucent stains
    private let coffeeLightColor = Color(red: 0.55, green: 0.40, blue: 0.25)

    /// Burn/char color (dark brown to black)
    private let burnColor = Color(red: 0.15, green: 0.08, blue: 0.05)

    /// Aged yellow/sepia tone
    private let agedYellowColor = Color(red: 0.85, green: 0.78, blue: 0.55)

    /// Water stain color (bluish gray)
    private let waterColor = Color(red: 0.65, green: 0.72, blue: 0.75)

    /// Crease/fold shadow color
    private let creaseColor = Color(red: 0.20, green: 0.18, blue: 0.16)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(filters, id: \.rawValue) { filter in
                    filterContent(for: filter, in: geo.size)
                }
            }
        }
        .opacity(opacity)
        .allowsHitTesting(false)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Filter Rendering
    // ─────────────────────────────────────────────────────────────────────────

    @ViewBuilder
    private func filterContent(for filter: PolaFilter, in size: CGSize) -> some View {
        switch filter {
        // ─────────────────────────────────────────────────────────────────────
        // Coffee Stains (1-10)
        // ─────────────────────────────────────────────────────────────────────
        case .coffeeRingTopLeft:
            // Coffee ring mostly off frame, showing on top-left corner
            coffeeRing(at: CGPoint(x: -size.width * 0.08, y: -size.height * 0.05), size: size)

        case .coffeeRingTopRight:
            // Coffee ring on top-right corner
            coffeeRing(at: CGPoint(x: size.width * 1.08, y: -size.height * 0.05), size: size)

        case .coffeeRingBottomLeft:
            // Coffee ring on bottom-left, in caption area
            coffeeRing(at: CGPoint(x: -size.width * 0.05, y: size.height * 0.92), size: size)

        case .coffeeRingBottomRight:
            // Coffee ring on bottom-right corner
            coffeeRing(at: CGPoint(x: size.width * 1.05, y: size.height * 0.95), size: size)

        case .coffeeRingCenter:
            // Coffee ring on left edge, overlapping photo slightly
            coffeeRing(at: CGPoint(x: -size.width * 0.1, y: size.height * 0.4), size: size)

        case .coffeeRingDouble:
            ZStack {
                coffeeRing(at: CGPoint(x: -size.width * 0.12, y: size.height * 0.25), size: size)
                coffeeRing(at: CGPoint(x: size.width * 1.1, y: size.height * 0.85), size: size)
            }

        case .coffeeRingTriple:
            ZStack {
                coffeeRing(at: CGPoint(x: -size.width * 0.08, y: -size.height * 0.08), size: size)
                coffeeRing(at: CGPoint(x: size.width * 1.05, y: size.height * 0.4), size: size)
                coffeeRing(at: CGPoint(x: size.width * 0.2, y: size.height * 1.05), size: size)
            }

        case .coffeeSpillCorner:
            coffeeSpill(at: CGPoint(x: size.width * 1.0, y: size.height * 0.95), size: size)

        case .coffeeSpillEdge:
            coffeeEdgeStain(edge: .bottom, size: size)

        case .coffeeDripStain:
            coffeeDrip(from: CGPoint(x: size.width * 0.15, y: -10), size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Burn/Heat Damage (11-18)
        // ─────────────────────────────────────────────────────────────────────
        case .burnEdgeBottom:
            burnEdge(edge: .bottom, size: size)

        case .burnEdgeCorner:
            burnCorner(corner: .bottomTrailing, size: size)

        case .burnEdgeTop:
            burnEdge(edge: .top, size: size)

        case .burnSpotCenter:
            burnSpot(at: CGPoint(x: size.width * 0.5, y: size.height * 0.5), size: size)

        case .burnSpotRandom:
            ZStack {
                burnSpot(at: CGPoint(x: size.width * 0.3, y: size.height * 0.4), size: size, spotSize: 15)
                burnSpot(at: CGPoint(x: size.width * 0.7, y: size.height * 0.6), size: size, spotSize: 12)
            }

        case .heatWarp:
            heatWarpEffect(size: size)

        case .cigaretteBurn:
            cigaretteBurn(at: CGPoint(x: size.width * 0.75, y: size.height * 0.2), size: size)

        case .matchBurn:
            matchBurn(at: CGPoint(x: size.width * 0.1, y: size.height * 0.8), size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Folds & Creases (19-26)
        // ─────────────────────────────────────────────────────────────────────
        case .foldHorizontal:
            horizontalFold(at: size.height * 0.5, size: size)

        case .foldVertical:
            verticalFold(at: size.width * 0.5, size: size)

        case .foldDiagonal:
            diagonalFold(size: size)

        case .foldCorner:
            cornerFold(corner: .topTrailing, size: size)

        case .creaseMultiple:
            ZStack {
                horizontalFold(at: size.height * 0.33, size: size, opacity: 0.15)
                horizontalFold(at: size.height * 0.66, size: size, opacity: 0.12)
            }

        case .bentCorner:
            bentCornerEffect(corner: .bottomLeading, size: size)

        case .dogEar:
            dogEarEffect(corner: .topTrailing, size: size)

        case .wrinkled:
            wrinkledEffect(size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Water Damage (27-32)
        // ─────────────────────────────────────────────────────────────────────
        case .waterStainEdge:
            waterStain(edge: .bottom, size: size)

        case .waterStainCorner:
            waterStainCorner(corner: .bottomLeading, size: size)

        case .waterRipple:
            waterRipple(size: size)

        case .rainDrops:
            rainDropsEffect(size: size)

        case .waterDamageHeavy:
            heavyWaterDamage(size: size)

        case .moistureBubble:
            moistureBubbles(size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Age & Sun Damage (33-40)
        // ─────────────────────────────────────────────────────────────────────
        case .yellowedAge:
            yellowedAgeEffect(size: size)

        case .fadedSun:
            sunFadeEffect(size: size)

        case .bleachedCorner:
            bleachedCorner(corner: .topLeading, size: size)

        case .vintageSepia:
            sepiaOverlay(size: size)

        case .dustyOld:
            dustyEffect(size: size)

        case .scratchedSurface:
            scratchesEffect(size: size)

        case .fingerprints:
            fingerprintEffect(size: size)

        case .stickyResidue:
            stickyResidueEffect(size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Tears & Physical Damage (41-46)
        // ─────────────────────────────────────────────────────────────────────
        case .tornEdge:
            tornEdgeEffect(edge: .trailing, size: size)

        case .peelingSurface:
            peelingEffect(size: size)

        case .crackedEmulsion:
            crackedEffect(size: size)

        case .scrapeMarks:
            scrapeEffect(size: size)

        case .dentedFrame:
            dentedEffect(size: size)

        case .pocketWorn:
            pocketWornEffect(size: size)

        // ─────────────────────────────────────────────────────────────────────
        // Light & Exposure (47-50)
        // ─────────────────────────────────────────────────────────────────────
        case .lightLeak:
            lightLeakEffect(warm: false, size: size)

        case .lightLeakWarm:
            lightLeakEffect(warm: true, size: size)

        case .overexposedEdge:
            overexposedEdge(edge: .top, size: size)

        case .chemicalSpill:
            chemicalSpillEffect(size: size)
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Coffee Stain Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Coffee cup ring stain - organic, imperfect with drips
    private func coffeeRing(at center: CGPoint, size: CGSize, ringWidth: CGFloat = 10) -> some View {
        let radius = min(size.width, size.height) * 0.38
        return ZStack {
            // Main ring - slightly elliptical for imperfection
            Ellipse()
                .stroke(
                    AngularGradient(
                        colors: [
                            coffeeColor.opacity(0.5),
                            coffeeColor.opacity(0.3),
                            coffeeColor.opacity(0.55),
                            coffeeColor.opacity(0.25),
                            coffeeColor.opacity(0.5)
                        ],
                        center: .center
                    ),
                    lineWidth: ringWidth
                )
                .frame(width: radius * 2, height: radius * 2.1)
                .rotationEffect(.degrees(12))

            // Inner faded stain
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            coffeeLightColor.opacity(0.18),
                            coffeeLightColor.opacity(0.08),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: radius * 0.9
                    )
                )
                .frame(width: radius * 1.9, height: radius * 2.0)
                .rotationEffect(.degrees(12))

            // Drip 1 - runs down from ring
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [coffeeColor.opacity(0.4), coffeeLightColor.opacity(0.15), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 12, height: 35)
                .offset(x: radius * 0.6, y: radius * 1.1)
                .blur(radius: 2)

            // Drip 2 - smaller
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [coffeeColor.opacity(0.35), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 8, height: 22)
                .offset(x: radius * 0.3, y: radius * 1.2)
                .blur(radius: 1.5)

            // Drip 3 - splash dot
            Circle()
                .fill(coffeeLightColor.opacity(0.3))
                .frame(width: 10, height: 10)
                .offset(x: radius * 0.8, y: radius * 0.4)
                .blur(radius: 2)

            // Another splash
            Circle()
                .fill(coffeeLightColor.opacity(0.25))
                .frame(width: 6, height: 6)
                .offset(x: -radius * 0.2, y: radius * 0.9)
                .blur(radius: 1)
        }
        .position(center)
        .blur(radius: 0.5)
        .blendMode(.multiply)
    }

    /// Coffee spill - organic puddle shape at corner
    private func coffeeSpill(at position: CGPoint, size: CGSize) -> some View {
        ZStack {
            // Main spill puddle - irregular shape using overlapping ellipses
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            coffeeColor.opacity(0.4),
                            coffeeLightColor.opacity(0.25),
                            coffeeLightColor.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.width * 0.25
                    )
                )
                .frame(width: size.width * 0.45, height: size.width * 0.35)
                .rotationEffect(.degrees(-35))

            // Secondary blob
            Ellipse()
                .fill(coffeeLightColor.opacity(0.2))
                .frame(width: size.width * 0.2, height: size.width * 0.15)
                .offset(x: -30, y: 15)
                .rotationEffect(.degrees(20))
                .blur(radius: 3)

            // Edge darkening
            Ellipse()
                .stroke(coffeeColor.opacity(0.3), lineWidth: 4)
                .frame(width: size.width * 0.4, height: size.width * 0.3)
                .rotationEffect(.degrees(-35))
                .blur(radius: 2)

            // Small drips extending from spill
            ForEach(0..<3, id: \.self) { i in
                let offsets: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                    (-40, -20, 6, 18),
                    (-15, 25, 5, 14),
                    (20, 10, 4, 12)
                ]
                let o = offsets[i]
                Ellipse()
                    .fill(coffeeLightColor.opacity(0.25))
                    .frame(width: o.2, height: o.3)
                    .offset(x: o.0, y: o.1)
                    .blur(radius: 1.5)
            }
        }
        .position(position)
        .blur(radius: 1)
        .blendMode(.multiply)
    }

    /// Coffee stain along bottom edge - seeping in from border
    private func coffeeEdgeStain(edge: Edge, size: CGSize) -> some View {
        ZStack {
            // Main stain creeping up from edge
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            coffeeColor.opacity(0.35),
                            coffeeLightColor.opacity(0.2),
                            Color.clear
                        ],
                        center: .bottom,
                        startRadius: 0,
                        endRadius: size.height * 0.25
                    )
                )
                .frame(width: size.width * 0.6, height: size.height * 0.3)
                .position(x: size.width * 0.7, y: size.height + 20)

            // Secondary smaller stain
            Ellipse()
                .fill(coffeeLightColor.opacity(0.25))
                .frame(width: size.width * 0.25, height: size.height * 0.15)
                .position(x: size.width * 0.3, y: size.height + 10)
                .blur(radius: 3)

            // Drip marks going up
            ForEach(0..<2, id: \.self) { i in
                let xPos = [size.width * 0.65, size.width * 0.8][i]
                Ellipse()
                    .fill(coffeeLightColor.opacity(0.2))
                    .frame(width: 8, height: 25)
                    .position(x: xPos, y: size.height - 15)
                    .blur(radius: 2)
            }
        }
        .blendMode(.multiply)
    }

    /// Coffee drip running down from top edge
    private func coffeeDrip(from start: CGPoint, size: CGSize) -> some View {
        ZStack {
            // Main drip trail
            Path { path in
                path.move(to: start)
                path.addCurve(
                    to: CGPoint(x: start.x + 25, y: size.height * 0.5),
                    control1: CGPoint(x: start.x + 8, y: size.height * 0.15),
                    control2: CGPoint(x: start.x + 30, y: size.height * 0.35)
                )
                path.addCurve(
                    to: CGPoint(x: start.x + 15, y: size.height * 0.75),
                    control1: CGPoint(x: start.x + 20, y: size.height * 0.6),
                    control2: CGPoint(x: start.x + 10, y: size.height * 0.7)
                )
            }
            .stroke(
                LinearGradient(
                    colors: [coffeeColor.opacity(0.5), coffeeLightColor.opacity(0.3), coffeeLightColor.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .blur(radius: 2)

            // Pooling at bottom of drip
            Ellipse()
                .fill(coffeeLightColor.opacity(0.3))
                .frame(width: 18, height: 12)
                .position(x: start.x + 15, y: size.height * 0.78)
                .blur(radius: 2)

            // Small satellite drips
            Circle()
                .fill(coffeeLightColor.opacity(0.25))
                .frame(width: 6, height: 6)
                .position(x: start.x + 35, y: size.height * 0.4)
                .blur(radius: 1)

            Circle()
                .fill(coffeeLightColor.opacity(0.2))
                .frame(width: 4, height: 4)
                .position(x: start.x + 5, y: size.height * 0.55)
                .blur(radius: 1)
        }
        .blendMode(.multiply)
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Burn Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Burned edge effect - charred, uneven edge
    private func burnEdge(edge: Edge, size: CGSize) -> some View {
        let isBottom = edge == .bottom
        let yBase = isBottom ? size.height : 0

        return ZStack {
            // Irregular char edge using multiple overlapping shapes
            ForEach(0..<6, id: \.self) { i in
                let positions: [(CGFloat, CGFloat, CGFloat, Double)] = [
                    (0.1, 0.08, 0.18, 0.7),
                    (0.25, 0.12, 0.22, 0.8),
                    (0.45, 0.06, 0.15, 0.65),
                    (0.6, 0.14, 0.25, 0.85),
                    (0.78, 0.09, 0.2, 0.75),
                    (0.92, 0.11, 0.17, 0.7)
                ]
                let p = positions[i]

                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.black.opacity(p.3),
                                burnColor.opacity(0.5),
                                Color.orange.opacity(0.15),
                                Color.clear
                            ],
                            center: isBottom ? .bottom : .top,
                            startRadius: 0,
                            endRadius: size.height * p.2
                        )
                    )
                    .frame(width: size.width * p.2 * 1.5, height: size.height * p.2)
                    .position(
                        x: size.width * p.0,
                        y: isBottom ? yBase - size.height * p.1 * 0.5 : size.height * p.1 * 0.5
                    )
            }

            // Ember glow at very edge
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.orange.opacity(0.3),
                            Color.orange.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: isBottom ? .bottom : .top,
                        endPoint: isBottom ? .top : .bottom
                    )
                )
                .frame(height: 8)
                .position(x: size.width / 2, y: isBottom ? size.height - 4 : 4)
                .blur(radius: 2)
        }
        .blendMode(.multiply)
    }

    /// Burned corner - irregular charred corner
    private func burnCorner(corner: Alignment, size: CGSize) -> some View {
        let pos = cornerPosition(corner, in: size, inset: -20)

        return ZStack {
            // Main char area
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.9),
                            burnColor.opacity(0.7),
                            Color.orange.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.width * 0.22
                    )
                )
                .frame(width: size.width * 0.5, height: size.width * 0.4)
                .rotationEffect(.degrees(corner == .bottomTrailing || corner == .topTrailing ? -40 : 40))

            // Secondary burn blob
            Ellipse()
                .fill(Color.black.opacity(0.6))
                .frame(width: size.width * 0.15, height: size.width * 0.12)
                .offset(x: corner == .topTrailing || corner == .bottomTrailing ? -25 : 25, y: 15)
                .blur(radius: 3)

            // Ember edge glow
            Ellipse()
                .stroke(Color.orange.opacity(0.4), lineWidth: 3)
                .frame(width: size.width * 0.35, height: size.width * 0.25)
                .rotationEffect(.degrees(corner == .bottomTrailing || corner == .topTrailing ? -40 : 40))
                .blur(radius: 4)

            // Ash specks
            ForEach(0..<4, id: \.self) { i in
                let offsets: [(CGFloat, CGFloat)] = [(-20, -15), (15, -25), (-30, 10), (25, 20)]
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 4, height: 4)
                    .offset(x: offsets[i].0, y: offsets[i].1)
                    .blur(radius: 1)
            }
        }
        .position(pos)
        .blendMode(.multiply)
    }

    /// Burn spot - small burn mark on border
    private func burnSpot(at position: CGPoint, size: CGSize, spotSize: CGFloat = 25) -> some View {
        ZStack {
            // Dark center
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.8),
                            burnColor.opacity(0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: spotSize
                    )
                )
                .frame(width: spotSize * 2.2, height: spotSize * 1.8)
                .rotationEffect(.degrees(15))

            // Heat discoloration around it
            Ellipse()
                .fill(Color.orange.opacity(0.15))
                .frame(width: spotSize * 3, height: spotSize * 2.5)
                .blur(radius: 5)
        }
        .position(position)
        .blendMode(.multiply)
    }

    /// Heat warp distortion effect - yellowing and waviness at edges
    private func heatWarpEffect(size: CGSize) -> some View {
        ZStack {
            // Yellowed corners from heat exposure
            RadialGradient(
                colors: [Color.clear, agedYellowColor.opacity(0.2)],
                center: .bottomTrailing,
                startRadius: size.width * 0.3,
                endRadius: size.width * 0.7
            )

            RadialGradient(
                colors: [Color.clear, agedYellowColor.opacity(0.15)],
                center: .topLeading,
                startRadius: size.width * 0.4,
                endRadius: size.width * 0.6
            )

            // Subtle warp lines near edge
            ForEach(0..<3, id: \.self) { i in
                let yOffsets: [CGFloat] = [0.85, 0.9, 0.95]
                Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height * yOffsets[i]))
                    for x in stride(from: CGFloat(0), to: size.width, by: 15) {
                        let waveY = size.height * yOffsets[i] + sin(x / 25) * 2
                        path.addLine(to: CGPoint(x: x, y: waveY))
                    }
                }
                .stroke(burnColor.opacity(0.12), lineWidth: 1.5)
                .blur(radius: 1)
            }
        }
        .blendMode(.multiply)
    }

    /// Small cigarette burn hole on border
    private func cigaretteBurn(at position: CGPoint, size: CGSize) -> some View {
        ZStack {
            // Outer scorched area
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            burnColor.opacity(0.6),
                            Color.orange.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 8,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 45)

            // Char ring
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.9),
                            burnColor.opacity(0.7),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 15
                    )
                )
                .frame(width: 30, height: 28)

            // Actual hole (very dark)
            Ellipse()
                .fill(Color.black.opacity(0.95))
                .frame(width: 10, height: 9)

            // Ash residue
            Ellipse()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 8, height: 5)
                .offset(x: 12, y: 8)
                .blur(radius: 1)
        }
        .position(position)
        .blendMode(.multiply)
    }

    /// Match burn mark - strike mark on edge
    private func matchBurn(at start: CGPoint, size: CGSize) -> some View {
        ZStack {
            // Main strike mark
            Path { path in
                path.move(to: CGPoint(x: start.x, y: start.y))
                path.addCurve(
                    to: CGPoint(x: start.x + 45, y: start.y - 60),
                    control1: CGPoint(x: start.x + 15, y: start.y - 15),
                    control2: CGPoint(x: start.x + 35, y: start.y - 45)
                )
            }
            .stroke(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.8),
                        burnColor.opacity(0.6),
                        burnColor.opacity(0.3)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                ),
                style: StrokeStyle(lineWidth: 10, lineCap: .round)
            )
            .blur(radius: 1.5)

            // Phosphorus residue
            Ellipse()
                .fill(Color.orange.opacity(0.25))
                .frame(width: 20, height: 15)
                .position(x: start.x + 5, y: start.y + 5)
                .blur(radius: 3)

            // Char specks
            ForEach(0..<3, id: \.self) { i in
                let offsets: [(CGFloat, CGFloat)] = [(20, -25), (30, -40), (15, -50)]
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 3, height: 3)
                    .position(x: start.x + offsets[i].0, y: start.y + offsets[i].1)
            }
        }
        .blendMode(.multiply)
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Fold & Crease Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Horizontal fold line
    private func horizontalFold(at y: CGFloat, size: CGSize, opacity: Double = 0.40) -> some View {
        ZStack {
            // Main shadow below fold line - paper catching shadow
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            creaseColor.opacity(opacity * 0.3),
                            creaseColor.opacity(opacity),
                            creaseColor.opacity(opacity * 0.5),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 12 * scale)
                .position(x: size.width / 2, y: y + 6 * scale)

            // Sharp crease line
            Rectangle()
                .fill(creaseColor.opacity(opacity * 1.2))
                .frame(height: 1.5 * scale)
                .position(x: size.width / 2, y: y)

            // Highlight above fold - light catching the ridge
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(opacity * 0.4),
                            Color.white.opacity(opacity * 0.6),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 6 * scale)
                .position(x: size.width / 2, y: y - 4 * scale)
        }
        .blendMode(.multiply)
    }

    /// Vertical fold line
    private func verticalFold(at x: CGFloat, size: CGSize, opacity: Double = 0.40) -> some View {
        ZStack {
            // Main shadow to the right of fold
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            creaseColor.opacity(opacity * 0.3),
                            creaseColor.opacity(opacity),
                            creaseColor.opacity(opacity * 0.5),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 12 * scale)
                .position(x: x + 6 * scale, y: size.height / 2)

            // Sharp crease line
            Rectangle()
                .fill(creaseColor.opacity(opacity * 1.2))
                .frame(width: 1.5 * scale)
                .position(x: x, y: size.height / 2)

            // Highlight to the left - light catching the ridge
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(opacity * 0.4),
                            Color.white.opacity(opacity * 0.6),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 6 * scale)
                .position(x: x - 4 * scale, y: size.height / 2)
        }
        .blendMode(.multiply)
    }

    /// Diagonal fold
    private func diagonalFold(size: CGSize) -> some View {
        let startPoint = CGPoint(x: 0, y: size.height * 0.3)
        let endPoint = CGPoint(x: size.width, y: size.height * 0.7)
        // Calculate perpendicular offset for shadow/highlight
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let length = sqrt(dx * dx + dy * dy)
        let perpX = -dy / length * 4 * scale
        let perpY = dx / length * 4 * scale

        return ZStack {
            // Shadow side of fold
            Path { path in
                path.move(to: CGPoint(x: startPoint.x + perpX, y: startPoint.y + perpY))
                path.addLine(to: CGPoint(x: endPoint.x + perpX, y: endPoint.y + perpY))
            }
            .stroke(
                LinearGradient(
                    colors: [
                        creaseColor.opacity(0.08),
                        creaseColor.opacity(0.22),
                        creaseColor.opacity(0.18),
                        creaseColor.opacity(0.10)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 8 * scale
            )
            .blur(radius: 2 * scale)

            // Sharp crease line
            Path { path in
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
            .stroke(creaseColor.opacity(0.25), lineWidth: 1.5 * scale)

            // Highlight side
            Path { path in
                path.move(to: CGPoint(x: startPoint.x - perpX, y: startPoint.y - perpY))
                path.addLine(to: CGPoint(x: endPoint.x - perpX, y: endPoint.y - perpY))
            }
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.12),
                        Color.white.opacity(0.08),
                        Color.white.opacity(0.04)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 5 * scale
            )
            .blur(radius: 1 * scale)
        }
        .blendMode(.multiply)
    }

    /// Corner fold (triangular) - paper folded over showing crease
    private func cornerFold(corner: Alignment, size: CGSize) -> some View {
        let foldSize = min(size.width, size.height) * 0.22

        return ZStack {
            // Shadow cast by the fold
            Path { path in
                if corner == .topTrailing {
                    path.move(to: CGPoint(x: size.width - foldSize * 1.3, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: foldSize * 1.3))
                    path.addLine(to: CGPoint(x: size.width, y: 0))
                    path.closeSubpath()
                }
            }
            .fill(
                RadialGradient(
                    colors: [
                        creaseColor.opacity(0.25),
                        creaseColor.opacity(0.12),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.8, y: 0.2),
                    startRadius: 0,
                    endRadius: foldSize
                )
            )
            .blur(radius: 3 * scale)

            // The folded triangle
            Path { path in
                if corner == .topTrailing {
                    path.move(to: CGPoint(x: size.width - foldSize, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: foldSize))
                    path.addLine(to: CGPoint(x: size.width, y: 0))
                    path.closeSubpath()
                }
            }
            .fill(
                LinearGradient(
                    colors: [
                        creaseColor.opacity(0.28),
                        creaseColor.opacity(0.18),
                        creaseColor.opacity(0.12)
                    ],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )

            // Crease line
            Path { path in
                if corner == .topTrailing {
                    path.move(to: CGPoint(x: size.width - foldSize, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: foldSize))
                }
            }
            .stroke(creaseColor.opacity(0.35), lineWidth: 1.5 * scale)

            // Highlight along the fold edge
            Path { path in
                if corner == .topTrailing {
                    path.move(to: CGPoint(x: size.width - foldSize + 2, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: foldSize - 2))
                }
            }
            .stroke(Color.white.opacity(0.15), lineWidth: 1 * scale)
            .blur(radius: 0.5 * scale)
        }
        .blendMode(.multiply)
    }

    /// Bent corner with shadow - subtle upward curl
    private func bentCornerEffect(corner: Alignment, size: CGSize) -> some View {
        let bendSize = min(size.width, size.height) * 0.18
        let isBottomLeft = corner == .bottomLeading

        return ZStack {
            // Shadow cast by the bent corner lifting up
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            creaseColor.opacity(0.30),
                            creaseColor.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: bendSize * 0.8
                    )
                )
                .frame(width: bendSize * 1.8, height: bendSize * 1.2)
                .rotationEffect(.degrees(isBottomLeft ? 35 : -35))
                .position(cornerPosition(corner, in: size, inset: bendSize * 0.4))
                .blur(radius: 4 * scale)

            // Crease line where the bend happens
            Path { path in
                if isBottomLeft {
                    path.move(to: CGPoint(x: 0, y: size.height - bendSize * 1.2))
                    path.addQuadCurve(
                        to: CGPoint(x: bendSize * 1.2, y: size.height),
                        control: CGPoint(x: bendSize * 0.3, y: size.height - bendSize * 0.3)
                    )
                } else {
                    path.move(to: CGPoint(x: size.width - bendSize * 1.2, y: size.height))
                    path.addQuadCurve(
                        to: CGPoint(x: size.width, y: size.height - bendSize * 1.2),
                        control: CGPoint(x: size.width - bendSize * 0.3, y: size.height - bendSize * 0.3)
                    )
                }
            }
            .stroke(
                LinearGradient(
                    colors: [creaseColor.opacity(0.20), creaseColor.opacity(0.08)],
                    startPoint: isBottomLeft ? .top : .bottom,
                    endPoint: isBottomLeft ? .bottom : .top
                ),
                lineWidth: 2.5 * scale
            )
            .blur(radius: 1 * scale)

            // Highlight on the raised edge
            Path { path in
                if isBottomLeft {
                    path.move(to: CGPoint(x: 0, y: size.height - bendSize * 1.15))
                    path.addQuadCurve(
                        to: CGPoint(x: bendSize * 1.15, y: size.height),
                        control: CGPoint(x: bendSize * 0.25, y: size.height - bendSize * 0.25)
                    )
                } else {
                    path.move(to: CGPoint(x: size.width - bendSize * 1.15, y: size.height))
                    path.addQuadCurve(
                        to: CGPoint(x: size.width, y: size.height - bendSize * 1.15),
                        control: CGPoint(x: size.width - bendSize * 0.25, y: size.height - bendSize * 0.25)
                    )
                }
            }
            .stroke(Color.white.opacity(0.15), lineWidth: 1.5 * scale)
            .blur(radius: 0.5 * scale)
        }
        .blendMode(.multiply)
    }

    /// Dog-eared corner - realistic folded paper curl
    private func dogEarEffect(corner: Alignment, size: CGSize) -> some View {
        let earSize = min(size.width, size.height) * 0.14

        return ZStack {
            // Shadow cast by the fold onto the photo
            Path { path in
                path.move(to: CGPoint(x: size.width - earSize * 1.3, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size.width, y: earSize * 1.3),
                    control: CGPoint(x: size.width - earSize * 0.4, y: earSize * 0.4)
                )
                path.addLine(to: CGPoint(x: size.width, y: 0))
                path.closeSubpath()
            }
            .fill(
                RadialGradient(
                    colors: [
                        creaseColor.opacity(0.35),
                        creaseColor.opacity(0.15),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.7, y: 0.3),
                    startRadius: 0,
                    endRadius: earSize * 1.2
                )
            )
            .blur(radius: 3 * scale)

            // The folded triangle (back of paper showing)
            Path { path in
                path.move(to: CGPoint(x: size.width - earSize, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size.width, y: earSize),
                    control: CGPoint(x: size.width - earSize * 0.25, y: earSize * 0.25)
                )
                path.addLine(to: CGPoint(x: size.width - earSize, y: earSize))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [
                        Color(white: 0.92),      // Paper back - slightly darker
                        Color(white: 0.88),      // Shadow at the fold
                        Color(white: 0.95)       // Light catching the curl
                    ],
                    startPoint: UnitPoint(x: 1, y: 0),
                    endPoint: UnitPoint(x: 0, y: 1)
                )
            )

            // Curl highlight - light catching the curved edge
            Path { path in
                path.move(to: CGPoint(x: size.width - earSize * 0.95, y: earSize * 0.05))
                path.addQuadCurve(
                    to: CGPoint(x: size.width - earSize * 0.05, y: earSize * 0.95),
                    control: CGPoint(x: size.width - earSize * 0.2, y: earSize * 0.2)
                )
            }
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.6),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2 * scale
            )
            .blur(radius: 0.5 * scale)

            // Crease line where the fold happens
            Path { path in
                path.move(to: CGPoint(x: size.width - earSize, y: 0))
                path.addLine(to: CGPoint(x: size.width - earSize, y: earSize))
                path.addLine(to: CGPoint(x: size.width, y: earSize))
            }
            .stroke(creaseColor.opacity(0.25), lineWidth: 1.5 * scale)
            .blur(radius: 0.5 * scale)
        }
    }

    /// Overall wrinkled paper effect - realistic with shadow/highlight ridges
    private func wrinkledEffect(size: CGSize) -> some View {
        // Wrinkle parameters: (yFraction, xStart, xEnd, ctrl1Y, ctrl2Y, depth, width)
        // depth controls shadow/highlight intensity, width controls ridge thickness
        let wrinkles: [(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (0.15, 0.0, 0.75, -8, 12, 1.0, 4),
            (0.28, 0.1, 0.95, 10, -6, 0.8, 5),
            (0.42, 0.0, 0.85, -5, 8, 1.2, 3),
            (0.55, 0.15, 1.0, 6, -10, 0.9, 4),
            (0.68, 0.0, 0.9, -12, 5, 1.1, 5),
            (0.82, 0.05, 0.8, 8, -8, 0.7, 3)
        ]

        return ZStack {
            // Each wrinkle is a shadow + highlight pair creating a 3D ridge
            ForEach(0..<6, id: \.self) { i in
                let w = wrinkles[i]
                let baseY = size.height * w.0
                let startX = size.width * w.1
                let endX = size.width * w.2
                let depth = w.5
                let ridgeWidth = w.6 * scale

                // Shadow side of wrinkle (below the ridge)
                Path { path in
                    path.move(to: CGPoint(x: startX, y: baseY))
                    path.addCurve(
                        to: CGPoint(x: endX, y: baseY + w.4 * 0.5),
                        control1: CGPoint(x: startX + (endX - startX) * 0.35, y: baseY + w.3),
                        control2: CGPoint(x: startX + (endX - startX) * 0.65, y: baseY + w.4)
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            creaseColor.opacity(0.05 * depth),
                            creaseColor.opacity(0.18 * depth),
                            creaseColor.opacity(0.12 * depth),
                            creaseColor.opacity(0.04 * depth)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: ridgeWidth
                )
                .blur(radius: 1.5 * scale)

                // Highlight side of wrinkle (above the ridge - light catching the paper)
                Path { path in
                    path.move(to: CGPoint(x: startX, y: baseY - ridgeWidth * 0.6))
                    path.addCurve(
                        to: CGPoint(x: endX, y: baseY + w.4 * 0.5 - ridgeWidth * 0.6),
                        control1: CGPoint(x: startX + (endX - startX) * 0.35, y: baseY + w.3 - ridgeWidth * 0.5),
                        control2: CGPoint(x: startX + (endX - startX) * 0.65, y: baseY + w.4 - ridgeWidth * 0.5)
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.02 * depth),
                            Color.white.opacity(0.10 * depth),
                            Color.white.opacity(0.06 * depth),
                            Color.white.opacity(0.02 * depth)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: ridgeWidth * 0.6
                )
                .blur(radius: 0.8 * scale)
            }

            // Add some diagonal micro-creases for texture
            ForEach(0..<4, id: \.self) { i in
                let positions: [(CGFloat, CGFloat, CGFloat)] = [
                    (0.2, 0.3, -15),
                    (0.7, 0.45, 20),
                    (0.35, 0.7, -25),
                    (0.85, 0.25, 18)
                ]
                let p = positions[i]

                Path { path in
                    let startX = size.width * p.0
                    let startY = size.height * p.1
                    let length: CGFloat = 25 * scale
                    let angle = p.2 * .pi / 180
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(
                        x: startX + length * cos(angle),
                        y: startY + length * sin(angle)
                    ))
                }
                .stroke(creaseColor.opacity(0.08), lineWidth: 2 * scale)
                .blur(radius: 1 * scale)
            }
        }
        .blendMode(.multiply)
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Water Damage Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Water stain along edge
    private func waterStain(edge: Edge, size: CGSize) -> some View {
        let stainHeight = size.height * 0.25
        return Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        waterColor.opacity(0.15),
                        waterColor.opacity(0.08),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: stainHeight
                )
            )
            .frame(width: size.width * 0.6, height: stainHeight)
            .position(x: size.width / 2, y: edge == .bottom ? size.height - stainHeight * 0.3 : stainHeight * 0.3)
            .blendMode(.multiply)
    }

    /// Water stain in corner
    private func waterStainCorner(corner: Alignment, size: CGSize) -> some View {
        let stainSize = min(size.width, size.height) * 0.4
        return Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        waterColor.opacity(0.20),
                        waterColor.opacity(0.10),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: stainSize * 0.5
                )
            )
            .frame(width: stainSize, height: stainSize * 0.7)
            .position(cornerPosition(corner, in: size, inset: stainSize * 0.25))
            .blur(radius: 4 * scale)
            .blendMode(.multiply)
    }

    /// Water ripple pattern
    private func waterRipple(size: CGSize) -> some View {
        let center = CGPoint(x: size.width * 0.6, y: size.height * 0.4)
        return ZStack {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .stroke(waterColor.opacity(0.12 - Double(i) * 0.025), lineWidth: 2 * scale)
                    .frame(width: CGFloat(40 + i * 25) * scale, height: CGFloat(40 + i * 25) * scale)
                    .position(center)
            }
        }
        .blendMode(.multiply)
    }

    /// Rain drop spots
    private func rainDropsEffect(size: CGSize) -> some View {
        // Pre-computed rain drop parameters (xFrac, yFrac, dropSize, opacity, blur)
        let drops: [(CGFloat, CGFloat, CGFloat, Double, CGFloat)] = [
            (0.15, 0.22, 12, 0.12, 1.5),
            (0.35, 0.08, 18, 0.10, 2.0),
            (0.55, 0.45, 10, 0.15, 1.2),
            (0.72, 0.18, 15, 0.09, 2.5),
            (0.28, 0.68, 14, 0.14, 1.8),
            (0.88, 0.35, 8, 0.16, 1.0),
            (0.42, 0.82, 16, 0.11, 2.2),
            (0.08, 0.55, 11, 0.13, 1.6),
            (0.65, 0.72, 19, 0.08, 2.8),
            (0.92, 0.88, 9, 0.17, 1.3),
            (0.18, 0.92, 13, 0.10, 1.9),
            (0.78, 0.05, 17, 0.12, 2.4)
        ]

        return ZStack {
            ForEach(0..<12, id: \.self) { i in
                let drop = drops[i]
                Circle()
                    .fill(waterColor.opacity(drop.3))
                    .frame(width: drop.2 * scale, height: drop.2 * scale)
                    .position(x: size.width * drop.0, y: size.height * drop.1)
                    .blur(radius: drop.4 * scale)
            }
        }
        .blendMode(.multiply)
    }

    /// Heavy water damage
    private func heavyWaterDamage(size: CGSize) -> some View {
        ZStack {
            // Large water stain
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            waterColor.opacity(0.25),
                            waterColor.opacity(0.15),
                            waterColor.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.width * 0.4
                    )
                )
                .frame(width: size.width * 0.8, height: size.height * 0.5)
                .position(x: size.width * 0.5, y: size.height * 0.6)

            // Wrinkling from moisture
            wrinkledEffect(size: size)
        }
        .blendMode(.multiply)
    }

    /// Moisture bubble effect
    private func moistureBubbles(size: CGSize) -> some View {
        // Pre-computed bubble parameters (xFrac, yFrac, bubbleSize)
        let bubbles: [(CGFloat, CGFloat, CGFloat)] = [
            (0.25, 0.30, 22),
            (0.55, 0.42, 28),
            (0.38, 0.65, 18),
            (0.72, 0.28, 32),
            (0.45, 0.78, 25),
            (0.68, 0.55, 20)
        ]

        return ZStack {
            ForEach(0..<6, id: \.self) { i in
                let bubble = bubbles[i]
                Circle()
                    .stroke(waterColor.opacity(0.20), lineWidth: 1.5 * scale)
                    .background(Circle().fill(Color.white.opacity(0.05)))
                    .frame(width: bubble.2 * scale, height: bubble.2 * scale)
                    .position(x: size.width * bubble.0, y: size.height * bubble.1)
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Age & Sun Damage Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Yellowed with age
    private func yellowedAgeEffect(size: CGSize) -> some View {
        Rectangle()
            .fill(agedYellowColor.opacity(0.18))
            .blendMode(.multiply)
    }

    /// Sun fade effect (edges darker, center faded)
    private func sunFadeEffect(size: CGSize) -> some View {
        RadialGradient(
            colors: [
                Color.white.opacity(0.15),
                Color.clear,
                agedYellowColor.opacity(0.10)
            ],
            center: .center,
            startRadius: 0,
            endRadius: max(size.width, size.height) * 0.6
        )
        .blendMode(.screen)
    }

    /// Bleached corner from sun
    private func bleachedCorner(corner: Alignment, size: CGSize) -> some View {
        let bleachSize = min(size.width, size.height) * 0.5
        return RadialGradient(
            colors: [
                Color.white.opacity(0.25),
                Color.white.opacity(0.10),
                Color.clear
            ],
            center: corner == .topLeading ? .topLeading : .topTrailing,
            startRadius: 0,
            endRadius: bleachSize
        )
        .blendMode(.screen)
    }

    /// Vintage sepia overlay
    private func sepiaOverlay(size: CGSize) -> some View {
        Rectangle()
            .fill(Color(red: 0.80, green: 0.70, blue: 0.55).opacity(0.20))
            .blendMode(.multiply)
    }

    /// Dusty/dirty effect
    private func dustyEffect(size: CGSize) -> some View {
        // Pre-computed dust particles (xFrac, yFrac, particleSize, opacity)
        let particles: [(CGFloat, CGFloat, CGFloat, Double)] = [
            (0.08, 0.12, 2, 0.15), (0.22, 0.05, 3, 0.12), (0.35, 0.28, 1, 0.20),
            (0.48, 0.15, 2, 0.18), (0.62, 0.08, 4, 0.10), (0.75, 0.22, 2, 0.22),
            (0.88, 0.35, 3, 0.14), (0.15, 0.45, 1, 0.25), (0.32, 0.58, 2, 0.16),
            (0.55, 0.42, 3, 0.13), (0.72, 0.55, 2, 0.19), (0.85, 0.48, 1, 0.21),
            (0.12, 0.72, 4, 0.11), (0.28, 0.85, 2, 0.17), (0.45, 0.68, 3, 0.14),
            (0.58, 0.78, 1, 0.23), (0.78, 0.92, 2, 0.15), (0.92, 0.65, 3, 0.12),
            (0.05, 0.88, 2, 0.18), (0.65, 0.95, 1, 0.20)
        ]

        return ZStack {
            // Overall dust haze
            Rectangle()
                .fill(Color.gray.opacity(0.08))
                .blendMode(.multiply)

            // Dust particles
            ForEach(0..<20, id: \.self) { i in
                let p = particles[i]
                Circle()
                    .fill(Color.gray.opacity(p.3))
                    .frame(width: p.2 * scale, height: p.2 * scale)
                    .position(x: size.width * p.0, y: size.height * p.1)
            }
        }
    }

    /// Scratched surface
    private func scratchesEffect(size: CGSize) -> some View {
        // Pre-computed scratches (startXFrac, startYFrac, deltaX, deltaY, opacity, lineWidth)
        let scratches: [(CGFloat, CGFloat, CGFloat, CGFloat, Double, CGFloat)] = [
            (0.15, 0.25, 35, -20, 0.25, 0.8),
            (0.45, 0.12, -28, 45, 0.20, 1.2),
            (0.72, 0.55, 42, 18, 0.30, 0.6),
            (0.28, 0.78, -15, -38, 0.18, 1.0),
            (0.85, 0.35, 25, -30, 0.28, 1.4),
            (0.55, 0.88, -40, 22, 0.22, 0.9)
        ]

        return ZStack {
            ForEach(0..<6, id: \.self) { i in
                let s = scratches[i]
                let startX = size.width * s.0
                let startY = size.height * s.1

                Path { path in
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: startX + s.2 * scale, y: startY + s.3 * scale))
                }
                .stroke(Color.white.opacity(s.4), lineWidth: s.5 * scale)
            }
        }
        .blendMode(.screen)
    }

    /// Fingerprint smudges
    private func fingerprintEffect(size: CGSize) -> some View {
        // Pre-computed fingerprint positions (xFrac, yFrac, rotation)
        let prints: [(CGFloat, CGFloat, Double)] = [
            (0.35, 0.42, -18),
            (0.62, 0.28, 12),
            (0.48, 0.72, -25)
        ]

        return ZStack {
            ForEach(0..<3, id: \.self) { i in
                let p = prints[i]
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.gray.opacity(0.12),
                                Color.gray.opacity(0.06),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 25 * scale
                        )
                    )
                    .frame(width: 50 * scale, height: 35 * scale)
                    .rotationEffect(.degrees(p.2))
                    .position(x: size.width * p.0, y: size.height * p.1)
            }
        }
        .blendMode(.multiply)
    }

    /// Sticky residue (tape, sticker)
    private func stickyResidueEffect(size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 4 * scale)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.15),
                        Color.white.opacity(0.08),
                        Color.gray.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60 * scale, height: 25 * scale)
            .position(x: size.width * 0.3, y: size.height * 0.15)
            .blendMode(.multiply)
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Physical Damage Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Torn edge effect
    private func tornEdgeEffect(edge: Edge, size: CGSize) -> some View {
        // Pre-computed tear offsets (proportion of 8pt max)
        let tearOffsets: [CGFloat] = [3, 6, 2, 7, 1, 5, 4, 8, 2, 6, 3, 7, 1, 5, 4, 8, 2, 6, 3, 7,
                                      5, 1, 6, 3, 8, 2, 7, 4, 1, 5, 6, 2, 8, 3, 7, 4, 1, 5, 6, 2]

        return Path { path in
            if edge == .trailing {
                path.move(to: CGPoint(x: size.width, y: 0))
                var offsetIndex = 0
                for y in stride(from: CGFloat(0), to: size.height, by: 8) {
                    let offset = tearOffsets[offsetIndex % tearOffsets.count]
                    let x = size.width - offset * scale
                    path.addLine(to: CGPoint(x: x, y: y))
                    offsetIndex += 1
                }
                path.addLine(to: CGPoint(x: size.width, y: size.height))
            }
        }
        .fill(Color.polaFrameBackground)
    }

    /// Peeling emulsion
    private func peelingEffect(size: CGSize) -> some View {
        ZStack {
            // Area where emulsion is peeling
            Path { path in
                path.move(to: CGPoint(x: size.width * 0.7, y: size.height * 0.1))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.9, y: size.height * 0.3),
                    control1: CGPoint(x: size.width * 0.8, y: size.height * 0.15),
                    control2: CGPoint(x: size.width * 0.85, y: size.height * 0.2)
                )
                path.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.35))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.65, y: size.height * 0.15),
                    control1: CGPoint(x: size.width * 0.75, y: size.height * 0.25),
                    control2: CGPoint(x: size.width * 0.7, y: size.height * 0.2)
                )
                path.closeSubpath()
            }
            .fill(Color.white.opacity(0.40))
            .blendMode(.screen)
        }
    }

    /// Cracked emulsion pattern
    private func crackedEffect(size: CGSize) -> some View {
        // Pre-computed crack lines to avoid complex type inference
        let cracks: [(CGFloat, CGFloat, Double, CGFloat, Double, CGFloat)] = [
            (0.45, 0.42, 0.5, 35, 0.20, 1.0),
            (0.55, 0.48, 1.2, 45, 0.25, 0.8),
            (0.48, 0.55, 2.0, 30, 0.18, 1.2),
            (0.52, 0.52, 2.8, 50, 0.22, 0.6),
            (0.42, 0.58, 3.5, 40, 0.28, 1.1),
            (0.58, 0.45, 4.2, 25, 0.16, 0.9),
            (0.50, 0.60, 5.0, 55, 0.24, 1.3),
            (0.47, 0.40, 5.8, 38, 0.20, 0.7)
        ]

        return ZStack {
            ForEach(0..<8, id: \.self) { i in
                let crack = cracks[i]
                let centerX = size.width * crack.0
                let centerY = size.height * crack.1
                let angle = crack.2
                let length = crack.3 * scale
                let opacity = crack.4
                let lineWidth = crack.5 * scale

                Path { path in
                    path.move(to: CGPoint(x: centerX, y: centerY))
                    path.addLine(to: CGPoint(
                        x: centerX + cos(angle) * length,
                        y: centerY + sin(angle) * length
                    ))
                }
                .stroke(Color.black.opacity(opacity), lineWidth: lineWidth)
            }
        }
        .blendMode(.multiply)
    }

    /// Scrape marks
    private func scrapeEffect(size: CGSize) -> some View {
        // Pre-computed scrape parameters to avoid complex type inference
        let scrapes: [(CGFloat, CGFloat, Double, CGFloat)] = [
            (0.35, 5, 0.25, 3.0),
            (0.48, -8, 0.32, 4.0),
            (0.55, 3, 0.28, 2.5),
            (0.65, -5, 0.35, 3.5)
        ]

        return ZStack {
            ForEach(0..<4, id: \.self) { i in
                let scrape = scrapes[i]
                let y = size.height * scrape.0
                let endOffset = scrape.1 * scale
                let opacity = scrape.2
                let lineWidth = scrape.3 * scale

                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.2, y: y))
                    path.addLine(to: CGPoint(x: size.width * 0.8, y: y + endOffset))
                }
                .stroke(Color.white.opacity(opacity), lineWidth: lineWidth)
            }
        }
        .blendMode(.screen)
    }

    /// Dented/pressed effect
    private func dentedEffect(size: CGSize) -> some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        creaseColor.opacity(0.15),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 40 * scale
                )
            )
            .frame(width: 80 * scale, height: 50 * scale)
            .position(x: size.width * 0.6, y: size.height * 0.5)
            .blendMode(.multiply)
    }

    /// Pocket-worn effect (overall wear)
    private func pocketWornEffect(size: CGSize) -> some View {
        ZStack {
            // Edge wear
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.clear,
                            Color.clear,
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .blendMode(.screen)

            // Corner rounding/wear - explicit corners instead of ForEach
            cornerWearCircle(at: .topLeading, size: size)
            cornerWearCircle(at: .topTrailing, size: size)
            cornerWearCircle(at: .bottomLeading, size: size)
            cornerWearCircle(at: .bottomTrailing, size: size)
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Light & Exposure Effects
    // ═══════════════════════════════════════════════════════════════════════════

    /// Light leak effect
    private func lightLeakEffect(warm: Bool, size: CGSize) -> some View {
        let leakColor = warm ? Color.orange : Color.red
        return ZStack {
            // Main leak from corner
            RadialGradient(
                colors: [
                    leakColor.opacity(0.30),
                    leakColor.opacity(0.15),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: min(size.width, size.height) * 0.7
            )
            .blendMode(.screen)

            // Secondary leak
            RadialGradient(
                colors: [
                    (warm ? Color.yellow : Color.pink).opacity(0.15),
                    Color.clear
                ],
                center: .bottomLeading,
                startRadius: 0,
                endRadius: min(size.width, size.height) * 0.4
            )
            .blendMode(.screen)
        }
    }

    /// Overexposed edge
    private func overexposedEdge(edge: Edge, size: CGSize) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.35),
                        Color.white.opacity(0.15),
                        Color.clear
                    ],
                    startPoint: edge == .top ? .top : .bottom,
                    endPoint: edge == .top ? .bottom : .top
                )
            )
            .frame(height: size.height * 0.25)
            .position(x: size.width / 2, y: edge == .top ? size.height * 0.125 : size.height * 0.875)
            .blendMode(.screen)
    }

    /// Chemical spill/processing error
    private func chemicalSpillEffect(size: CGSize) -> some View {
        ZStack {
            // Irregular chemical stain
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.15),
                            Color.blue.opacity(0.10),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.width * 0.35
                    )
                )
                .frame(width: size.width * 0.6, height: size.height * 0.4)
                .rotationEffect(.degrees(-20))
                .position(x: size.width * 0.4, y: size.height * 0.6)
                .blendMode(.multiply)

            // Edge discoloration
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: size.height * 0.15)
                .position(x: size.width / 2, y: size.height - size.height * 0.075)
                .blendMode(.multiply)
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Helper Functions
    // ═══════════════════════════════════════════════════════════════════════════

    /// Creates a corner wear circle for the pocket-worn effect
    private func cornerWearCircle(at corner: Alignment, size: CGSize) -> some View {
        Circle()
            .fill(Color.white.opacity(0.10))
            .frame(width: 30 * scale, height: 30 * scale)
            .position(cornerPosition(corner, in: size, inset: 15 * scale))
            .blendMode(.screen)
    }

    /// Calculates position for a corner alignment
    private func cornerPosition(_ corner: Alignment, in size: CGSize, inset: CGFloat) -> CGPoint {
        switch corner {
        case .topLeading:
            return CGPoint(x: inset, y: inset)
        case .topTrailing:
            return CGPoint(x: size.width - inset, y: inset)
        case .bottomLeading:
            return CGPoint(x: inset, y: size.height - inset)
        case .bottomTrailing:
            return CGPoint(x: size.width - inset, y: size.height - inset)
        default:
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }
}

