//
//  MockDetailView.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import Foundation
@testable import ToDoList

final class MockDetailView: ITodoDetailView {
    var displayedTodo: (any IToDo)?
    func display<T: IToDo>(todo: T) {
        displayedTodo = todo
    }
}

final class MockDelegate: ITodoDetailOutput {
    var didUpdateItemCalled = false
    var updatedTodo: (any IToDo)?
    func didUpdateItem<T>(entity: T) where T : IToDo {
        didUpdateItemCalled = true
        updatedTodo = entity
    }
}
