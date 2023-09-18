//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by Алексей Налимов on 18.09.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let imageListService = ImagesListService()
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testSetLike () {
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        view.setLike()
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable1() {
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
