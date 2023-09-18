//
//  ImageFeedUITestsLaunchTests.swift
//  ImageFeedUITests
//
//  Created by Алексей Налимов on 18.09.2023.
//

import XCTest

final class ImageFeedUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool { true }
    override func setUpWithError() throws { continueAfterFailure = false }
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
