//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 12.08.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychain.string(forKey: "token")
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: "token")
            } else {
                keychain.removeObject(forKey: "token")
            }
            
        }
    }
    
    private init() { }
    
}
