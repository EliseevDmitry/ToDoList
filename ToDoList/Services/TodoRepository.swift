//
//  TodoRepository.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation
import CoreData

protocol ITodoRepository {
    func getToDos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func deleteToDO(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func updateToDO(item: any IToDo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodoRepository: ITodoRepository {
    private let network: INetworkServices
    private let storage: IStorageService
    private let settings: ISettingsService
    
    init(
        network: INetworkServices = NetworkServices(),
        storage: IStorageService = StorageService(container: NSPersistentContainer(name: "Todo")),
        settings: ISettingsService = SettingsService()
    ) {
        self.network = network
        self.storage = storage
        self.settings = settings
    }
}

// MARK: - Public functions
extension TodoRepository {
    func getToDos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        if !settings.isFirstLaunch() {
            fetchFromNetwork(completion: completion)
        } else {
            fetchFromStorage(completion: completion)
        }
    }
    
    func deleteToDO(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.deleteTodo(id: id) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func updateToDO(item: any IToDo, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.updateTodo(item: item) { result in
            switch result {
            case .success(let success):
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

// MARK: - Private functions
private extension TodoRepository {
    func fetchFromNetwork(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        network.fetchEntityData(
            url: Constants.todosURL,
            type: TodosResponse.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.storage.addTodos(items: response.todos) { storageResult in
                    completion(storageResult.map { _ in response.todos })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFromStorage(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        storage.getToDos(
            TodoItem.self,
            completion: completion
        )
    }
}
