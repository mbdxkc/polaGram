//
//  CharStyleTests.swift
//  polaGramTests
//
//  Unit tests for CharStyle determinism.
//  Verifies that the pseudo-random character styling produces
//  consistent, reproducible results for the same inputs.
//

import XCTest
@testable import polaGram

final class CharStyleTests: XCTestCase {

    // MARK: - Determinism Tests

    /// Test that CharStyle produces identical values for same index/seed
    func testDeterminism_sameInputs_sameOutputs() {
        let seed = 12345

        for index in 0..<100 {
            let style1 = CharStyle(index: index, seed: seed)
            let style2 = CharStyle(index: index, seed: seed)

            XCTAssertEqual(style1.inkDensity, style2.inkDensity,
                "inkDensity should be deterministic for index \(index)")
            XCTAssertEqual(style1.baselineDrop, style2.baselineDrop,
                "baselineDrop should be deterministic for index \(index)")
            XCTAssertEqual(style1.tilt, style2.tilt,
                "tilt should be deterministic for index \(index)")
            XCTAssertEqual(style1.spacingType, style2.spacingType,
                "spacingType should be deterministic for index \(index)")
            XCTAssertEqual(style1.xJitter, style2.xJitter,
                "xJitter should be deterministic for index \(index)")
        }
    }

    /// Test that different indices produce different styles
    func testVariation_differentIndices_differentStyles() {
        let seed = 42
        var inkDensities = Set<Double>()
        var tilts = Set<Double>()

        for index in 0..<50 {
            let style = CharStyle(index: index, seed: seed)
            inkDensities.insert(style.inkDensity)
            tilts.insert(style.tilt)
        }

        // Should have multiple unique values (not all the same)
        XCTAssertGreaterThan(inkDensities.count, 10,
            "Should produce varied ink densities across indices")
        XCTAssertGreaterThan(tilts.count, 10,
            "Should produce varied tilts across indices")
    }

    /// Test that different seeds produce different styles for same index
    func testVariation_differentSeeds_differentStyles() {
        let index = 5

        let style1 = CharStyle(index: index, seed: 111)
        let style2 = CharStyle(index: index, seed: 222)
        let style3 = CharStyle(index: index, seed: 333)

        // At least some values should differ
        let allSame = style1.inkDensity == style2.inkDensity &&
                      style2.inkDensity == style3.inkDensity &&
                      style1.tilt == style2.tilt &&
                      style2.tilt == style3.tilt

        XCTAssertFalse(allSame, "Different seeds should produce different styles")
    }

    // MARK: - Value Range Tests

    /// Test that inkDensity stays within expected bounds
    func testBounds_inkDensity() {
        for index in 0..<100 {
            for seed in [0, 12345, 999999] {
                let style = CharStyle(index: index, seed: seed)
                XCTAssertGreaterThanOrEqual(style.inkDensity, 0.45,
                    "inkDensity should be >= 0.45")
                XCTAssertLessThanOrEqual(style.inkDensity, 0.85,
                    "inkDensity should be <= 0.85")
            }
        }
    }

    /// Test that tilt stays within expected bounds
    func testBounds_tilt() {
        for index in 0..<100 {
            for seed in [0, 12345, 999999] {
                let style = CharStyle(index: index, seed: seed)
                XCTAssertGreaterThanOrEqual(style.tilt, -4.8,
                    "tilt should be >= -4.8")
                XCTAssertLessThanOrEqual(style.tilt, 4.8,
                    "tilt should be <= 4.8")
            }
        }
    }

    /// Test that spacingType stays within expected bounds
    func testBounds_spacingType() {
        for index in 0..<100 {
            for seed in [0, 12345, 999999] {
                let style = CharStyle(index: index, seed: seed)
                XCTAssertGreaterThanOrEqual(style.spacingType, 0,
                    "spacingType should be >= 0")
                XCTAssertLessThan(style.spacingType, 5,
                    "spacingType should be < 5")
            }
        }
    }

    // MARK: - Stuck Key Tests

    /// Test that stuck keys occur at approximately the expected rate (~12.5%)
    func testStuckKeyRate() {
        let seed = 42
        var stuckKeyCount = 0
        let totalSamples = 1000

        for index in 0..<totalSamples {
            let style = CharStyle(index: index, seed: seed)
            // Stuck keys have higher baselineDrop (0.08-0.18)
            if style.baselineDrop >= 0.08 {
                stuckKeyCount += 1
            }
        }

        let rate = Double(stuckKeyCount) / Double(totalSamples)
        // Should be roughly 12.5% (1/8), allow some variance
        XCTAssertGreaterThan(rate, 0.08, "Stuck key rate should be > 8%")
        XCTAssertLessThan(rate, 0.20, "Stuck key rate should be < 20%")
    }

    // MARK: - Edge Cases

    /// Test with index 0
    func testEdgeCase_indexZero() {
        let style = CharStyle(index: 0, seed: 12345)
        XCTAssertNotNil(style.inkDensity)
        XCTAssertNotNil(style.tilt)
    }

    /// Test with negative seed (hash will handle it)
    func testEdgeCase_negativeSeed() {
        let style = CharStyle(index: 5, seed: -12345)
        // Should not crash and should produce valid values
        XCTAssertGreaterThanOrEqual(style.inkDensity, 0.0)
        XCTAssertLessThanOrEqual(style.inkDensity, 1.0)
    }

    /// Test with very large index
    func testEdgeCase_largeIndex() {
        let style = CharStyle(index: 10000, seed: 42)
        XCTAssertGreaterThanOrEqual(style.inkDensity, 0.45)
        XCTAssertLessThanOrEqual(style.inkDensity, 0.85)
    }

    /// Test with seed of 0
    func testEdgeCase_zeroSeed() {
        let style = CharStyle(index: 5, seed: 0)
        XCTAssertNotNil(style.inkDensity)
        XCTAssertNotNil(style.tilt)
    }

    // MARK: - Performance

    /// Test that CharStyle initialization is fast
    func testPerformance_initialization() {
        measure {
            for index in 0..<1000 {
                _ = CharStyle(index: index, seed: 12345)
            }
        }
    }
}
