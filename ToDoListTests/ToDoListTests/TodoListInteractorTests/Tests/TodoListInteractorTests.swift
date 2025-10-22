//
//  TodoListInteractorTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 21.10.2025.
//

import XCTest
@testable import ToDoList

/// Unit tests for TodoListInteractor validating CRUD and search behavior.
final class TodoListInteractorTests: XCTestCase {
    
    enum Consts {
        static let testQuery = "test"
        static let timeout:Double = 2.0
    }
    
    /// Errors used in TodoListInteractorTests to simulate repository failures.
    enum MockError: Error, LocalizedError {
        case fetchFailed
        case addFailed
        case updateFailed
        case deleteFailed
        case searchFailed
        
        var errorDescription: String? {
            switch self {
            case .fetchFailed: return "Failed to fetch todos"
            case .addFailed: return "Failed to add todo"
            case .updateFailed: return "Failed to update todo"
            case .deleteFailed: return "Failed to delete todo"
            case .searchFailed: return "Failed to search todos"
            }
        }
    }
    
    private var sut: ITodoInteractor!
    private var toDo: TodoItem!
    private var mockRepository: MockRepository!
    private var mockDelegate: MockInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRepository()
        sut = TodoListInteractor(todoRepository: mockRepository)
        mockDelegate = MockInteractorOutput()
        sut.delegate = mockDelegate
        toDo = self.mockTodoItem
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    
    /// Creates an XCTestExpectation and assigns it to the mock delegate.
    private func setupExpectation(_ description: String) -> XCTestExpectation {
        let expectation = self.expectation(description: description)
        mockDelegate.expectation = expectation
        return expectation
    }
    
    // MARK: - Tests
    
    /// Ensures fetchItems success triggers delegate's didFetchTodos.
    func test_fetchItems_success_callsDidFetchTodos() {
        // Given
        mockRepository.getToDosResult = .success([toDo])
        _ = setupExpectation("FetchSuccess")
        // When
        sut.fetchItems()
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFetchTodos)
    }
    
    /// Ensures fetchItems failure triggers delegate's didFail with fetchFailed error.
    func test_fetchItems_failure_callsDidFail() {
        // Given
        mockRepository.getToDosResult = .failure(MockError.fetchFailed)
        _ = setupExpectation("FetchFail")
        // When
        sut.fetchItems()
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFail)
        XCTAssertEqual(
            mockDelegate.capturedError?.localizedDescription,
            MockError.fetchFailed.localizedDescription
        )
    }
    
    /// Ensures addItem success triggers delegate's didAddTodo.
    func test_addItem_success_callsDidAddTodo() {
        // Given
        mockRepository.addToDoResult = .success(true)
        _ = setupExpectation("AddSuccess")
        // When
        sut.addItem(toDo)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidAddTodo)
    }
    
    /// Ensures addItem failure triggers delegate's didFail with addFailed error.
    func test_addItem_failure_callsDidFail() {
        // Given
        mockRepository.addToDoResult = .failure(MockError.addFailed)
        _ = setupExpectation("AddFail")
        // When
        sut.addItem(toDo)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFail)
        XCTAssertEqual(
            mockDelegate.capturedError?.localizedDescription,
            MockError.addFailed.localizedDescription
        )
    }
    
    /// Ensures updateItem success triggers delegate's didUpdateTodo.
    func test_updateItem_success_callsDidUpdateTodo() {
        // Given
        mockRepository.updateToDoResult = .success(true)
        _ = setupExpectation("UpdateSuccess")
        // When
        sut.updateItem(toDo)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidUpdateTodo)
    }
    
    /// Ensures updateItem failure triggers delegate's didFail with updateFailed error.
    func test_updateItem_failure_callsDidFail() {
        // Given
        mockRepository.updateToDoResult = .failure(MockError.updateFailed)
        _ = setupExpectation("UpdateFail")
        // When
        sut.updateItem(toDo)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFail)
        XCTAssertEqual(
            mockDelegate.capturedError?.localizedDescription,
            MockError.updateFailed.localizedDescription
        )
    }
    
    /// Ensures deleteItem success triggers delegate's didDeleteTodo.
    func test_deleteItem_success_callsDidDeleteTodo() {
        // Given
        mockRepository.deleteToDoResult = .success(true)
        _ = setupExpectation("DeleteSuccess")
        // When
        sut.deleteItem(id: toDo.id)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidDeleteTodo)
    }
    
    /// Ensures deleteItem failure triggers delegate's didFail with deleteFailed error.
    func test_deleteItem_failure_callsDidFail() {
        // Given
        mockRepository.deleteToDoResult = .failure(MockError.deleteFailed)
        _ = setupExpectation("DeleteFail")
        // When
        sut.deleteItem(id: toDo.id)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFail)
        XCTAssertEqual(
            mockDelegate.capturedError?.localizedDescription,
            MockError.deleteFailed.localizedDescription
        )
    }
    
    /// Ensures searchItems success triggers delegate's didSearchTodos.
    func test_searchItems_success_callsDidSearchTodos() {
        // Given
        mockRepository.searchTodosResult = .success([toDo])
        _ = setupExpectation("SearchSuccess")
        // When
        sut.searchItems(query: Consts.testQuery)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidSearchTodos)
    }
    
    /// Ensures searchItems failure triggers delegate's didFail with searchFailed error.
    func test_searchItems_failure_callsDidFail() {
        // Given
        mockRepository.searchTodosResult = .failure(MockError.searchFailed)
        _ = setupExpectation("SearchFail")
        // When
        sut.searchItems(query: Consts.testQuery)
        // Then
        waitForExpectations(timeout: Consts.timeout)
        XCTAssertTrue(mockDelegate.didCallDidFail)
        XCTAssertEqual(
            mockDelegate.capturedError?.localizedDescription,
            MockError.searchFailed.localizedDescription
        )
    }
}
