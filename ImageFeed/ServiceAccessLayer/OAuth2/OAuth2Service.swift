//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation
import os

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - OAuth2Service

final class OAuth2Service {

    // MARK: - Static Properties

    static let shared = OAuth2Service()

    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ImageFeed",
        category: "OAuth2Service"
    )

    // MARK: - Init

    private init() {}

    // MARK: - Public Methods

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                } catch {
                    self.logger.error("Decoding error: \(error.localizedDescription, privacy: .public)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                self.logger.error("Network error: \(error.localizedDescription, privacy: .public)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Private Methods

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
}
