//
//  NetworkSession.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodeFailed
}

final class NetworkSession {
    
    /// GET
    static let getSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        return Session(configuration: config)
    }()
    
    /// POST
    static let postSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return Session(configuration: config)
    }()
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - GET
    func get<T: Codable>(
        url: String,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkSession.getSession
                .request(
                    url,
                    method: .get,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: headers
                )
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // MARK: - POST Multipart Form
    func postMultipartForm<T: Codable>(
        url: String,
        parameters: [String: Any],
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkSession.postSession.upload(
                multipartFormData: { formData in
                    for (key, value) in parameters {
                        let data: Data
                        
                        if let string = value as? String {
                            data = Data(string.utf8)
                        } else {
                            data = Data("\(value)".utf8)
                        }
                        
                        formData.append(data, withName: key)
                    }
                },
                to: url,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    continuation.resume(returning: model)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - POST Multipart Form
    func uploadImage<T: Codable>(
        url: String,
        imageData: Data,
        imageKey: String = "georgeGroups",
        parameters: [String: String]? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkSession.postSession
                .upload(
                    multipartFormData: { formData in
                        formData.append(
                            imageData,
                            withName: imageKey,
                            fileName: "image.jpg",
                            mimeType: "image/jpeg"
                        )
                        
                        // 其他参数
                        parameters?.forEach { key, value in
                            if let data = value.data(using: .utf8) {
                                formData.append(data, withName: key)
                            }
                        }
                    },
                    to: url,
                    headers: headers
                )
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
