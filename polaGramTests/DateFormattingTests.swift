//
//  DateFormattingTests.swift
//  polaGramTests
//
//  Unit tests for date formatting used in pola frames.
//  Verifies the MM/dd/yy format used for date stamps.
//

import XCTest
@testable import polaGram

final class DateFormattingTests: XCTestCase {

    // The date formatter used in the app
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }

    // MARK: - Format Tests

    /// Test basic date formatting
    func testDateFormat_basic() {
        var components = DateComponents()
        components.year = 2026
        components.month = 3
        components.day = 15

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "03/15/26")
    }

    /// Test single digit month and day with leading zeros
    func testDateFormat_leadingZeros() {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 5

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "01/05/26")
    }

    /// Test double digit month and day
    func testDateFormat_doubleDigits() {
        var components = DateComponents()
        components.year = 2026
        components.month = 12
        components.day = 31

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "12/31/26")
    }

    /// Test year wrapping (two-digit year)
    func testDateFormat_twoDigitYear() {
        var components = DateComponents()
        components.year = 2099
        components.month = 6
        components.day = 15

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "06/15/99")
    }

    // MARK: - String Length Tests

    /// Test that formatted date is always 8 characters
    func testDateFormat_consistentLength() {
        let startDate = Date()
        let calendar = Calendar.current

        // Test 100 consecutive days
        for dayOffset in 0..<100 {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            let formatted = dateFormatter.string(from: date)
            XCTAssertEqual(formatted.count, 8,
                "Formatted date should always be 8 characters: '\(formatted)'")
        }
    }

    // MARK: - Slash Separator Tests

    /// Test that slashes are in correct positions
    func testDateFormat_slashPositions() {
        let formatted = dateFormatter.string(from: Date())

        XCTAssertEqual(formatted.count, 8)
        XCTAssertEqual(formatted[formatted.index(formatted.startIndex, offsetBy: 2)], "/",
            "Third character should be a slash")
        XCTAssertEqual(formatted[formatted.index(formatted.startIndex, offsetBy: 5)], "/",
            "Sixth character should be a slash")
    }

    // MARK: - Edge Cases

    /// Test leap year date
    func testDateFormat_leapYear() {
        var components = DateComponents()
        components.year = 2024  // Leap year
        components.month = 2
        components.day = 29

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "02/29/24")
    }

    /// Test first day of year
    func testDateFormat_newYearsDay() {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 1

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "01/01/26")
    }

    /// Test last day of year
    func testDateFormat_newYearsEve() {
        var components = DateComponents()
        components.year = 2026
        components.month = 12
        components.day = 31

        let date = Calendar.current.date(from: components)!
        let formatted = dateFormatter.string(from: date)

        XCTAssertEqual(formatted, "12/31/26")
    }

    // MARK: - Current Date Test

    /// Test that current date formats without error
    func testDateFormat_currentDate() {
        let now = Date()
        let formatted = dateFormatter.string(from: now)

        XCTAssertFalse(formatted.isEmpty)
        XCTAssertEqual(formatted.count, 8)
    }
}
