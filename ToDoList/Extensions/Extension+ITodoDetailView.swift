//
//  Extension+ITodoDetailView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import Foundation

/// Provides a default empty implementation for the `ITodoDetailView` method.
///
/// This extension simplifies unit testing by allowing mocks or other
/// classes to conform to `ITodoDetailView` without implementing
/// the `display(todo:)` method.
extension ITodoDetailView {
    func display<T: IToDo>(todo: T) { }
}
