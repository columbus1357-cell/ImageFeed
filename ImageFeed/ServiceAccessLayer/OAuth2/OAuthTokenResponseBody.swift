//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation

// MARK: - OAuthTokenResponseBody

struct OAuthTokenResponseBody: Decodable {

    // MARK: - Internal Properties

    let accessToken: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
