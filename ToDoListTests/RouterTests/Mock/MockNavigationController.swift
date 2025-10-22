//
//  MockNavigationController.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 19.10.2025.
//

import UIKit
@testable import ToDoList

/// Mock navigation controller used to capture push/pop actions in routing tests.
/// Overrides push/pop methods to track calls without animation.
final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var didPopViewController = false
    
    /// Overrides pushViewController to store the pushed view controller and disable animation.
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: false)
    }
    
    /// Overrides popViewController to mark pop action and disable animation.
    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return super.popViewController(animated: false)
    }
}
