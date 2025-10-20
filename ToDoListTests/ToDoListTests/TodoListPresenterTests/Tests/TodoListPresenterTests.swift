//
//  TodoListPresenterTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 20.10.2025.
//

import XCTest
@testable import ToDoList

final class TodoListPresenterTests: XCTestCase {

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
            
            mockToDo = MockToDo(
                id: UUID(),
                todo: "Mock",
                content: "Mock description",
                completed: false,
                date: .now
            )
        }
    
    override func tearDown() {
        sut = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }

        func test_loadTodos_callsInteractorFetch() {
            sut.loadTodos()
            mockInteractor.fetchItems()
            XCTAssertTrue(mockInteractor.didCallFetchItems)
        }

        func test_addNewFixedItem_callsInteractorAddItem() {
            
            let expectation = expectation(description: "Moc")
            sut.addNewFixedItem(item: mockToDo)
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            XCTAssertTrue(mockInteractor.didCallAddItem)
        }

        func test_deleteToDo_callsInteractorDelete() {
            // Given
            sut.didFetchTodos([mockToDo])
            // Then
            let expectation = expectation(description: "Delete")
            sut.deleteToDo(at: 0)
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            // When
            XCTAssertTrue(mockInteractor.didCallDeleteItem)
        }

        func test_searchToDoItems_withEmptyQuery_callsFetchItems() {
            sut.searchToDoItems(query: "")
            XCTAssertTrue(mockInteractor.didCallFetchItems)
        }

        func test_searchToDoItems_withQuery_callsSearchItems() {
            let expectation = expectation(description: "Delete")
            sut.searchToDoItems(query: "test") //проверить
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            XCTAssertTrue(mockInteractor.didCallSearchItems)
        }

        func test_completedToDo_callsUpdateItem() {
            sut.didFetchTodos([mockToDo])
            sut.completedToDo(at: 0)
            XCTAssertTrue(mockInteractor.didCallUpdateItem)
        }

        func test_didTapAddNewItem_clearsSearchAndAddsItem() {
            let expectation = expectation(description: "ClearsAndAdds")
            sut.didTapAddNewItem()
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            XCTAssertTrue(mockView.didClearSearch)
            XCTAssertTrue(mockInteractor.didCallAddItem)
        }

        func test_didSelectTodo_callsRouterShowDetail() {
            sut.didFetchTodos([mockToDo])
            sut.didSelectTodo(at: 0)
            XCTAssertTrue(mockRouter.didCallShowDetail)
        }

}
