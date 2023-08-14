//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 12.08.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "token"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
