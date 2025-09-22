//
//  NetworkServices.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

enum NetworkError: Error {
    case badData
}

protocol INetworkServices {
    func fetchEntityData<T: Codable>(
        url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class NetworkServices: INetworkServices {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

//MARK: - Public functions
extension NetworkServices {
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
    
    private func decodeData<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}
