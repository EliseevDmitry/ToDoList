//
//  MockInteractorOutput.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import XCTest
@testable import ToDoList

/// Mock delegate to verify TodoListInteractor callbacks in tests.
final class MockInteractorOutput: ITodoInteractorOutput {
    var expectation: XCTestExpectation?
    var didCallDidFetchTodos = false
    var didCallDidAddTodo = false
    var didCallDidUpdateTodo = false
    var didCallDidDeleteTodo = false
    var didCallDidSearchTodos = false
    var didCallDidFail = false
    var capturedError: Error?

    /// Captures didFetchTodos callback and fulfills expectation.
    func didFetchTodos<T>(_ todos: [T]) {
        didCallDidFetchTodos = true
        expectation?.fulfill()
    }
    
    /// Captures didAddTodo callback and fulfills expectation.
    func didAddTodo<T>(_ todo: T) {
        didCallDidAddTodo = true
        expectation?.fulfill()
    }
    
    /// Captures didUpdateTodo callback and fulfills expectation.
    func didUpdateTodo<T>(_ todo: T) {
        didCallDidUpdateTodo = true
        expectation?.fulfill()
    }
    
    /// Captures didDeleteTodo callback and fulfills expectation.
    func didDeleteTodo(id: UUID) {
        didCallDidDeleteTodo = true
        expectation?.fulfill()
    }
    
    /// Captures didSearchTodos callback and fulfills expectation.
    func didSearchTodos<T>(_ todos: [T]) {
        didCallDidSearchTodos = true
        expectation?.fulfill()
    }
    
    /// Captures didFail callback and fulfills expectation.
    func didFail(with error: Error) {
        didCallDidFail = true
        capturedError = error
        expectation?.fulfill()
    }
}
