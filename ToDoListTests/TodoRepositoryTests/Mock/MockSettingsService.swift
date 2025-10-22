//
//  MockSettingsService.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 16.10.2025.
//

import Foundation
@testable import ToDoList


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
