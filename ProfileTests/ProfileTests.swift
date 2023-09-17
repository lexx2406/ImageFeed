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
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testGetUrlForProfileImage() {
        // Given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        
        // When
        let url = presenter.getUrlForProfileImage()?.absoluteString
        
        // Then
        XCTAssertEqual(url, "\(AuthConfiguration.standard.defaultBaseURL)")
    }
    
    func testExitFromProfile() {
        // Given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        // When
        view.showAlert()
        
        // Then
        XCTAssertTrue(presenter.didLogoutCalled)
    }
    
    func testLoadProfileInfo() {
        // Given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        // When
        presenter.updateProfileDetails(profile: profileService.profile)
        
        // Then
        XCTAssertTrue(view.views)
        XCTAssertTrue(view.constraints)
    }
}
