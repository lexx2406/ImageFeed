//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Алексей Налимов on 18.09.2023.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        sleep(5)
        print(webView.buttons)
        let loginTextField = webView.descendants(matching: .textField).element
        sleep(5)
        loginTextField.tap()
        loginTextField.typeText("")
        loginTextField.swipeUp()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(5)
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        cellToLike.tap()
        sleep(2)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssertTrue(app.staticTexts[""].exists)
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
}
