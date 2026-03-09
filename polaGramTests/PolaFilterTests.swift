//
//  PolaFilterTests.swift
//  polaGramTests
//
//  Unit tests for PolaFilter enum and randomization.
//  Verifies filter distribution and properties.
//

import XCTest
@testable import polaGram

final class PolaFilterTests: XCTestCase {

    // MARK: - Legacy Randomization Tests

    /// Test that randomFilter returns nil approximately 20% of the time (legacy)
    func testRandomFilter_pristineRate() {
        var pristineCount = 0
        let totalSamples = 1000

        for _ in 0..<totalSamples {
            if PolaFilter.randomFilter() == nil {
                pristineCount += 1
            }
        }

        let rate = Double(pristineCount) / Double(totalSamples)
        // Should be roughly 20%, allow ±10% variance
        XCTAssertGreaterThan(rate, 0.10, "Pristine rate should be > 10%")
        XCTAssertLessThan(rate, 0.30, "Pristine rate should be < 30%")
    }

    /// Test that all filters are represented in random selection
    func testRandomFilter_allFiltersAppear() {
        var seenFilters = Set<PolaFilter>()
        let maxIterations = 10000

        for _ in 0..<maxIterations {
            if let filter = PolaFilter.randomFilter() {
                seenFilters.insert(filter)
            }
        }

        // Should see most (if not all) filters
        let allFilterCount = PolaFilter.allCases.count
        XCTAssertGreaterThan(seenFilters.count, allFilterCount / 2,
            "Should see at least half of all filters in \(maxIterations) iterations")
    }

    // MARK: - New Multi-Filter Randomization Tests

    /// Test that randomFilters returns empty array approximately 20% of the time
    func testRandomFilters_pristineRate() {
        var pristineCount = 0
        let totalSamples = 1000

        for _ in 0..<totalSamples {
            if PolaFilter.randomFilters().isEmpty {
                pristineCount += 1
            }
        }

        let rate = Double(pristineCount) / Double(totalSamples)
        // Should be roughly 20%, allow ±8% variance
        XCTAssertGreaterThan(rate, 0.12, "Pristine rate should be > 12%")
        XCTAssertLessThan(rate, 0.28, "Pristine rate should be < 28%")
    }

    /// Test filter count distribution
    func testRandomFilters_countDistribution() {
        var countHistogram = [Int: Int]()
        let totalSamples = 10000

        for _ in 0..<totalSamples {
            let filters = PolaFilter.randomFilters()
            countHistogram[filters.count, default: 0] += 1
        }

        // Should see some with 0 effects (~20%)
        XCTAssertGreaterThan(countHistogram[0] ?? 0, 1000, "Should have >10% pristine")

        // Should see some with 1 effect (~40%)
        XCTAssertGreaterThan(countHistogram[1] ?? 0, 3000, "Should have >30% with 1 effect")

        // Should see some with multiple effects
        let multiEffects = countHistogram.filter { $0.key > 1 }.values.reduce(0, +)
        XCTAssertGreaterThan(multiEffects, 2000, "Should have >20% with 2+ effects")

        // Should occasionally see "mangled" (many effects)
        let mangledCount = countHistogram.filter { $0.key >= 8 }.values.reduce(0, +)
        XCTAssertGreaterThan(mangledCount, 0, "Should have at least some mangled polas")
    }

    /// Test that filters in array are unique
    func testRandomFilters_uniqueInArray() {
        for _ in 0..<100 {
            let filters = PolaFilter.randomFilters()
            let uniqueFilters = Set(filters)
            XCTAssertEqual(filters.count, uniqueFilters.count, "All filters in array should be unique")
        }
    }

    // MARK: - Filter Count Test

    /// Test that there are exactly 50 filters
    func testFilterCount() {
        XCTAssertEqual(PolaFilter.allCases.count, 50,
            "Should have exactly 50 vintage filter effects")
    }

    // MARK: - Raw Value Tests

    /// Test that all filters have unique raw values
    func testRawValues_unique() {
        var rawValues = Set<Int>()
        for filter in PolaFilter.allCases {
            XCTAssertFalse(rawValues.contains(filter.rawValue),
                "Raw value \(filter.rawValue) should be unique")
            rawValues.insert(filter.rawValue)
        }
    }

    /// Test that raw values start at 1 and are sequential
    func testRawValues_sequential() {
        let rawValues = PolaFilter.allCases.map { $0.rawValue }.sorted()
        for (index, rawValue) in rawValues.enumerated() {
            XCTAssertEqual(rawValue, index + 1,
                "Raw value at index \(index) should be \(index + 1), got \(rawValue)")
        }
    }

    // MARK: - Round-trip Tests

    /// Test that filters can be stored and retrieved via raw value
    func testRoundTrip_rawValue() {
        for filter in PolaFilter.allCases {
            let rawValue = filter.rawValue
            let reconstructed = PolaFilter(rawValue: rawValue)
            XCTAssertEqual(reconstructed, filter,
                "Filter should round-trip through raw value")
        }
    }

    // MARK: - Edge Cases

    /// Test invalid raw value returns nil
    func testInvalidRawValue() {
        let invalidFilter = PolaFilter(rawValue: -1)
        XCTAssertNil(invalidFilter, "Negative raw value should return nil")

        let tooLargeFilter = PolaFilter(rawValue: 100)
        XCTAssertNil(tooLargeFilter, "Raw value 100 should return nil")
    }
}
