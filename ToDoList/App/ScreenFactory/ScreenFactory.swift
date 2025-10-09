//
//  ScreenFactory.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Factory for building view controllers with their presenter, interactor, and router wired.
final class ScreenFactory {
    /// Reference to the DI container.
    unowned var di: Di!
    
    /// Builds the Todo list module.
    func makeToDoList() -> ITodoListView {
        let interactor = TodoListInteractor(todoRepository: di.todoRepository)
        let presenter = TodoListPresenter(interactor: interactor, router: di.router)
        interactor.delegate = presenter
        let view = TasksViewController(presenter: presenter)
        presenter.setView(view)
        return view
    }
    
    /// Builds the Todo detail module for a specific todo item.
    func makeToDoDetail<T: IToDo>(todo: T, presenterOutput: ITodoDetailOutput) -> ITodoDetailView {
        let presenter = TodoDetailPresenter(router: di.router, todo: todo)
        let view = TodoDetailViewController(presenter: presenter)
        presenter.setView(view)
        presenter.delegate = presenterOutput
        return view
    }
}
