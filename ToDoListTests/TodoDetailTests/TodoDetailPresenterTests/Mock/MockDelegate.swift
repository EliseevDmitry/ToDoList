//
//  MockDelegate.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import Foundation
@testable import ToDoList

/// Mock implementation of ITodoDetailOutput
final class MockDelegate: ITodoDetailOutput {
    var didUpdateItemCalled = false
    var updatedTodo: (any IToDo)?
    
    /// Tracks delegate update calls
    func didUpdateItem<T>(entity: T) where T : IToDo {
        didUpdateItemCalled = true
        updatedTodo = entity
    }
}
