//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol ITodoListInteractor {
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
}

final class TodoListInteractor: ITodoListInteractor {
    private let todoRepository: ITodoRepository
    
    init(todoRepository: ITodoRepository = TodoRepository()) {
        self.todoRepository = todoRepository
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        todoRepository.getToDos { result in
            switch result {
            case .success(let todos):
                completion(.success(todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
