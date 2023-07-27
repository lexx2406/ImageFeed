//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 15.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatar = UIImage(named: "Photo.png")
        let imageView = UIImageView(image: avatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let verticalStack = UIStackView(arrangedSubviews: [self.nameLabel, self.loginNameLabel, self.descriptionLabel ])
        verticalStack.spacing = 8
        verticalStack.axis = .vertical
        view.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit.png") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            verticalStack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            verticalStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont(name: "Verdana Bold", size: 23)
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .white
        label.font = UIFont(name: "Verdana", size: 13)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .white
        label.font = UIFont(name: "Verdana", size: 13)
        return label
    }()
    
    @objc
    private func didTapButton() {
    }
    
}


