//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 12.08.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let splashUIImageView = UIImageView()
    private let alertPresenter = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (oauth2TokenStorage.token != nil) {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController")
                    as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func setUpUI() {
        view.backgroundColor = .black
        view.addSubview(splashUIImageView)
        splashUIImageView.image = UIImage(named: "splash_screen_logo")
        splashUIImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splashUIImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashUIImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashUIImageView.widthAnchor.constraint(equalToConstant: 75),
            splashUIImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_vc vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure:
                self.alertPresenter.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonText: "OK", completion: nil),
                                         erorr: Error.self as! Error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.userName else { return }
                self.profileImageService.fetchProfileImageURL(username: username)  { _ in }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
                UIBlockingProgressHUD.dismiss()
            case .failure:
                self.alertPresenter.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonText: "OK", completion: nil),
                                         erorr: Error.self as! Error)
            }
        }
    }
}
