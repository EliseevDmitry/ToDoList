//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol TodoListInteractorProtocol {
    func fetchTodos() -> [TodoItemLocal]
}

final class TodoListInteractor: TodoListInteractorProtocol {
    func fetchTodos() -> [TodoItemLocal] {
        return Moc.data
    }
}
