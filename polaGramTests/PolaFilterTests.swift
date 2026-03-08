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

    // MARK: - Randomization Tests

    /// Test that randomFilter returns nil approximately 50% of the time
    func testRandomFilter_pristineRate() {
        var pristineCount = 0
        let totalSamples = 1000

        for _ in 0..<totalSamples {
            if PolaFilter.randomFilter() == nil {
                pristineCount += 1
            }
        }

        let rate = Double(pristineCount) / Double(totalSamples)
        // Should be roughly 50%, allow ±10% variance
        XCTAssertGreaterThan(rate, 0.40, "Pristine rate should be > 40%")
        XCTAssertLessThan(rate, 0.60, "Pristine rate should be < 60%")
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

    /// Test that raw values start at 0 and are sequential
    func testRawValues_sequential() {
        let rawValues = PolaFilter.allCases.map { $0.rawValue }.sorted()
        for (index, rawValue) in rawValues.enumerated() {
            XCTAssertEqual(rawValue, index,
                "Raw value at index \(index) should be \(index), got \(rawValue)")
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
