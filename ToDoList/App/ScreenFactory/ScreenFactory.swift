//
//  ScreenFactory.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

final class ScreenFactory {
    private unowned let di: Di
    
    init(di: Di) {
        self.di = di
    }
    
    func makeTasksViewController() -> UIViewController {
        let interactor = di.todoListInteractor
        let router = TasksRouter(viewController: nil)
        let presenter = TodoListPresenter(interactor: interactor, view: nil, router: router)
        let viewController = TasksViewController(presenter: presenter)
        presenter.setView(viewController)
        router.setViewController(viewController: viewController)
        return viewController
    }
}
