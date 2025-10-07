//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol ITodoInteractor: AnyObject {
    func fetchItems()
    func addItem<T: IToDo>(_ item: T)
    func updateItem<T: IToDo>(_ item: T)
    func deleteItem(id: UUID)
    func searchItems(query: String)
}

protocol ITodoInteractorOutput: AnyObject {
    func didFetchTodos<T: IToDo>(_ todos: [T])
    func didAddTodo<T: IToDo>(_ todo: T)
    func didUpdateTodo<T: IToDo>(_ todo: T)
    func didDeleteTodo(id: UUID)
    func didSearchTodos<T: IToDo>(_ todos: [T])
    func didFail(with error: Error)
}

final class TodoListInteractor {
    private let todoRepository: ITodoRepository
    weak var output: ITodoInteractorOutput?
    
    init(todoRepository: ITodoRepository = TodoRepository()) {
        self.todoRepository = todoRepository
    }
}

extension TodoListInteractor: ITodoInteractor {
    func fetchItems() {
        todoRepository.getToDos { [weak self] result in
            self?.handleResult(result) { todos in
                self?.output?.didFetchTodos(todos)
            }
        }
    }
    
    func addItem<T: IToDo>(_ item: T) {
        todoRepository.addToDo(item: item) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.output?.didAddTodo(item)
            }
        }
    }
    
    func updateItem<T: IToDo>(_ item: T) {
        todoRepository.updateToDO(item: item) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.output?.didUpdateTodo(item)
            }
        }
    }
    
    func deleteItem(id: UUID) {
        todoRepository.deleteToDO(id: id) { [weak self] result in
            self?.handleResult(result) { _ in
                self?.output?.didDeleteTodo(id: id)
            }
        }
    }
    
    func searchItems(query: String) {
        todoRepository.searchTodos(query: query) { [weak self] result in
            self?.handleResult(result) { todos in
                self?.output?.didSearchTodos(todos)
            }
        }
    }
}

extension TodoListInteractor {
    private func handleResult<T>(
        _ result: Result<T, Error>,
        onSuccess: (T) -> Void
    ) {
        switch result {
        case .success(let value): onSuccess(value)
        case .failure(let error): output?.didFail(with: error)
        }
    }
}
