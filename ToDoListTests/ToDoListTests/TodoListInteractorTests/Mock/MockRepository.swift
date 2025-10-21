//
//  MockRepository.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 21.10.2025.
//

import Foundation
import XCTest
@testable import ToDoList

final class MockRepository: ITodoRepository {
    
    enum MockError: Error {
        case castFailed
    }
    
    var addToDoResult: Result<Bool, Error>?
    var getToDosResult: Result<[TodoItem], Error>?
    var updateToDoResult: Result<Bool, Error>?
    var deleteToDoResult: Result<Bool, Error>?
    var searchTodosResult: Result<[TodoItem], Error>?
    
    //только успех
    func addToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(addToDoResult!)
    }
    
    func getToDos<T: IToDo>(completion: @escaping (Result<[T], Error>) -> Void) {
        guard let result = getToDosResult else {
            completion(.failure(MockError.castFailed))
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
    
    func updateToDo<T: IToDo>(item: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(updateToDoResult!)
    }
    
    func deleteToDo(id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(deleteToDoResult!)
    }
    
    func searchTodos<T: IToDo>(query: String, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let result = searchTodosResult else {
            completion(.failure(MockError.castFailed))
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


final class MockInteractorOutput: ITodoInteractorOutput {
    var expectation: XCTestExpectation?
    var didCallDidFetchTodos = false
    var didCallDidAddTodo = false
    var didCallDidUpdateTodo = false
    var didCallDidDeleteTodo = false
    var didCallDidSearchTodos = false
    var didCallDidFail = false

    func didFetchTodos<T>(_ todos: [T]) {
        didCallDidFetchTodos = true
        expectation?.fulfill()
    }
    
    func didAddTodo<T>(_ todo: T) {
        didCallDidAddTodo = true
        expectation?.fulfill()
    }
    
    func didUpdateTodo<T>(_ todo: T) {
        didCallDidUpdateTodo = true
        expectation?.fulfill()
    }
    
    func didDeleteTodo(id: UUID) {
        didCallDidDeleteTodo = true
        expectation?.fulfill()
    }
    
    func didSearchTodos<T>(_ todos: [T]) {
        didCallDidSearchTodos = true
        expectation?.fulfill()
    }
    
    func didFail(with error: Error) {
        didCallDidFail = true
        expectation?.fulfill()
    }
}
