//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation
import SwiftKeychainWrapper
// MARK: - OAuth2TokenStorage

final class OAuth2TokenStorage {

    // MARK: - Private Properties

    private let tokenKey = "BearerToken"

    // MARK: - Public Properties

    var token: String? {
            get {
                KeychainWrapper.standard.string(forKey: tokenKey)
            }
            set {
                if let newValue = newValue {
                    KeychainWrapper.standard.set(newValue, forKey: tokenKey)
                } else {
                    KeychainWrapper.standard.removeObject(forKey: tokenKey)
                }
            }
        }
    }
