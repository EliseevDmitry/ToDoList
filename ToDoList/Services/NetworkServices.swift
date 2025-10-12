//
//  NetworkServices.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Network layer errors.
enum NetworkError: Error {
    case badData
}

/// Network service protocol.
protocol INetworkServices {
    /// Fetches and decodes data from a URL.
    /// - Parameters:
    ///   - url: Request URL.
    ///   - type: Codable model type.
    ///   - completion: Result with decoded model or error.
    func fetchEntityData<T: Codable>(
        url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

/// Network service implementation using URLSession.
final class NetworkServices: INetworkServices {
    private let session: IURLSession
    
    /// Initializes service with injectable session.
    /// - Parameter session: URLSession or its protocol wrapper.
    init(session: IURLSession = URLSession.shared) {
        self.session = session
    }
}

//MARK: - Public functions
extension NetworkServices {
    /// Fetches and decodes any Codable model from a URL.
    func fetchEntityData<T: Codable>(
        url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        fetchData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let entity = try self.decodeData(data, as: type)
                    completion(.success(entity))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: - Private functions
extension NetworkServices {
    /// Performs a low-level data request.
    private func fetchData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validate()
            } catch {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    /// Decodes data into a Codable model.
    /// - Throws: Decoding error.
    private func decodeData<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}
