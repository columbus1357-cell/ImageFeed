//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.09.2026.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // 1. Создаем URL для запроса профиля
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("[ProfileService]: Invalid URL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        // 2. Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // 3. Используем наш универсальный objectTask, который сразу декодирует JSON в ProfileResult
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    // 4. Превращаем ProfileResult в красивую модель Profile для приложения
                    let profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespaces),
                        loginName: "@\(profileResult.username)",
                        bio: profileResult.bio
                    )
                    
                    // Сохраняем профиль в свойство класса
                    self.profile = profile
                    
                    // Возвращаем успех
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[ProfileService]: Error - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
