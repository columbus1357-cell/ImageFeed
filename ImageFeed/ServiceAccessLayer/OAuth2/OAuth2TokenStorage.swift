//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation

// MARK: - OAuth2TokenStorage

final class OAuth2TokenStorage {

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard
    private let tokenKey = "BearerToken"

    // MARK: - Public Properties

    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
