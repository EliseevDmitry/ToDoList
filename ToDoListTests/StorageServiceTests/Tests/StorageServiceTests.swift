//
//  StorageServiceTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 13.10.2025.
//

import XCTest
import CoreData
@testable import ToDoList

/// Unit tests for `StorageService`, verifying Core Data persistence logic, CRUD operations, search functionality, and contract behavior.
final class StorageServiceTests: XCTestCase {
    /// Test-wide constants for consistency and readability.
    enum Consts {
        static let fixedEntityCount = 1
        static let emptyCount = 0
        static let updateTodo = "Updated title"
        static let updateContent = "Updated description"
        static let timeout:Double = 2.0
    }
    
    var sut: StorageService!
    var container: NSPersistentContainer!
    var todo: [MockToDo] = []
    
    override func setUp() {
        super.setUp()
        container = NSPersistentContainer.makeInMemoryContainer()
        sut = StorageService(container: container)
        for index in 0 ... 2 {
            todo.append( MockToDo(
                id: UUID(),
                todo: "Test ToDo \(index)",
                content: "Test Description \(index)",
                completed: false,
                date: .now
            ))
        }
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        todo = []
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Verifies that adding any item conforming to `IToDo` creates a new entity in Core Data.
    /// Ensures `addTodo()` correctly persists the object and that it can be fetched afterward.
    func test_addTodo_createsNewEntity() {
        // Given
        let expectation = expectation(description: "Save single Todo")
        guard let entity = todo.first else {
            XCTFail("No MockToDo available to test update")
            return
        }
        // When
        sut.addTodo(item: entity) { result in
            switch result {
            case .success(let success):
                // Then
                XCTAssertTrue(success)
                // When
                self.sut.getToDos(MockToDo.self) { fetchResult in
                    switch fetchResult {
                    case .success(let todos):
                        // Then
                        XCTAssertEqual(todos.count, Consts.fixedEntityCount)
                        XCTAssertEqual(todos.first?.id, entity.id)
                        expectation.fulfill()
                    case .failure(let error):
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// Contract test verifying that Core Data **does not enforce uniqueness** on the `id` field.
    /// Demonstrates that inserting two entities with the same ID results in duplicates.
    func test_addTodo_withExistingId_createsDuplicateEntity() {
        // Given
        let mockToDo = MockToDo(
            id: UUID(),
            todo: "Duplicate",
            content: "Duplicate two mockToDo",
            completed: false,
            date: .now
        )
        let expectationOne = expectation(description: "First insert")
        let expectationTwo = expectation(description: "Second insert")
        let expectationThree = expectation(description: "Fetch after duplicates")
        // When
        sut.addTodo(item: mockToDo) { result in
            if case .failure(let error) = result {
                XCTFail("Unexpected error on first insert: \(error)")
            }
            expectationOne.fulfill()
        }
        wait(for: [expectationOne], timeout: Consts.timeout)
        sut.addTodo(item: mockToDo) { result in
            if case .failure(let error) = result {
                XCTFail("Unexpected error on duplicate insert: \(error)")
            }
            expectationTwo.fulfill()
        }
        wait(for: [expectationTwo], timeout: Consts.timeout)
        // Then
        sut.getToDos(MockToDo.self) { result in
            switch result {
            case .success(let todos):
                let duplicates = todos.filter { $0.id == mockToDo.id }
                XCTAssertEqual(duplicates.count, 2, "Expected 2 entities with the same id (duplicate created)")
            case .failure(let error):
                XCTFail("Fetch failed: \(error)")
            }
            expectationThree.fulfill()
        }
        wait(for: [expectationThree], timeout: Consts.timeout)
    }
    
    /// Verifies that multiple items conforming to `IToDo` are persisted in a single batch operation.
    /// Confirms that `addTodos()` writes all entities to Core Data without loss.
    func test_addTodos_createsMultipleEntities() {
        // Given
        let expectation = expectation(description: "Save multiple Todos")
        // When
        sut.addTodos(items: todo) { result in
            switch result {
            case .success(let success):
                // Then
                XCTAssertTrue(success)
                // When
                self.sut.getToDos(MockToDo.self) { fetchResult in
                    switch fetchResult {
                    case .success(let todos):
                        // Then
                        self.assertTodosEqual(todos, self.todo, expectation: expectation)
                    case .failure(let error):
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// Cross-verification test ensuring consistency between `addTodos()` and `getToDos()`.
    /// Validates deterministic behavior — all inserted entities must be retrievable.
    func test_addTodos_shouldSaveAllEntities() {
        // Given
        let expectation = expectation(description: "Get")
        sut.addTodos(items: todo) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
                // When
                self.sut.getToDos(MockToDo.self) { result in
                    switch result {
                    case .success(let todos):
                        // Then
                        self.assertTodosEqual(todos, self.todo, expectation: expectation)
                    case .failure(let error):
                        // Then
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// Ensures that updating an existing entity correctly modifies its stored fields.
    /// Confirms that `updateTodo()` locates the entity by ID and persists new values.
    func test_updateTodo_shouldChangeFields() {
        // Given
        let expectation = expectation(description: "Update Todo")
        guard var entity = todo.first else {
            XCTFail("No MockToDo available to test update")
            return
        }
        // When
        sut.addTodo(item: entity) { result in
            switch result {
            case .success(let success):
                // Then
                XCTAssertTrue(success)
                entity.updateTodoAndContent(todo: Consts.updateTodo, content: Consts.updateContent)
                // When
                self.sut.updateTodo(item: entity) { result in
                    switch result {
                    case .success(let success):
                        // Then
                        XCTAssertTrue(success)
                        // When
                        self.sut.getToDos(MockToDo.self) { result in
                            switch result {
                            case .success(let todos):
                                // Then
                                XCTAssertEqual(todos.count, Consts.fixedEntityCount)
                                XCTAssertEqual(todos.first?.id, entity.id)
                                XCTAssertNotEqual(todos.first?.todo, self.todo.first?.todo)
                                XCTAssertEqual(todos.first?.todo, Consts.updateTodo)
                                XCTAssertEqual(todos.first?.content, Consts.updateContent)
                                expectation.fulfill()
                            case .failure(let error):
                                self.fail(error: error, expectation: expectation)
                            }
                        }
                    case .failure(let error):
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// **Contract test:** verifies that updating a non-existing entity still returns `.success(true)`.
    /// Documents that the current persistence layer treats “no-op” updates as successful — a valid idempotent design choice.
    func test_updateTodo_withNonExistingId_returnsSuccessTrue() {
        // Given
        let nonExistingMockToDo = MockToDo(
            id: UUID(),
            todo: "Ghost",
            content: "Not in DB",
            completed: false,
            date: .now
        )
        let expectation = self.expectation(description: "Update non-existing todo")
        // When
        sut.updateTodo(item: nonExistingMockToDo) { result in
            // Then
            switch result {
            case .success(let success):
                XCTAssertTrue(success, "Updating non-existing ID should still return success=true")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: Consts.timeout)
    }
    
    /// Ensures that deleting an existing entity removes it from Core Data storage.
    /// Confirms that `deleteTodo()` successfully performs removal and persists the state.
    func test_deleteTodo_shouldRemoveEntity() {
        // Given
        let expectation = expectation(description: "Delete Todo")
        guard let entity = todo.first else {
            XCTFail("No MockToDo available to test delete")
            return
        }
        // When
        sut.addTodo(item: entity) { result in
            switch result {
            case .success(let success):
                // Then
                XCTAssertTrue(success)
                // When
                self.sut.deleteTodo(id: entity.id) { result in
                    switch result {
                    case .success(let success):
                        // Then
                        XCTAssertTrue(success)
                        // When
                        self.sut.getToDos(MockToDo.self) { result in
                            switch result {
                            case .success(let todos):
                                // Then
                                XCTAssertEqual(todos.count, Consts.emptyCount)
                                expectation.fulfill()
                            case .failure(let error):
                                self.fail(error: error, expectation: expectation)
                            }
                        }
                    case .failure(let error):
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// **Contract test:** verifies that deleting a non-existent entity still returns `.success(true)`.
    /// Explicitly documents that `deleteTodo()` is **idempotent**, meaning it’s safe to call multiple times or on missing entities.
    func test_deleteTodo_withNonExistingId_returnsSuccessTrue() {
        // Given
        let nonExistingId = UUID()
        let expectation = self.expectation(description: "Delete non-existing todo")
        
        // When
        sut.deleteTodo(id: nonExistingId) { result in
            // Then
            switch result {
            case .success(let success):
                XCTAssertTrue(success, "Deleting non-existing ID should still return success=true")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: Consts.timeout)
    }
    
    /// Tests `searchTodos()` returns only entities matching the query.
    /// Test data is generated using a loop 0...2, creating `todo` values "Test ToDo 0", "Test ToDo 1", "Test ToDo 2" and corresponding `content`.
    func test_searchTodos_shouldReturnMatchingEntities() {
        // Given
        let expectation = expectation(description: "Search Todos")
        // When
        sut.addTodos(items: todo) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
                self.sut.searchTodos(MockToDo.self, query: "1") { searchResult in
                    // Then
                    switch searchResult {
                    case .success(let results):
                        XCTAssertEqual(results.count, Consts.fixedEntityCount, "Expected 1 search result for query '1'")
                        XCTAssertEqual(results.first?.todo, "Test ToDo 1")
                    case .failure(let error):
                        XCTFail("Search failed: \(error)")
                    }
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Failed to add todos before search: \(error)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    /// Contract test: verifies that searchTodos returns an empty array
    /// instead of throwing when no matches are found.
    func test_searchTodos_withNoMatches_returnsEmptyArray() {
        // Given
        let expectation = expectation(description: "Search with no matches")
        // When
        sut.searchTodos(MockToDo.self, query: "NothingToFind") { result in
            // Then
            switch result {
            case .success(let todos):
                XCTAssertTrue(todos.isEmpty, "Expected empty search results for unmatched query")
            case .failure(let error):
                XCTFail("Expected empty success, got error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
}
