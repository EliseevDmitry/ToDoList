//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Router for `ToDoList App` navigation.
protocol ITasksRouter: AnyObject {
    /// Navigate from the `TodoListView` to the `TodoDetailView`.
    func showTodoDetail(from source: ITodoListView?, destination: ITodoDetailView)
    /// Pop the current `TodoDetailView` from the navigation stack.
    func pop(from source: ITodoDetailView?)
}

/// Handles navigation between `ToDoList App` screens.
final class TasksRouter: ITasksRouter {
    func showTodoDetail(from source: ITodoListView?, destination: ITodoDetailView) {
        guard let sourceVC = source as? UIViewController,
              let destinationVC = destination as? UIViewController
        else { return }
        sourceVC.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func pop(from source: ITodoDetailView?) {
        guard let sourceVC = source as? UIViewController else { return }
        sourceVC.navigationController?.popViewController(animated: true)
    }
}
