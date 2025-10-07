//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Протокол, описывающий маршруты и навигацию для экрана списка задач.
protocol ITasksRouter: AnyObject {

    /// Переходит на экран деталей конкретного ToDo элемента
    func showTodoDetail(viewController: UIViewController?, todoItem: TodoItem)
    
    /// Выполняет возврат на предыдущий экран в навигационном стеке
    func pop(viewController: UIViewController?)
}

/// Реализация роутера, отвечающего за навигацию из TasksViewController.
/// Управляет переходами между экраном списка задач и экраном деталей.
final class TasksRouter: ITasksRouter {
    
    /// Создает экран деталей и пушит его в навигационный стек
    func showTodoDetail(viewController: UIViewController?, todoItem: TodoItem) {
        let detailVC = di.screenFactory.makeTodoDetailViewViewController(todoItem: todoItem)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// Выполняет pop текущего контроллера из навигационного стека
    func pop(viewController: UIViewController?) {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
