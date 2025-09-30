//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Протокол, описывающий маршруты и навигацию для экрана списка задач.
protocol ITasksRouter: AnyObject {
    /// Связывает роутер с конкретным UIViewController для управления навигацией
    func setViewController(viewController: UIViewController)
    
    /// Переходит на экран деталей конкретного ToDo элемента
    func showTodoDetail(todoItem: TodoItem)
    
    /// Выполняет возврат на предыдущий экран в навигационном стеке
    func pop()
}

/// Реализация роутера, отвечающего за навигацию из TasksViewController.
/// Управляет переходами между экраном списка задач и экраном деталей.
final class TasksRouter: ITasksRouter {
    
    /// Контроллер, от которого выполняется навигация, хранится weak чтобы избежать retain cycle
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    /// Обновляет ссылку на текущий контроллер для корректной работы навигации
    func setViewController(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /// Создает экран деталей и пушит его в навигационный стек
    func showTodoDetail(todoItem: TodoItem) {
        let detailVC = di.screenFactory.makeTodoDetailViewViewController(todoItem: todoItem)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// Выполняет pop текущего контроллера из навигационного стека
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
