//
//  MovieStreamingAppUITests.swift
//  MovieStreamingAppUITests
//

import XCTest

final class MovieStreamingAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - App Launch

    @MainActor
    func test_login_success_flow() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST")
        app.launch()

        let emailField = app.textFields["login_email"]
        let passwordField = app.secureTextFields["login_password"]
        let loginButton = app.buttons["login_button"]

        XCTAssertTrue(emailField.waitForExistence(timeout: 5))

        emailField.tap()
        emailField.typeText("john@test.com")

        passwordField.tap()
        passwordField.typeText("123456")

        loginButton.tap()

        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
    }

    // MARK: - Navigation

    @MainActor
            func test_navigation_between_tabs() throws {
        let app = XCUIApplication()
        app.launch()

        // suppose que l'utilisateur est déjà connecté
        let moviesTab = app.tabBars.buttons["tab_movies"]
        let profileTab = app.tabBars.buttons["tab_profile"]

        XCTAssertTrue(moviesTab.waitForExistence(timeout: 5))
        XCTAssertTrue(profileTab.exists)

        profileTab.tap()
        moviesTab.tap()
    }

    // MARK: - Movie List

    @MainActor
    func test_movies_list_is_displayed() throws {
        let app = XCUIApplication()
        app.launch()

        let moviesList = app.tables["movies_list"]
        XCTAssertTrue(moviesList.waitForExistence(timeout: 5))
    }

    // MARK: - Performance

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
