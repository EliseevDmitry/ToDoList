//
//  TodoRepository.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation
import CoreData

/// Протокол репозитория для работы с задачами.
/// Определяет CRUD и поиск, выступает абстракцией над сетевым, локальным и настройками приложений.
protocol ITodoRepository {
    // MARK: - CRUD
    /// Добавляет задачу в хранилище.
    func addToDo(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Получает все задачи с учётом первого запуска приложения.
    func getToDos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    /// Обновляет существующую задачу.
    func updateToDO(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Удаляет задачу по идентификатору.
    func deleteToDO(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void)
    
    // MARK: - Search
    /// Выполняет поиск задач по строке запроса.
    func searchTodos(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
}

/// Репозиторий задач.
/// Промежуточный слой между Interactor и сервисами (сеть, CoreData, настройки).
/// Позволяет легко расширять архитектуру и управлять источниками данных.
final class TodoRepository: ITodoRepository {
    
    enum Consts {
        static let persistentContainer = "Todo"
    }
    
    private let network: INetworkServices
    private let storage: IStorageService
    private let settings: ISettingsService
    
    /// Инициализация репозитория с возможностью внедрения кастомных сервисов для тестирования.
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
    /// Добавление задачи через локальное хранилище.
    func addToDo(item: any IToDo, completion: @escaping (Result<Bool, any Error>) -> Void) {
        storage.addTodo(item: item, completion: completion)
    }
    
    /// Получение задач с проверкой первого запуска.
    /// Первый запуск — данные загружаются из сети и сохраняются в CoreData.
    /// Последующие запуски — данные берутся из локального хранилища.
    func getToDos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        if !settings.isFirstLaunch() {
            fetchFromNetwork(completion: completion)
        } else {
            fetchFromStorage(completion: completion)
        }
    }
    
    /// Обновление задачи в CoreData.
    func updateToDO(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void) {
        storage.updateTodo(item: item, completion: completion)
    }
    
    /// Удаление задачи по идентификатору из CoreData.
    func deleteToDO(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        storage.deleteTodo(id: id, completion: completion)
    }
    
    /// Поиск задач через локальное хранилище.
    func searchTodos(query: String, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        storage.searchTodos(TodoItem.self, query: query, completion: completion)
    }
}

// MARK: - Private functions
private extension TodoRepository {
    /// Получение данных с API, сохранение в CoreData и возврат результата.
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
    
    /// Получение задач из локального хранилища CoreData.
    func fetchFromStorage(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        storage.getToDos(
            TodoItem.self,
            completion: completion
        )
    }
}
