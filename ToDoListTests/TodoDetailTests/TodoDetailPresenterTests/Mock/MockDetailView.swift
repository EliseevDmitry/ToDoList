//
//  MockDetailView.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import Foundation
@testable import ToDoList

/// Mock implementation of ITodoDetailView
final class MockDetailView: ITodoDetailView {
    var displayedTodo: (any IToDo)?
    
    /// Saves the displayed Todo item
    func display<T: IToDo>(todo: T) {
        displayedTodo = todo
    }
}

