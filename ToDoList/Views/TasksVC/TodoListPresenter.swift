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
    func searchToDoItems(query: String)
    func addNewFixedItem(item: TodoItem)
}

protocol ITodoListView: AnyObject {
    func reloadData()
    func showError(_: String)
}

final class TodoListPresenter: ITodoListPresenter {
    
    private let interactor: ITodoListInteractor
    private weak var view: ITodoListView?
    private var todos: [TodoItem] = []
    
    init(interactor: ITodoListInteractor, view: ITodoListView? = nil) {
            self.interactor = interactor
            self.view = view
        }
        
        func setView(_ view: ITodoListView) {
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
            self.interactor.fetchItems { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    self.todos.removeAll()
                    self.todos = items.sorted { $0.date > $1.date }
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
                case .success(_):
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
                case .success(_):
                    self.todos[index] = entity
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func searchToDoItems(query: String) {
        guard !query.isEmpty else {
            loadTodos()
            return
        }
        
        interactor.searchItems(query: query) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.todos.removeAll()
                    self.todos = items.sorted { $0.date > $1.date }
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func addNewFixedItem(item: TodoItem) {
        interactor.addItem(item: item) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.todos.insert(item, at: 0)
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
}
