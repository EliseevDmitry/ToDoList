//
//  MockStorageService.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 23.10.2025.
//

import Foundation
@testable import ToDoList

/// Mock implementation of `IStorageService`.
/// Simulates Core Data operations for isolated repository testing.
final class MockStorageService: IStorageService {
    var addTodosCalled = false
    var getTodosCalled = false
    var shouldFail = false
    var mockTodos: [MockToDo] = [
        MockToDo(
            id: UUID(),
            todo: "Test ToDo_1",
            content: "Test Description_1",
            completed: false,
            date: .now
        ),
        MockToDo(
            id: UUID(),
            todo: "Test ToDo_2",
            content: "Test Description_2",
            completed: false,
            date: .now
        )
    ]
    
    /// Simulates adding multiple todos to storage.
    /// Can return success or a simulated write error.
    func addTodos<T: IToDo>(
        items: [T],
        completion: @escaping (Result<Bool, Error>) -> Void
    ){
        addTodosCalled = true
        shouldFail ? completion(.failure(MockNSError.storageWrite)) : completion(.success(true))
    }
    
    /// Simulates reading todos from storage.
    /// Returns mock data or a simulated read error.
    func getToDos<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        getTodosCalled = true
        if shouldFail {
            completion(.failure(MockNSError.storageRead))
        } else {
            completion(.success(mockTodos as! [T]))
        }
    }
    
    /// These methods are intentionally left empty because
    /// they are already tested in `StorageServiceTests` unit tests.
    func addTodo<T>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) where T : IToDo { }
    func updateTodo<T>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) where T : IToDo {}
    func deleteTodo(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {}
    func searchTodos<T>(_ type: T.Type, query: String, completion: @escaping (Result<[T], Error>) -> Void) where T : IToDo {}
}
