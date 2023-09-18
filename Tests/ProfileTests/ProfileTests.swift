//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Алексей Налимов on 17.09.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {

        let profileService = ProfileService()
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testGetUrlForProfileImage() {
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let url = presenter.getUrlForProfileImage()?.absoluteString
        XCTAssertEqual(url, "\(AuthConfiguration.standard.defaultBaseURL)")
    }
    
    func testExitFromProfile() {
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        view.showAlert()
        XCTAssertTrue(presenter.didLogoutCalled)
    }
    
    func testLoadProfileInfo() {
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        presenter.updateProfileDetails(profile: profileService.profile)
        XCTAssertTrue(view.views)
        XCTAssertTrue(view.constraints)
    }
}
