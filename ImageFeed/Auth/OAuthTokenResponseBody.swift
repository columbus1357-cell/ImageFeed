//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
    
