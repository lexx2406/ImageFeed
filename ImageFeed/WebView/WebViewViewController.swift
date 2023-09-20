//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 09.08.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_vc: WebViewViewController)
}

protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    @IBOutlet weak private var progressView: UIProgressView!
    
    @IBOutlet weak private var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(_vc: self)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(_vc: self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
