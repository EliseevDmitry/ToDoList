//
//  Router.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

protocol ITasksRouter: AnyObject {
    func showTodoDetail(todoItem: TodoItem)
}

/// Отвечает за навигацию из TasksViewController
final class TasksRouter: ITasksRouter {
    
    /// Контроллер, от которого выполняется навигация
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func setViewController(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /// Переход на экран редактирования/просмотра ToDo
    /// - Parameter todoItem: элемент задачи, который нужно показать
    func showTodoDetail(todoItem: TodoItem) {
        let detailVC = TodoDetailViewController(entity: todoItem)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// Возврат на предыдущий экран
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
