//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Алексей Налимов on 17.09.2023.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewControllerProtocol?
    func viewDidLoad() { viewDidLoadCalled = true }
    func didUpdateProgressValue(_ newValue: Double) {}
    func code(from url: URL) -> String? { return nil }
}
