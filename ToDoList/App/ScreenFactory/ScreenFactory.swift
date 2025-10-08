//
//  ScreenFactory.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

final class ScreenFactory {
    unowned var di: Di!
    
    func makeToDoList() -> ITodoListView {
        let interactor = TodoListInteractor(todoRepository: di.todoRepository)
        let presenter = TodoListPresenter(interactor: interactor, router: di.router)
        interactor.output = presenter
        let view = TasksViewController(presenter: presenter)
        presenter.setView(view)
        return view
    }
    
    func makeToDoDetail<T: IToDo>(todo: T, presenterOutput: ITodoDetailOutput) -> ITodoDetailView {
        let presenter = TodoDetailPresenter(router: di.router, todo: todo)
        let view = TodoDetailViewController(presenter: presenter)
        presenter.setView(view)
        presenter.delegate = presenterOutput
        return view
    }
}
