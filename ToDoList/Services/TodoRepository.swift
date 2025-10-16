//
//  TodoRepository.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation
import CoreData

/// Protocol for managing Todo tasks.
/// Defines basic CRUD operations and search, serving as an abstraction
/// over network, CoreData, and app settings.
protocol ITodoRepository {
    
    // MARK: - CRUD
    
    /// Adds a task to local storage.
    func addToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Retrieves all Todo tasks of type `T`. Fetches from network on first launch, otherwise loads from local storage.
    func getToDos<T: IToDo>(completion: @escaping (Result<[T], Error>) -> Void)
    
    /// Updates an existing task.
    func updateToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Deletes a task by its identifier.
    func deleteToDo(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void)
    
    // MARK: - Search
    
    /// Searches tasks by a query string.
    func searchTodos<T: IToDo>(query: String, completion: @escaping (Result<[T], Error>) -> Void)
}

/// Repository for managing Todo tasks.
/// Acts as an intermediate layer between the Interactor and underlying services
/// such as network, CoreData, and application settings.
/// Facilitates easy extension of architecture and centralized data management.
final class TodoRepository: ITodoRepository {
    
    enum Consts {
        static let persistentContainer = "Todo"
    }
    
    private let network: INetworkServices
    private let storage: IStorageService
    private let settings: ISettingsService
    
    /// Initializes the repository with optional custom services.
    /// Useful for dependency injection and testing.
    ///
    /// - Parameters:
    ///   - network: Service responsible for network requests.
    ///   - storage: Service responsible for local persistence (CoreData).
    ///   - settings: Service providing app configuration and state.
    init(
        network: INetworkServices = NetworkServices(),
        storage: IStorageService = StorageService(
            container: NSPersistentContainer(name: Consts.persistentContainer)
        ),
        settings: ISettingsService = SettingsService()
    ) {
        self.network = network
        self.storage = storage
        self.settings = settings
    }
}

// MARK: - Public functions
extension TodoRepository {
    /// Adds a new task to the local storage.
    ///
    /// This method contains no business logic. It simply forwards the call
    /// to `StorageService.addTodo`. The repository does not make any
    /// decisions or transform the data, so unit tests for this method
    /// are not required.
    func addToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, any Error>) -> Void) {
        storage.addTodo(item: item, completion: completion)
    }
    
    /// Retrieves tasks considering the app's first launch.
    ///
    /// On the first launch, tasks are fetched from the network and saved to CoreData.
    /// On subsequent launches, tasks are retrieved from local storage.
    func getToDos<T: IToDo>(completion: @escaping (Result<[T], Error>) -> Void) {
        if !settings.isFirstLaunch() {
            fetchFromNetwork(T.self, completion: completion)
        } else {
            fetchFromStorage(completion: completion)
        }
    }
    
    /// Updates an existing task in CoreData.
    ///
    /// This method does not contain any business logic. It simply forwards
    /// the call to `StorageService.updateTodo`. The repository does not
    /// make any decisions or transform the data, so unit tests for this
    /// method are not necessary.
    func updateToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        storage.updateTodo(item: item, completion: completion)
    }
    
    /// Deletes a task from CoreData by its identifier.
    ///
    /// This method delegates the deletion to `StorageService` without
    /// adding any additional logic. Since it does not contain business
    /// rules, separate unit testing is not required.
    func deleteToDo(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        storage.deleteTodo(id: id, completion: completion)
    }
    
    /// Searches for tasks in the local storage that conform to `IToDo`.
    ///
    /// This method directly delegates the search query to `StorageService`.
    /// Because the repository does not modify the behavior or apply any
    /// business rules, unit testing this method is redundant.
    func searchTodos<T: IToDo>(query: String, completion: @escaping (Result<[T], any Error>) -> Void) {
        storage.searchTodos(T.self, query: query, completion: completion)
    }
}

// MARK: - Private functions

private extension TodoRepository {
    /// Fetches tasks of a generic type `T` from the network, persists them
    /// to CoreData, and returns the resulting list.
    ///
    /// This method integrates the network and local storage layers. It first
    /// fetches the data from the API, then saves it via `StorageService`, and
    /// finally returns the parsed domain models of type `T` to the caller.
    ///
    /// Any network or persistence errors are propagated through the completion handler.
    func fetchFromNetwork<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        network.fetchEntityData(
            url: Constants.todosURL,
            type: TodosResponse<T>.self
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
    
    /// Retrieves tasks of a generic type `T` from local CoreData storage.
    ///
    /// This method wraps the call to `StorageService.getToDos` and is used
    /// for offline operation after the app's first successful launch,
    /// when data has already been fetched from the network. Returns all
    /// locally persisted entities of type `T` or an error if fetching fails.
    func fetchFromStorage<T: IToDo>(completion: @escaping (Result<[T], Error>) -> Void) {
        storage.getToDos(
            T.self,
            completion: completion
        )
    }
}
