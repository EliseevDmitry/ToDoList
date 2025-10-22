//
//  RouterTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 19.10.2025.
//

import XCTest
@testable import ToDoList

/// Unit tests for `TasksRouter`.
/// Verifies correct push/pop behavior when navigating between TodoList and TodoDetail screens.
final class RouterTests: XCTestCase {
    
    enum Consts {
        static let initialViewControllerCount = 1
        static let allViewControllersInStack = 2
    }
    
    private var router: TasksRouter!
    private var navigationController: MockNavigationController!
    private var sourceVC: MockTodoListView!
    private var destinationVC: MockTodoDetailView!
    
    override func setUp() {
        super.setUp()
        router = TasksRouter()
        sourceVC = MockTodoListView()
        destinationVC = MockTodoDetailView()
        navigationController = MockNavigationController(rootViewController: sourceVC)
    }
    
    override func tearDown() {
        navigationController = nil
        router = nil
        sourceVC = nil
        destinationVC = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests that calling `showTodoDetail` pushes the destination view controller onto the navigation stack.
    func testShowTodoDetail_PushesDestinationVC() {
        // Given
        XCTAssertEqual(
            navigationController.viewControllers.count,
            Consts.initialViewControllerCount
        )
        // When
        router.showTodoDetail(
            from: sourceVC,
            destination: destinationVC
        )
        // Then
        XCTAssertEqual(
            navigationController.pushedViewController,
            destinationVC
        )
        XCTAssertEqual(
            navigationController.viewControllers.count,
            Consts.allViewControllersInStack
        )
    }
    
    /// Tests that calling `pop` removes the top view controller from the navigation stack.
    func testPop_PopsViewController() {
        // Given
        router.showTodoDetail(
            from: sourceVC,
            destination: destinationVC
        )
        XCTAssertEqual(
            navigationController.viewControllers.count,
            Consts.allViewControllersInStack
        )
        // When
        router.pop(from: destinationVC)
        // Then
        XCTAssertTrue(navigationController.didPopViewController)
        XCTAssertEqual(
            navigationController.viewControllers.count,
            Consts.initialViewControllerCount
        )
    }
}
