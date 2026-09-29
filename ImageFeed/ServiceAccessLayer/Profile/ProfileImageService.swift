//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Aleksandr on 22.09.2026.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String?
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    private(set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("[ProfileImageService]: Invalid URL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            let error = NSError(domain: "ProfileImageServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No token found"])
            completion(.failure(error))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    guard let smallImageURL = userResult.profileImage.small else {
                        let error = NSError(domain: "ProfileImageServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Avatar URL is nil"])
                        completion(.failure(error))
                        return
                    }
                    
                    self.avatarURL = smallImageURL
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": smallImageURL]
                    )
                    
                    completion(.success(smallImageURL))
                    
                case .failure(let error):
                    print("[ProfileImageService]: Error - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
