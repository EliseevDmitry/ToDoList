//
//  NetworkServices.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Возможные ошибки сетевого слоя.
/// Расширяемый для обработки ошибок и отображения пользователю.
enum NetworkError: Error {
    case badData
}

/// Протокол сетевого сервиса.
/// Предоставляет метод для загрузки и декодирования данных в указанную модель.
protocol INetworkServices {
    /// Загружает данные с API и декодирует их в указанный `Codable` тип.
    /// - Parameters:
    ///   - url: URL запроса.
    ///   - type: Тип модели для декодирования.
    ///   - completion: Результат запроса (`success` с моделью / `failure` с ошибкой).
    func fetchEntityData<T: Codable>(
        url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

/// Реализация сетевого сервиса с использованием `URLSession`.
/// Все сетевые запросы выполняются в фоновом потоке через GCD.
final class NetworkServices: INetworkServices {
    private let session: URLSessionProtocol
    
    /// Инициализация сервиса с возможностью внедрения кастомного `URLSession` (для тестирования).
    /// - Parameter session: URLSession или его протокольная обертка.
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

//MARK: - Public functions
extension NetworkServices {
    /// Загружает данные с API и декодирует их в указанную модель.
    /// Универсальный метод для любых моделей, соответствующих `Codable`.
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
    /// Выполняет низкоуровневый сетевой запрос и возвращает `Data`.
    /// Используется для переиспользования в любых универсальных методах декодирования.
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
    
    /// Декодирует `Data` в указанную модель `Codable`.
    /// - Parameters:
    ///   - data: Данные для декодирования.
    ///   - type: Тип модели.
    /// - Returns: Декодированная модель.
    /// - Throws: Ошибку декодирования.
    private func decodeData<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}
