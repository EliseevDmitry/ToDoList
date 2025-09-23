//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol TodoListPresenterProtocol {
    var numberOfTodos: Int { get }
    func todo(at index: Int) -> TodoItemLocal?
    func loadTodos()
}

protocol TodoListViewProtocol: AnyObject {
    func reloadData()
}

final class TodoListPresenter: TodoListPresenterProtocol {
    private let interactor: TodoListInteractorProtocol
    private weak var view: TodoListViewProtocol?
    private var todos: [TodoItemLocal] = []
    
    init(interactor: TodoListInteractorProtocol, view: TodoListViewProtocol) {
        self.interactor = interactor
        self.view = view
    }
    
    var numberOfTodos: Int {
        todos.count
    }
    
    func todo(at index: Int) -> TodoItemLocal? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
    
    func loadTodos() {
        todos = interactor.fetchTodos()
        view?.reloadData()
    }
}
