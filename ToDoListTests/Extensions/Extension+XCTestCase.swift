//
//  Extension+.swift.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 17.10.2025.
//

import XCTest
@testable import ToDoList

extension XCTestCase {
    /// Reports a failed Core Data operation with a detailed error message.
    func fail(error: Error, expectation: XCTestExpectation) {
        XCTFail("Add Todo failed: \(error.localizedDescription)")
        expectation.fulfill()
    }
    
    /// Asserts that two arrays of `IToDo`-conforming items contain identical sets of IDs.
    func assertTodosEqual(_ fetched: [MockToDo], _ expected: [MockToDo], expectation: XCTestExpectation) {
        let fetchedIDs = Set(fetched.map { $0.id })
        let expectedIDs = Set(expected.map { $0.id })
        XCTAssertEqual(fetchedIDs, expectedIDs)
        expectation.fulfill()
    }
    
    /// Returns a mock `TodoItem` instance for use in unit tests.
    /// Provides consistent test data to avoid duplication.
    var mockTodoItem: TodoItem {
        TodoItem(
            id: UUID(),
            todo: "Test",
            content: "Content",
            completed: false,
            date: .now
        )
    }
    
    /// Returns a mock object conforming to `IToDo` protocol for testing presenter or router logic.
    /// Used when a lightweight mock entity is needed instead of a full `TodoItem`.
    var mockTodo: MockToDo {
        MockToDo(
            id: UUID(),
            todo: "Mock",
            content: "Mock description",
            completed: false,
            date: .now
        )
    }
}
