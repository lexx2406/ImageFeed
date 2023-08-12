//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 12.08.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIndentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewWillAppear(_ animated: Bool) {
        if let token = OAuth2TokenStorage().token {
            swithToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIndentifier, sender: nil)}
        
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIndentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController.delegate = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIndentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
