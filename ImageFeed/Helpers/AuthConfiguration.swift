//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 17.09.2023.
//

import UIKit

struct Constants {
    static let accessKey = "4M1hbKFrgOGW5zEGRqQEHi9sm6qGcn6o6Q55SsqHf0g"
    static let secretKey = "PTO2GO888BScMqtZleOGlLR2ajvsLoM_bolCVnPESAU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          authURLString: Constants.unsplashAuthorizeURLString,
                          defaultBaseURL: Constants.defaultBaseURL)
    }
}
