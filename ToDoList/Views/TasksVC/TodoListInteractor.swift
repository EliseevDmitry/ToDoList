//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol ITodoListInteractor {
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func deleteItem(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func updateItem(item: any IToDo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodoListInteractor: ITodoListInteractor {
    
    private let todoRepository: ITodoRepository
    
    init(todoRepository: ITodoRepository = TodoRepository()) {
        self.todoRepository = todoRepository
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        todoRepository.getToDos(completion: completion)
    }
    
    func deleteItem(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        todoRepository.deleteToDO(id: id, completion: completion)
    }
    
    func updateItem(item: any IToDo, completion: @escaping (Result<Void, Error>) -> Void) {
        todoRepository.updateToDO(item: item, completion: completion)
    }
}
