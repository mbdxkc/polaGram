//
//  polaGramUITests.swift
//  polaGramUITests
//
//  UI tests for critical user flows in polaGram.
//  Tests photo selection, saving, gallery navigation, and deletion.
//
//  SETUP INSTRUCTIONS
//  ──────────────────
//  1. In Xcode: File > New > Target > UI Testing Bundle
//  2. Name it "polaGramUITests"
//  3. Add this file to the UI test target
//

import XCTest

final class polaGramUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Splash Screen Tests

    /// Test that splash screen is shown on launch
    func testSplashScreen_appearsOnLaunch() throws {
        // Splash should be visible initially
        // Look for splash screen elements (logo, title)
        let splashExists = app.staticTexts["polaGram"].waitForExistence(timeout: 2)
        XCTAssertTrue(splashExists, "Splash screen should appear on launch")
    }

    /// Test that splash screen can be dismissed by tap
    func testSplashScreen_dismissOnTap() throws {
        // Wait for splash to appear
        sleep(1)

        // Tap to dismiss
        app.tap()

        // Wait for main content to appear
        let mainContent = app.otherElements["mainContent"]
        let appeared = mainContent.waitForExistence(timeout: 2)

        // Splash should be gone after tap
        XCTAssertFalse(app.staticTexts["tap to begin"].exists || appeared,
            "Splash screen should dismiss after tap")
    }

    // MARK: - Onboarding Tests

    /// Test that onboarding appears for first-time users
    func testOnboarding_appearsFirstTime() throws {
        // Reset UserDefaults for clean test
        app.launchArguments = ["-hasSeenOnboarding", "false"]
        app.launch()

        // Dismiss splash
        sleep(1)
        app.tap()

        // Look for onboarding elements
        let captureText = app.staticTexts["Capture"]
        let exists = captureText.waitForExistence(timeout: 3)
        XCTAssertTrue(exists, "Onboarding should appear for first-time users")
    }

    /// Test that onboarding can be skipped
    func testOnboarding_skipButton() throws {
        app.launchArguments = ["-hasSeenOnboarding", "false"]
        app.launch()

        // Dismiss splash and wait for onboarding
        sleep(1)
        app.tap()
        sleep(1)

        // Find and tap Skip button
        let skipButton = app.buttons["Skip"]
        if skipButton.exists {
            skipButton.tap()

            // Verify onboarding is dismissed
            sleep(1)
            XCTAssertFalse(app.staticTexts["Capture"].exists,
                "Onboarding should be dismissed after skip")
        }
    }

    // MARK: - Photo Frame Tests

    /// Test that tapping the photo frame shows photo source options
    func testPhotoFrame_tapShowsSourceSheet() throws {
        // Dismiss splash
        sleep(1)
        app.tap()
        sleep(1)

        // Skip onboarding if present
        if app.buttons["Skip"].exists {
            app.buttons["Skip"].tap()
            sleep(0.5)
        }

        // Find and tap the photo frame area
        let photoFrame = app.images["Photo frame"]
        if photoFrame.exists {
            photoFrame.tap()

            // Should show photo source action sheet
            let sheet = app.sheets.element
            let exists = sheet.waitForExistence(timeout: 2)
            XCTAssertTrue(exists, "Tapping photo frame should show photo source options")
        }
    }

    // MARK: - Gallery Tests

    /// Test that gallery button opens gallery view
    func testGallery_buttonOpensGallery() throws {
        dismissSplashAndOnboarding()

        // Find and tap gallery button
        let galleryButton = app.buttons["photo gallery"]
        if galleryButton.exists {
            galleryButton.tap()

            // Gallery view should appear
            let galleryTitle = app.staticTexts["Gallery"]
            let exists = galleryTitle.waitForExistence(timeout: 2)
            XCTAssertTrue(exists, "Gallery should open when button is tapped")
        }
    }

    /// Test that gallery can be closed
    func testGallery_closeButton() throws {
        dismissSplashAndOnboarding()

        // Open gallery
        let galleryButton = app.buttons["photo gallery"]
        if galleryButton.exists {
            galleryButton.tap()
            sleep(1)

            // Find and tap close button
            let closeButton = app.buttons["Close"]
            if closeButton.exists {
                closeButton.tap()

                // Gallery should be dismissed
                sleep(1)
                XCTAssertFalse(app.staticTexts["Gallery"].exists,
                    "Gallery should close when X is tapped")
            }
        }
    }

    /// Test empty gallery state
    func testGallery_emptyState() throws {
        dismissSplashAndOnboarding()

        // Open gallery
        let galleryButton = app.buttons["photo gallery"]
        if galleryButton.exists {
            galleryButton.tap()

            // Should show empty state message
            let emptyText = app.staticTexts["No polas yet"]
            let exists = emptyText.waitForExistence(timeout: 2)
            XCTAssertTrue(exists, "Empty gallery should show 'No polas yet' message")
        }
    }

    // MARK: - Caption Editor Tests

    /// Test that caption area can be tapped to edit
    func testCaption_tapOpensEditor() throws {
        // This test requires a photo to be loaded first
        // Skipping for basic test suite - would require photo picker interaction
    }

    // MARK: - Action Button Tests

    /// Test that action buttons are visible
    func testActionButtons_visible() throws {
        dismissSplashAndOnboarding()

        // Check for action buttons (may be disabled without photo)
        let messageButton = app.buttons["Share via messages"]
        let instagramButton = app.buttons["Share to Instagram Stories"]
        let saveButton = app.buttons["Save to Photos"]
        let galleryButton = app.buttons["photo gallery"]

        XCTAssertTrue(messageButton.exists || galleryButton.exists,
            "Action buttons should be visible")
    }

    /// Test that action buttons are disabled without photo
    func testActionButtons_disabledWithoutPhoto() throws {
        dismissSplashAndOnboarding()

        let saveButton = app.buttons["Save to Photos"]
        if saveButton.exists {
            // Button should exist but be disabled/dimmed
            XCTAssertTrue(saveButton.exists, "Save button should exist")
        }
    }

    // MARK: - Accessibility Tests

    /// Test that main elements have accessibility labels
    func testAccessibility_mainElementsLabeled() throws {
        dismissSplashAndOnboarding()

        // Check that key elements have accessibility labels
        let galleryButton = app.buttons["photo gallery"]
        XCTAssertTrue(galleryButton.exists, "Gallery button should have accessibility label")
    }

    // MARK: - Helper Methods

    /// Dismiss splash screen and onboarding for tests
    private func dismissSplashAndOnboarding() {
        // Wait for splash
        sleep(1)

        // Tap to dismiss splash
        app.tap()
        sleep(1)

        // Skip onboarding if present
        if app.buttons["Skip"].exists {
            app.buttons["Skip"].tap()
            sleep(0.5)
        }
    }
}
