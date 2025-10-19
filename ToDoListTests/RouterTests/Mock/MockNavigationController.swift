//
//  MockNavigationController.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 19.10.2025.
//

import UIKit
@testable import ToDoList

final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var didPopViewController = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: false)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return super.popViewController(animated: false)
    }
}

//вопрос про moc - ну уровне протоколов
final class MockTodoListView: UIViewController, ITodoListView { }
final class MockTodoDetailView: UIViewController, ITodoDetailView { }
