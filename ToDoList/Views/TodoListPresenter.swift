//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol ITodoListPresenter {
    var numberOfTodos: Int { get }
    func todo(at index: Int) -> TodoItem?
    func loadTodos()
}

protocol ITodoListView: AnyObject {
    func reloadData()
    func showError(_: String)
}

final class TodoListPresenter: ITodoListPresenter {
    private let interactor: ITodoListInteractor
    private weak var view: ITodoListView?
    private var todos: [TodoItem] = []
    
    init(interactor: ITodoListInteractor, view: ITodoListView) {
        self.interactor = interactor
        self.view = view
    }
    
    var numberOfTodos: Int {
        todos.count
    }
    
    func todo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
    
    func loadTodos() {
        interactor.fetchTodos { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.todos = items
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
