//
//  MockRouter.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

@testable import ToDoList

/// Mock implementation of ITasksRouter
final class MockRouter: ITasksRouter {
    var didCallShowDetail = false
    var didCallPop = false
    
    /// Tracks navigation to todo detail
    func showTodoDetail(from source: (any ToDoList.ITodoListView)?, destination: any ToDoList.ITodoDetailView) {
        didCallShowDetail = true
    }
    
    /// Tracks pop action
    func pop(from source: (any ToDoList.ITodoDetailView)?) {
        didCallPop = true
    }
}
