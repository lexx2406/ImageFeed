//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 25.08.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}
