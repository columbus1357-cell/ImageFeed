//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import Foundation
import os

// MARK: - NetworkError

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

// MARK: - URLSession Extension

extension URLSession {
    
    // MARK: - Private Properties
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ImageFeed",
        category: "URLSession"
    )
    
    // MARK: - Public Methods
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    Self.logger.error("HTTP Error Status Code: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                Self.logger.error("URL Request Error: \(error.localizedDescription, privacy: .public)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                Self.logger.error("URL Session Error: Unknown error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
    
    // MARK: - Generic Object Task
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    
                    let jsonString = String(data: data, encoding: .utf8) ?? ""
                    Self.logger.error("Decoding Error: \(error.localizedDescription, privacy: .public), Data: \(jsonString, privacy: .public)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
    
}
