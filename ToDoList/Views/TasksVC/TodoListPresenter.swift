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
    func deleteToDo(at index: Int)
    func completedToDo(at index: Int)
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.fetchTodos { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    self.todos = items
                    DispatchQueue.main.async { self.view?.reloadData() }
                case .failure(let error):
                    DispatchQueue.main.async { self.view?.showError(error.localizedDescription) }
                }
            }
        }
    }
    
    func deleteToDo(at index: Int) {
        guard let entity = todo(at: index) else { return }
        interactor.deleteItem(id: entity.id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.todos.remove(at: index)
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func completedToDo(at index: Int) {
        guard var entity = todo(at: index) else { return }
        entity.updateCompleted()
        interactor.updateItem(item: entity) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.todos[index] = entity
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    
    }
}
