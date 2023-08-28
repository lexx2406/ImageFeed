//
//  ImageListModels.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 28.08.2023.
//

import Foundation

struct Photo {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: UrlsResult?
    let width: CGFloat
    let height: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
        case width = "width"
        case height = "height"
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult?
}

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
