//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 28.08.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Codable {
    var userName: String
    var name: String
    var loginName: String
    var bio: String?
    
    init(data: ProfileResult) {
        self.userName = data.username
        self.name = (data.firstName) + " " + (data.lastName ?? "")
        self.loginName = "@" + (data.username)
        self.bio = data.bio
    }
}
