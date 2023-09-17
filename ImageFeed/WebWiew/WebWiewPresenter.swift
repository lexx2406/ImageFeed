//
//  WebWiewPresenter.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 17.09.2023.
//

import UIKit

import UIKit

protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewControllerProtocol?
    private let authHelper: AuthHelperProtocol
      
      init(authHelper: AuthHelperProtocol) {
          self.authHelper = authHelper
      }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
