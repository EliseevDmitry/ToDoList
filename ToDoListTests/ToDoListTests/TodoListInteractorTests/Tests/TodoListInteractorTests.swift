//
//  TodoListInteractorTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 21.10.2025.
//

import XCTest
@testable import ToDoList

final class TodoListInteractorTests: XCTestCase {
    
    enum MockError: Error {
        case someError
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
        toDo = TodoItem(
            id: UUID(),
            todo: "Test toDo",
            content: "Test description",
            completed: false,
            date: .now
        )
        
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    private func setupExpectation(_ description: String) -> XCTestExpectation {
        let expectation = self.expectation(description: description)
        mockDelegate.expectation = expectation
        return expectation
    }
    
    // MARK: - fetchItems
    func test_fetchItems_success_callsDidFetchTodos() {
        // Given
        mockRepository.getToDosResult = .success([toDo])
        _ = setupExpectation("FetchSuccess")
        
        // When
        sut.fetchItems()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFetchTodos)
    }
    
    func test_fetchItems_failure_callsDidFail() {
        // Given
        mockRepository.getToDosResult = .failure(MockError.someError)
        _ = setupExpectation("FetchFail")
        
        // When
        sut.fetchItems()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFail)
    }
    
    // MARK: - addItem
    func test_addItem_success_callsDidAddTodo() {
        mockRepository.addToDoResult = .success(true)
        _ = setupExpectation("AddSuccess")
        
        sut.addItem(toDo)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidAddTodo)
    }
    
    func test_addItem_failure_callsDidFail() {
        mockRepository.addToDoResult = .failure(MockError.someError)
        _ = setupExpectation("AddFail")
        
        sut.addItem(toDo)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFail)
    }
    
    // MARK: - updateItem
    func test_updateItem_success_callsDidUpdateTodo() {
        mockRepository.updateToDoResult = .success(true)
        _ = setupExpectation("UpdateSuccess")
        
        sut.updateItem(toDo)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidUpdateTodo)
    }
    
    func test_updateItem_failure_callsDidFail() {
        mockRepository.updateToDoResult = .failure(MockError.someError)
        _ = setupExpectation("UpdateFail")
        
        sut.updateItem(toDo)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFail)
    }
    
    // MARK: - deleteItem
    func test_deleteItem_success_callsDidDeleteTodo() {
        mockRepository.deleteToDoResult = .success(true)
        _ = setupExpectation("DeleteSuccess")
        
        sut.deleteItem(id: toDo.id)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidDeleteTodo)
    }
    
    func test_deleteItem_failure_callsDidFail() {
        mockRepository.deleteToDoResult = .failure(MockError.someError)
        _ = setupExpectation("DeleteFail")
        
        sut.deleteItem(id: toDo.id)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFail)
    }
    
    // MARK: - searchItems
    func test_searchItems_success_callsDidSearchTodos() {
        mockRepository.searchTodosResult = .success([toDo])
        _ = setupExpectation("SearchSuccess")
        
        sut.searchItems(query: "test")
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidSearchTodos)
    }
    
    func test_searchItems_failure_callsDidFail() {
        mockRepository.searchTodosResult = .failure(MockError.someError)
        _ = setupExpectation("SearchFail")
        
        sut.searchItems(query: "test")
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockDelegate.didCallDidFail)
    }
}
