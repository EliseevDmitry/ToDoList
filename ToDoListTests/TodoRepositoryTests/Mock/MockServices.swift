//
//  MockServices.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 16.10.2025.
//

import Foundation
@testable import ToDoList

/// Mocked `NSError` cases for simulating failures in tests.
/// Used to emulate network and storage layer errors.
enum MockNSError: Error {
    case network
    case storageWrite
    case storageRead
    
    /// Returns a corresponding `NSError` instance for each mock error case.
    var nsError: NSError {
        switch self {
        case .network:
            return NSError(domain: "network", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Simulated network error"
            ])
        case .storageWrite:
            return NSError(domain: "storage", code: -2, userInfo: [
                NSLocalizedDescriptionKey: "Simulated storage write error"
            ])
        case .storageRead:
            return NSError(domain: "storage", code: -3, userInfo: [
                NSLocalizedDescriptionKey: "Simulated storage read error"
            ])
        }
    }
}

/// Mock implementation of `ISettingsService`.
/// Allows controlling the app’s first-launch behavior in tests.
final class MockSettingsService: ISettingsService {
    var isFirstLaunchValue = false
    func isFirstLaunch() -> Bool { isFirstLaunchValue }
}

/// Mock implementation of `INetworkServices`.
/// Simulates successful or failed network responses for testing.
final class MockNetworkService: INetworkServices {
    var fetchCalled = false
    var shouldFail = false
    var mockResponse: TodosResponse =  TodosResponse(
        todos: [
            MockToDo(
                id: UUID(),
                todo: "Test ToDo",
                content: "Test Description",
                completed: false,
                date: .now
            )
        ])
    
    /// Mocks network data fetching.
    /// Returns either a predefined `TodosResponse` or a simulated network error.
    func fetchEntityData<T: Codable>(
        url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        fetchCalled = true
        if shouldFail {
            completion(.failure(MockNSError.network))
        } else {
            completion(.success(mockResponse as! T))
        }
    }
}

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
