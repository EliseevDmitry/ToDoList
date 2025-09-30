//
//  ScreenFactory.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Фабрика экранов, создающая и конфигурирующая ViewController-и с соответствующими презентерами и зависимостями.
/// Централизует построение VIPER-модулей, обеспечивая корректное связывание презентеров с вью и роутером.
final class ScreenFactory {
    private unowned let di: Di
    private var todoListPresenter: ITodoListPresenter
    
    init(
        di: Di
    ) {
        self.di = di
        self.todoListPresenter = TodoListPresenter(
            interactor: di.todoListInteractor,
            view: nil,
            router: di.router
        )
    }
    
    /// Создает и конфигурирует `TasksViewController` с привязанным презентером и роутером.
    /// Обеспечивает корректное связывание View с презентером и назначение корневого контроллера роутеру.
    func makeTasksViewController() -> UIViewController {
        let viewController = TasksViewController(presenter: todoListPresenter)
        todoListPresenter.setView(viewController)
        di.router.setViewController(viewController: viewController)
        return viewController
    }
    
    /// Создает и конфигурирует `TodoDetailViewController` для конкретного ToDo элемента.
    /// Презентер связывается с вью и получает ссылку на общий список презентера для обновления данных.
    func makeTodoDetailViewViewController(todoItem: any IToDo) -> UIViewController {
        let router = di.router
        let presenter = TodoDetailPresenter(
            view: nil,
            router: router,
            todo: todoItem,
            listPresenter: todoListPresenter
        )
        let viewController = TodoDetailViewController(presenter: presenter)
        presenter.setView(viewController)
        return viewController
    }
}
