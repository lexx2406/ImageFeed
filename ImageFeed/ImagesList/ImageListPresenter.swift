//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Алексей Налимов on 15.09.2023.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func checkCompletedList(_ indexPath: IndexPath)
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func makeAlert(with error: Error) -> UIAlertController
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    internal let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func checkCompletedList(_ indexPath: IndexPath) {
        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
            fetchPhotosNextPage()
        }
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike, {[weak self] result in
            guard let self else { return }
            switch result{
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        })
    }

    internal func makeAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: "Error",
            message: "The service is unavailable",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.dismiss(animated: true)
        return alert
    }
}

