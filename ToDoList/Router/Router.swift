//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

protocol ITasksRouter: AnyObject {
    func showTodoDetail(from source: ITodoListView?, destination: ITodoDetailView)
    func pop(from source: ITodoDetailView?)
}

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
