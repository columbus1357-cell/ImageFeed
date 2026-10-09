//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Aleksandr on 16.08.2026.
//

import Foundation

enum Constants {
    static let accessKey: String = "5ZLVzMMF_nOsjBxpdVA4q5N1Kmw9MN7PFggW3rT_5S8"
    static let secretKey: String = "mvNdB9Cq_iaaC_bxFzMd2N9I_wbgtWYjC5Q9AhVRVKo"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURLString: String = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURLString: Constants.defaultBaseURLString
        )
    }
}
