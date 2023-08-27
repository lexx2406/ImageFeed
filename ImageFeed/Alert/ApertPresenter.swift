//
//  ApertPresenter.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 27.08.2023.
//

import UIKit

final class AlertPresenter {
    func showAlert(in vc: UIViewController, with model: AlertModel, erorr: Error) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
