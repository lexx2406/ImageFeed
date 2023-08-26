//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 26.08.2023.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let storageToken = OAuth2TokenStorage()
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    struct UserResult: Codable {
        let profileImage: [String:String]
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }

    struct ProfileImage: Codable {
        let profileImage: [String:String]
        
        init(decodedData: UserResult) {
            self.profileImage = decodedData.profileImage
        }
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        let request = makeRequest(token: storageToken.token!, username: username)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let decodedObject):
                let avatarURL = ProfileImage(decodedData: decodedObject)
                self.avatarURL = avatarURL.profileImage["small"]
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification, object: self,userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String, username: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)" + "/users/" + username) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func clean() {
        avatarURL = nil
        task?.cancel()
        task = nil
    }
}

