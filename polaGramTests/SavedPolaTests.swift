//
//  SavedPolaTests.swift
//  polaGramTests
//
//  Unit tests for SavedPola SwiftData model.
//  Verifies model initialization, filter conversion, and date handling.
//

import XCTest
import SwiftData
@testable import polaGram

final class SavedPolaTests: XCTestCase {

    // MARK: - Initialization Tests

    /// Test basic initialization with all parameters
    func testInitialization_allParameters() {
        let testData = Data([0x00, 0x01, 0x02, 0x03])
        let testCaption = "Test caption"
        let testDate = Date()
        let testFilterRaw = 5

        let pola = SavedPola(
            imageData: testData,
            caption: testCaption,
            createdAt: testDate,
            filterRawValue: testFilterRaw
        )

        XCTAssertEqual(pola.imageData, testData)
        XCTAssertEqual(pola.caption, testCaption)
        XCTAssertEqual(pola.createdAt, testDate)
        XCTAssertEqual(pola.filterRawValue, testFilterRaw)
    }

    /// Test initialization with default date
    func testInitialization_defaultDate() {
        let beforeCreate = Date()
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test"
        )
        let afterCreate = Date()

        XCTAssertGreaterThanOrEqual(pola.createdAt, beforeCreate)
        XCTAssertLessThanOrEqual(pola.createdAt, afterCreate)
    }

    /// Test initialization with nil filter
    func testInitialization_nilFilter() {
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test",
            filterRawValue: nil
        )

        XCTAssertNil(pola.filterRawValue)
        XCTAssertNil(pola.filter)
    }

    // MARK: - Filter Conversion Tests

    /// Test filter computed property with valid raw value
    func testFilterProperty_validRawValue() {
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test",
            filterRawValue: 0
        )

        XCTAssertNotNil(pola.filter)
        XCTAssertEqual(pola.filter?.rawValue, 0)
    }

    /// Test filter computed property with nil raw value
    func testFilterProperty_nilRawValue() {
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test",
            filterRawValue: nil
        )

        XCTAssertNil(pola.filter)
    }

    /// Test filter computed property with invalid raw value
    func testFilterProperty_invalidRawValue() {
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test",
            filterRawValue: 999
        )

        // Invalid raw value should result in nil filter
        XCTAssertNil(pola.filter)
    }

    // MARK: - Empty Data Tests

    /// Test with empty image data
    func testEmptyImageData() {
        let pola = SavedPola(
            imageData: Data(),
            caption: "Test"
        )

        XCTAssertTrue(pola.imageData.isEmpty)
    }

    /// Test with empty caption
    func testEmptyCaption() {
        let pola = SavedPola(
            imageData: Data([0xFF]),
            caption: ""
        )

        XCTAssertTrue(pola.caption.isEmpty)
    }

    // MARK: - Edge Cases

    /// Test with very long caption
    func testLongCaption() {
        let longCaption = String(repeating: "a", count: 1000)
        let pola = SavedPola(
            imageData: Data(),
            caption: longCaption
        )

        XCTAssertEqual(pola.caption.count, 1000)
    }

    /// Test with large image data
    func testLargeImageData() {
        let largeData = Data(repeating: 0xFF, count: 1_000_000)
        let pola = SavedPola(
            imageData: largeData,
            caption: "Test"
        )

        XCTAssertEqual(pola.imageData.count, 1_000_000)
    }

    /// Test with unicode caption
    func testUnicodeCaption() {
        let unicodeCaption = "Hello 🌍 你好 مرحبا"
        let pola = SavedPola(
            imageData: Data(),
            caption: unicodeCaption
        )

        XCTAssertEqual(pola.caption, unicodeCaption)
    }

    // MARK: - All Filter Raw Values

    /// Test that all valid filter raw values work correctly
    func testAllFilterRawValues() {
        for rawValue in 0..<50 {
            let pola = SavedPola(
                imageData: Data(),
                caption: "Test",
                filterRawValue: rawValue
            )

            XCTAssertNotNil(pola.filter,
                "Filter should exist for raw value \(rawValue)")
            XCTAssertEqual(pola.filter?.rawValue, rawValue)
        }
    }
}
