//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 15.07.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol { get set }
    var avatar: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginNameLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    
    func updateAvatar()
    func configView()
    func makeConstraints()
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    lazy var presenter: ProfilePresenterProtocol = {
        return ProfilePresenter()
    }()
    
    lazy var avatar = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var loginNameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapButton))
        return exitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        configView()
        makeConstraints()
        presenter.view = self
        presenter.viewDidLoad()
        updateAvatar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configView() {
        view.addSubview(avatar)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        
        avatar.image = UIImage(named: "avatar_image")
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .YPWhite
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.textColor = .YPGray
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .YPWhite
        exitButton.setImage(UIImage(named: "logout_button"), for: .normal)
        exitButton.accessibilityIdentifier = "logout button"
        exitButton.tintColor = .YPRed
        
    }
    
    func makeConstraints() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(with: url,
                           placeholder: UIImage(named: "avatar_image"),
                           options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }
    
    func showLogoutAlert() {
        let alert = presenter.makeAlert()
        present(alert, animated: true, completion: nil)
    }
}
