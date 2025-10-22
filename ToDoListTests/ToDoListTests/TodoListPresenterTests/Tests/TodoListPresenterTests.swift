//
//  TodoListPresenterTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 20.10.2025.
//

import XCTest
@testable import ToDoList

/// Unit tests for TodoListPresenter behavior
final class TodoListPresenterTests: XCTestCase {
    
    enum Consts {
        static let emptyQuery = ""
        static let testQuery = "test"
        static let timeout:Double = 2.0
    }
    
    private var sut: TodoListPresenter!
    private var mockInteractor: MockInteractor!
    private var mockView: MockView!
    private var mockRouter: MockRouter!
    private var mockToDo: MockToDo!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockInteractor()
        mockView = MockView()
        mockRouter = MockRouter()
        sut = TodoListPresenter(
            interactor: mockInteractor,
            router: mockRouter
        )
        sut.setView(mockView)
        mockToDo = self.mockTodo
    }
    
    override func tearDown() {
        sut = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Ensures loadTodos triggers interactor fetch
    func test_loadTodos_callsInteractorFetch() {
        // Given
        sut.loadTodos()
        // When
        mockInteractor.fetchItems()
        // Then
        XCTAssertTrue(mockInteractor.didCallFetchItems)
    }
    
    /// Returns correct todo for a given index
    func test_todoAtIndex_returnsCorrectItem() {
        // Given
        sut.didFetchTodos([mockToDo])
        // When
        let item = sut.todo(at: 0)
        // Then
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, mockToDo.id)
        XCTAssertEqual(item?.todo, mockToDo.todo)
    }
    
    /// Returns nil if index is out of bounds
    func test_todoAtIndex_outOfBounds_returnsNil() {
        // Given
        sut.didFetchTodos([mockToDo])
        // When
        let item = sut.todo(at: 1)
        // Then
        XCTAssertNil(item)
    }
    
    /// Calls interactor update when updating an item
    func test_updateItem_callsInteractorUpdate() {
        // When
        sut.updateItem(entity: mockToDo)
        // Then
        XCTAssertTrue(mockInteractor.didCallUpdateItem)
    }
    
    /// Adds a new fixed todo item via interactor
    func test_addNewFixedItem_callsInteractorAddItem() {
        // When
        let expectation = expectation(description: "Moc")
        sut.addNewFixedItem(item: mockToDo)
        expectation.fulfill()
        wait(for: [expectation], timeout: Consts.timeout)
        // Then
        XCTAssertTrue(mockInteractor.didCallAddItem)
    }
    
    /// Deletes a todo item via interactor
    func test_deleteToDo_callsInteractorDelete() {
        // Given
        sut.didFetchTodos([mockToDo])
        // When
        let expectation = expectation(description: "Delete")
        sut.deleteToDo(at: 0)
        expectation.fulfill()
        wait(for: [expectation], timeout: Consts.timeout)
        // Then
        XCTAssertTrue(mockInteractor.didCallDeleteItem)
    }
    
    /// Fetches all todos when search query is empty
    func test_searchToDoItems_withEmptyQuery_callsFetchItems() {
        // When
        sut.searchToDoItems(query: Consts.emptyQuery)
        // Then
        XCTAssertTrue(mockInteractor.didCallFetchItems)
    }
    
    /// Calls search on interactor when query is not empty
    func test_searchToDoItems_withQuery_callsSearchItems() {
        // When
        let expectation = expectation(description: "Delete")
        sut.searchToDoItems(query: Consts.testQuery)
        expectation.fulfill()
        wait(for: [expectation], timeout: Consts.timeout)
        // Then
        XCTAssertTrue(mockInteractor.didCallSearchItems)
    }
    
    /// Marks a todo as completed and updates via interactor
    func test_completedToDo_callsUpdateItem() {
        // When
        sut.didFetchTodos([mockToDo])
        sut.completedToDo(at: 0)
        // Then
        XCTAssertTrue(mockInteractor.didCallUpdateItem)
    }
    
    /// Clears search and adds new item on add action
    func test_didTapAddNewItem_clearsSearchAndAddsItem() {
        // When
        let expectation = expectation(description: "ClearsAndAdds")
        sut.didTapAddNewItem()
        expectation.fulfill()
        wait(for: [expectation], timeout: Consts.timeout)
        // Then
        XCTAssertTrue(mockView.didClearSearch)
        XCTAssertTrue(mockInteractor.didCallAddItem)
    }
    
    /// Navigates to todo detail on selection
    func test_didSelectTodo_callsRouterShowDetail() {
        // When
        sut.didFetchTodos([mockToDo])
        sut.didSelectTodo(at: 0)
        // Then
        XCTAssertTrue(mockRouter.didCallShowDetail)
    }
}
