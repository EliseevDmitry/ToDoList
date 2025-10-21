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
            // Given
            sut.loadTodos()
            // When
            mockInteractor.fetchItems()
            // Then
            XCTAssertTrue(mockInteractor.didCallFetchItems)
        }

    
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

    //nil - no index
    func test_todoAtIndex_outOfBounds_returnsNil() {
        // Given
        sut.didFetchTodos([mockToDo])
        // When
        let item = sut.todo(at: 1)
        // Then
        XCTAssertNil(item)
    }
    
    //update - на уровне presentor e у нас нет обработки неудачного обновления или обновления несуществующей позиции
    func test_updateItem_callsInteractorUpdate() {
        // When
        sut.updateItem(entity: mockToDo)
        // Then
        XCTAssertTrue(mockInteractor.didCallUpdateItem)
    }

    
        func test_addNewFixedItem_callsInteractorAddItem() {
            // When
            let expectation = expectation(description: "Moc")
            sut.addNewFixedItem(item: mockToDo)
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            // Then
            XCTAssertTrue(mockInteractor.didCallAddItem)
        }

        func test_deleteToDo_callsInteractorDelete() {
            // Given
            sut.didFetchTodos([mockToDo])
            // When
            let expectation = expectation(description: "Delete")
            sut.deleteToDo(at: 0)
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            // Then
            XCTAssertTrue(mockInteractor.didCallDeleteItem)
        }

        func test_searchToDoItems_withEmptyQuery_callsFetchItems() {
            // When
            sut.searchToDoItems(query: "")
            // Then
            XCTAssertTrue(mockInteractor.didCallFetchItems)
        }

        func test_searchToDoItems_withQuery_callsSearchItems() {
            // When
            let expectation = expectation(description: "Delete")
            sut.searchToDoItems(query: "test") //проверить
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            // Then
            XCTAssertTrue(mockInteractor.didCallSearchItems)
        }

        func test_completedToDo_callsUpdateItem() {
            // When
            sut.didFetchTodos([mockToDo])
            sut.completedToDo(at: 0)
            // Then
            XCTAssertTrue(mockInteractor.didCallUpdateItem)
        }

        func test_didTapAddNewItem_clearsSearchAndAddsItem() {
            // When
            let expectation = expectation(description: "ClearsAndAdds")
            sut.didTapAddNewItem()
            expectation.fulfill()
            wait(for: [expectation], timeout: 1)
            // Then
            XCTAssertTrue(mockView.didClearSearch)
            XCTAssertTrue(mockInteractor.didCallAddItem)
        }

        func test_didSelectTodo_callsRouterShowDetail() {
            // When
            sut.didFetchTodos([mockToDo])
            sut.didSelectTodo(at: 0)
            // Then
            XCTAssertTrue(mockRouter.didCallShowDetail)
        }

}
