//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Алексей Налимов on 17.09.2023.
//

@testable import ImageFeed
import UIKit

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    func load(request: URLRequest) { loadRequestCalled = true }
    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}
