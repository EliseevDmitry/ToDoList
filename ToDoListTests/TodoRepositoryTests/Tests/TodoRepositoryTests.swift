//
//  TodoRepositoryTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 16.10.2025.
//

import XCTest
@testable import ToDoList

/// Unit tests for `TodoRepository`.
/// Verifies repository behavior depending on first app launch state.
final class TodoRepositoryTests: XCTestCase {
    
    enum Consts {
        static let timeout:Double = 2.0
    }
    
    var mockSettings: MockSettingsService!
    var mockNetwork: MockNetworkService!
    var mockStorage: MockStorageService!
    var sut: TodoRepository!
    
    override func setUp() {
        super.setUp()
        mockSettings = MockSettingsService()
        mockNetwork = MockNetworkService()
        mockStorage = MockStorageService()
        sut = TodoRepository(
            network: mockNetwork,
            storage: mockStorage,
            settings: mockSettings
        )
    }
    
    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockNetwork = nil
        mockSettings = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Verifies that on first launch, todos are fetched from network
    /// and saved into local storage.
    func test_getToDos_firstLaunch_fetchesFromNetworkAndSavesToStorage() {
        // Given
        let expectation = expectation(description: "Completion called")
        // When
        sut.getToDos { (result: Result<[MockToDo], Error>) in
            // Then
            XCTAssertTrue(self.mockNetwork.fetchCalled, "Should call the network")
            XCTAssertTrue(self.mockStorage.addTodosCalled, "Should save to storage")
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 1)
                expectation.fulfill()
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// Verifies that on subsequent launches, todos are retrieved
    /// from local storage without hitting the network.
    func test_getToDos_notFirstLaunch_fetchesFromStorage() {
        // Given
        mockSettings.isFirstLaunchValue = true
        let expectation = expectation(description: "Completion called")
        // When
        sut.getToDos { (result: Result<[MockToDo], Error>) in
            // Then
            XCTAssertFalse(self.mockNetwork.fetchCalled, "The network should not be called")
            XCTAssertTrue(self.mockStorage.getTodosCalled, "Should fetch from local storage")
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 2)
                expectation.fulfill()
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
}
