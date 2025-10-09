//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

// MARK: - Presenter Protocol

/// Public API of the TodoList presenter.
/// Defines CRUD, search, and navigation actions.
/// Connects View ↔ Presenter in VIPER architecture.
protocol ITodoListPresenter {
    var numberOfTodos: Int { get }
    
    /// View Lifecycle
    func setView(_ view: ITodoListView)
    func todo(at index: Int) -> (any IToDo)?
    func didSelectTodo(at index: Int)
    func didTapAddNewItem()
    
    /// CRUD Operations
    func addNewFixedItem<T: IToDo>(item: T)
    func loadTodos()
    func completedToDo(at index: Int)
    func updateItem<T: IToDo>(entity: T)
    func deleteToDo(at index: Int)
    
    /// Search
    func searchToDoItems(query: String)
}

// MARK: - Presenter Implementation

/// Presenter responsible for handling the business logic of the todo list screen.
/// Coordinates Interactor for data operations and Router for navigation.
/// Updates the UI via View protocol methods and thread-safe dispatching.
final class TodoListPresenter  {
    
    // MARK: - Dependencies
    
    private let interactor: ITodoInteractor
    private weak var view: ITodoListView?
    private let router: ITasksRouter
    
    // MARK: - State
    
    private var todos: [any IToDo] = []
    
    /// Current number of todos for UI data source.
    var numberOfTodos: Int {
        todos.count
    }
    
    // MARK: - Init
    
    /// Initializes the presenter with dependencies.
    /// - Parameters:
    ///   - interactor: Interactor for fetching and modifying todo items.
    ///   - view: Optional view to bind immediately.
    ///   - router: Router for navigation.
    init(
        interactor: ITodoInteractor,
        view: ITodoListView? = nil,
        router: ITasksRouter
    ) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    /// Binds the view to the presenter.
    func setView(_ view: ITodoListView) {
        self.view = view
    }
    
    /// Returns a todo at the specified index.
    func todo(at index: Int) -> (any IToDo)? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
    
    /// Handles user selection of a todo item.
    /// Delegates navigation to Router via screen factory.
    func didSelectTodo(at index: Int) {
        guard let todo = todo(at: index) else { return }
        let destination = di.screenFactory.makeToDoDetail(
            todo: todo,
            presenterOutput: self
        )
        router.showTodoDetail(
            from: self.view,
            destination: destination
        )
    }
    
    /// Handles adding a new fixed todo item.
    /// Clears search and refreshes UI after insertion.
    func didTapAddNewItem() {
        view?.clearSearch()
        searchToDoItems(query: "")
        addNewFixedItem(item: TasksViewController.Consts.newFixedToDoItem())
    }
    
    /// Adds a new todo item asynchronously via interactor.
    func addNewFixedItem<T: IToDo>(item: T) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.addItem(item)
        }
    }
    
    /// Fetches all todos asynchronously.
    func loadTodos() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.fetchItems()
        }
    }
    
    /// Marks a todo as completed.
    func completedToDo(at index: Int) {
        guard var entity = todo(at: index) else { return }
        entity.updateCompleted()
        updateItem(entity: entity)
    }
    
    /// Updates a todo item via interactor.
    func updateItem<T: IToDo>(entity: T) {
        interactor.updateItem(entity)
    }
    
    /// Deletes a todo item via interactor asynchronously.
    func deleteToDo(at index: Int) {
        guard let entity = todo(at: index) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.deleteItem(id: entity.id)
        }
    }
    
    /// Performs search on todos.
    /// If query is empty, fetches all items.
    func searchToDoItems(query: String) {
        guard !query.isEmpty else {
            interactor.fetchItems()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.searchItems(query: query)
        }
    }
}

// MARK: - ITodoInteractorOutput

extension TodoListPresenter: ITodoInteractorOutput {
    /// Handles newly added todo and refreshes the UI.
    func didAddTodo<T: IToDo>(_ todo: T) {
        self.todos.insert(todo, at: 0)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    /// Updates existing todo in the list and refreshes the UI.
    func didUpdateTodo<T: IToDo>(_ todo: T) {
        guard let index = self.todos.firstIndex(where: { $0.id == todo.id }) else { return }
        self.todos[index] = todo
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    /// Receives fetched todos, sorts them, and updates the UI.
    func didFetchTodos<T: IToDo>(_ todos: [T]) {
        self.todos.removeAll()
        self.todos = sortTodos(todos)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    /// Removes a deleted todo from the list and updates the UI.
    func didDeleteTodo(id: UUID) {
        guard let index = todos.firstIndex(where: { $0.id == id }) else { return }
        self.todos.remove(at: index)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    /// Handles errors from the interactor by showing an alert.
    func didFail(with error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    /// Handles search results, sorts them, and updates the UI.
    func didSearchTodos<T: IToDo>(_ todos: [T]) {
        self.todos.removeAll()
        self.todos = self.sortTodos(todos)
        DispatchQueue.main.async {
            self.update()
        }
    }
}

// MARK: - ITodoDetailOutput

extension TodoListPresenter: ITodoDetailOutput {
    /// Receives updated todo from detail view and forwards it to the interactor.
    func didUpdateItem<T: IToDo>(entity: T) {
        self.updateItem(entity: entity)
    }
}

// MARK: - Private Helpers

extension TodoListPresenter {
    /// Updates the UI after any change in the todo list.
    /// Reloads the table and refreshes the footer count.
    private func update(){
        self.view?.reloadData()
        self.view?.updateFooterCount(self.todos.count)
    }
    
    /// Sorts todos by date, newest first.
    private func sortTodos<T: IToDo>(_ items: [T]) -> [T] {
        items.sorted { $0.date > $1.date }
    }
}
