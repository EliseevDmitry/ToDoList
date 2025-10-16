//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

/// Interactor interface for Todo list use cases.
protocol ITodoInteractor: AnyObject {
    func fetchItems()
    func addItem<T: IToDo>(_ item: T)
    func updateItem<T: IToDo>(_ item: T)
    func deleteItem(id: UUID)
    func searchItems(query: String)
}

/// Delegate interface for interactor output events.
protocol ITodoInteractorOutput: AnyObject {
    func didFetchTodos<T: IToDo>(_ todos: [T])
    func didAddTodo<T: IToDo>(_ todo: T)
    func didUpdateTodo<T: IToDo>(_ todo: T)
    func didDeleteTodo(id: UUID)
    func didSearchTodos<T: IToDo>(_ todos: [T])
    func didFail(with error: Error)
}

/// Interactor handling business logic for Todo list and communicating with repository.
final class TodoListInteractor {
    private let todoRepository: ITodoRepository
    weak var delegate: ITodoInteractorOutput?
    
    // MARK: - Init
    
    init(todoRepository: ITodoRepository) {
        self.todoRepository = todoRepository
    }
}

extension TodoListInteractor: ITodoInteractor {
    /// Fetches all Todo items from repository and forwards results to delegate.
    func fetchItems() {
        todoRepository.getToDos { [weak self] (result: Result<[TodoItem], Error>) in
            self?.handleResult(result) { todos in
                self?.delegate?.didFetchTodos(todos)
            }
        }
    }
    
    /// Adds a new Todo item and notifies delegate on success.
    func addItem<T: IToDo>(_ item: T) {
        todoRepository.addToDo(item: item) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.delegate?.didAddTodo(item)
            }
        }
    }
    
    /// Updates an existing Todo item and notifies delegate on success.
    func updateItem<T: IToDo>(_ item: T) {
        todoRepository.updateToDo(item: item) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.delegate?.didUpdateTodo(item)
            }
        }
    }
    
    /// Deletes a Todo item by id and notifies delegate on success.
    func deleteItem(id: UUID) {
        todoRepository.deleteToDo(id: id) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.delegate?.didDeleteTodo(id: id)
            }
        }
    }
    
    /// Searches Todo items matching query and notifies delegate.
    func searchItems(query: String) {
        todoRepository.searchTodos(query: query) { [weak self] (result: Result<[TodoItem], Error>) in
            self?.handleResult(result) { todos in
                self?.delegate?.didSearchTodos(todos)
            }
        }
    }
}

// MARK: - Private functions

extension TodoListInteractor {
    /// Handles repository result and forwards success or failure to delegate.
    private func handleResult<T>(
        _ result: Result<T, Error>,
        onSuccess: (T) -> Void
    ) {
        switch result {
        case .success(let value): onSuccess(value)
        case .failure(let error): delegate?.didFail(with: error)
        }
    }
}
