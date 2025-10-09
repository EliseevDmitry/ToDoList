//
//  TodoDetailPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Presenter interface for Todo detail screen.
protocol ITodoDetailPresenter {
    func viewDidLoad()
    func updateItem(title: String, content: String)
    func didTapBack()
}

/// Delegate protocol for notifying updates from Presenter.
protocol ITodoDetailOutput: AnyObject {
    func didUpdateItem<T: IToDo>(entity: T)
}

/// Presenter for Todo detail screen handling business logic and routing.
final class TodoDetailPresenter  {
    private weak var view: ITodoDetailView?
    weak var delegate: ITodoDetailOutput?
    private let router: ITasksRouter
    private var todo: (any IToDo)
    
    // MARK: - Init
    
    init(
        view: ITodoDetailView? = nil,
        router: ITasksRouter,
        todo: any IToDo
    ) {
        self.view = view
        self.router = router
        self.todo = todo
    }
}

// MARK: - Public functions

extension TodoDetailPresenter {
    /// Sets the view for the presenter.
    func setView(_ view: ITodoDetailView) {
        self.view = view
    }
}

// MARK: - ITodoDetailPresenter functions

extension TodoDetailPresenter: ITodoDetailPresenter {
    /// /// Called when view loads, displays the current Todo item.
    func viewDidLoad() {
        view?.display(todo: todo)
    }
    
    /// Updates the Todo item if not completed and notifies delegate.
    func updateItem(title: String, content: String) {
        guard var todoEntity = todo as? TodoItem,
              !todoEntity.completed
        else { return }
        todoEntity.updateTodoAndContent(
            todo: title,
            content: content
        )
        delegate?.didUpdateItem(entity: todoEntity)
    }
    
    /// Handles back navigation using the router.
    func didTapBack() {
        router.pop(from: self.view)
    }
}
