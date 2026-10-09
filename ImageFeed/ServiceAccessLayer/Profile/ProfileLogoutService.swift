//
//  ProfileLogoutService.swift.swift
//  ImageFeed
//
//  Created by Aleksandr on 29.09.2026.
//

import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    
    // MARK: - Singleton
    
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    // MARK: - Public Methods
    
    func logout() {
        cleanCookies()
        clearStorage()
        switchToSplashViewController()
    }
    
    // MARK: - Private Methods
    
    private func cleanCookies() {
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in

            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearStorage() {

        OAuth2TokenStorage().token = nil
        
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearAvatar()
        ImagesListService.shared.clearPhotos()
    }
    
    private func switchToSplashViewController() {
        // Возвращаемся на SplashViewController
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}
