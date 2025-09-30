//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

/// Интерфейс для взаимодействия слоя Interactor с внешними источниками данных (репозиториями).
/// Определяет базовые операции CRUD и поиск для задач приложения.
protocol ITodoListInteractor {
    func addItem(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchItems(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func updateItem(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteItem(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void)
    func searchItems(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
}

/// Реализация `ITodoListInteractor`, инкапсулирующая бизнес-логику работы с задачами.
/// Делегирует все операции конкретному репозиторию `ITodoRepository`.
final class TodoListInteractor: ITodoListInteractor {
    private let todoRepository: ITodoRepository
    
    init(todoRepository: ITodoRepository = TodoRepository()) {
        self.todoRepository = todoRepository
    }
    
    func addItem(item: any IToDo, completion: @escaping (Result<Bool, any Error>) -> Void) {
        todoRepository.addToDo(item: item, completion: completion)
    }
    
    func fetchItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        todoRepository.getToDos(completion: completion)
    }
    
    func deleteItem(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        todoRepository.deleteToDO(id: id, completion: completion)
    }
    
    func updateItem(item: any IToDo, completion: @escaping (Result<Bool, Error>) -> Void) {
        todoRepository.updateToDO(item: item, completion: completion)
    }
    
    func searchItems(query: String, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        todoRepository.searchTodos(query: query, completion: completion)
    }
}
