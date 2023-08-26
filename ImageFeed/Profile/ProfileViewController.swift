//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 15.07.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storageToken = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configView()
        makeConstraints()
        updateProfileDetails(profile: profileService.profile!)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton.systemButton(with: UIImage(named: "Exit.png")!, target: self, action: #selector(self.didTapButton))
        return exitButton
    }()
    
    private func configView() {
        view.addSubview(avatar)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        
        avatar.image = UIImage(named: "Photo")
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.textColor = .white
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        exitButton.setImage(UIImage(named: "logout_button"), for: .normal)
        exitButton.tintColor = .red
        
    }
    
    private func makeConstraints() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(with: url,
                           placeholder: UIImage(named: "Photo"),
                           options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }
    
    private func logout() {
        storageToken.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Bye, Bye!",
            message: "Are you shure you want to continue?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
}
    
    extension ProfileViewController {
        private func updateProfileDetails(profile: ProfileService.Profile?) {
            guard let profile = profileService.profile else { return }
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
    
    
   
