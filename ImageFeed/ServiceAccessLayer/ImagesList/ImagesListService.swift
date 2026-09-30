//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Aleksandr on 29.09.2026.
//

import Foundation
import UIKit

final class ImagesListService {
    
    // MARK: - Public Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    
    // MARK: - Private Properties
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    private static let dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage) else {
            print("[ImagesListService fetchPhotosNextPage]: Failed to create URL request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            self.task = nil
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { photoResult in
                    let date: Date?
                    if let dateString = photoResult.createdAt {
                        date = Self.dateFormatter.date(from: dateString)
                    } else {
                        date = nil
                    }
                    
                    return Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: date,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.regular,
                        isLiked: photoResult.likedByUser
                    )
                }
                
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": newPhotos]
                )
                
            case .failure(let error):
                print("[ImagesListService fetchPhotosNextPage]: Failed to fetch photos - \(error.localizedDescription)")
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: isLike
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
                
            case .failure(let error):
                print("[ImagesListService changeLike]: Failed to change like status - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func clearPhotos() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
    
    // MARK: - Private Methods
    
    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=10") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = tokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func makeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        if let token = tokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
