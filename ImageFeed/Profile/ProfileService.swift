//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 26.08.2023.
//

import Foundation

final class ProfileService {
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    static let shared = ProfileService()
    
    struct ProfileResult: Codable {
        let username: String
        let first_name: String
        let last_name: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case first_name = "first_name"
            case last_name = "last_name"
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
            self.name = (data.first_name) + " " + (data.last_name ?? "")
            self.loginName = "@" + (data.username)
            self.bio = data.bio
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeRequest(token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
                case .success(let decodedObject):
                    let profile = Profile(data: decodedObject)
                    self?.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)" + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func clean() {
        profile = nil
        task?.cancel()
        task = nil
    }
}
        
        
