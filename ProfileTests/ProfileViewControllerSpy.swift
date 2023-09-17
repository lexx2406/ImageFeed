//
//  ProfileViewControllerSpy.swift
//  ProfileTests
//
//  Created by Алексей Налимов on 17.09.2023.
//

@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: ImageFeed.ProfilePresenterProtocol
    
    init (presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    var avatar: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var loginNameLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var update: Bool = false
    var views: Bool = false
    var constraints: Bool = false
    var alert: Bool = false
    
    func updateAvatar() {
        update = true
    }
    
    func configView() {
        views = true
    }
    
    func makeConstraints() {
        constraints = true
    }
    
    func showAlert() {
        presenter.logout()
    }
    
    func showLogoutAlert() {
        alert = true
    }
}
