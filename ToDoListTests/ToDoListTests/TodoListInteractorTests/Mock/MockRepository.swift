//
//  MockRepository.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 21.10.2025.
//

import XCTest
@testable import ToDoList

/// Mock repository implementing ITodoRepository for unit testing.
/// Provides configurable success or failure results for each CRUD operation.
final class MockRepository: ITodoRepository {
    
    /// Specific errors for each repository operation.
    enum MockError: Error {
        case addFailed
        case fetchFailed
        case updateFailed
        case deleteFailed
        case searchFailed
        case castFailed
    }
    
    var addToDoResult: Result<Bool, Error>?
    var getToDosResult: Result<[TodoItem], Error>?
    var updateToDoResult: Result<Bool, Error>?
    var deleteToDoResult: Result<Bool, Error>?
    var searchTodosResult: Result<[TodoItem], Error>?
    
    /// Simulates adding a Todo item, triggering delegate callbacks.
    func addToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(addToDoResult ?? .failure(MockError.addFailed))
    }
    
    /// Simulates fetching all Todo items for testing fetchItems flow.
    func getToDos<T: IToDo>(completion: @escaping (Result<[T], Error>) -> Void) {
        guard let result = getToDosResult else {
            completion(.failure(MockError.fetchFailed))
            return
        }
        switch result {
        case .success(let items):
            if let casted = items as? [T] {
                completion(.success(casted))
            } else {
                completion(.failure(MockError.castFailed))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    /// Simulates updating a Todo item, triggering delegate callbacks.
    func updateToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(updateToDoResult ?? .failure(MockError.updateFailed))
    }
    
    /// Simulates deleting a Todo item by ID, triggering delegate callbacks.
    func deleteToDo(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(deleteToDoResult ?? .failure(MockError.deleteFailed))
    }
    
    /// Simulates searching Todo items by query string, triggering delegate callbacks.
    func searchTodos<T: IToDo>(query: String, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let result = searchTodosResult else {
            completion(.failure(MockError.searchFailed))
            return
        }
        switch result {
        case .success(let items):
            if let casted = items as? [T] {
                completion(.success(casted))
            } else {
                completion(.failure(MockError.castFailed))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
