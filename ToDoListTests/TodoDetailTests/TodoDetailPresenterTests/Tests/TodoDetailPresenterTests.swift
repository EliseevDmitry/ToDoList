//
//  TodoDetailPresenterTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import XCTest
@testable import ToDoList

final class TodoDetailPresenterTests: XCTestCase {
    
    private var presenter: TodoDetailPresenter!
    private var mockDetailView: MockDetailView!
    private var mockDelegate: MockDelegate!
    private var mockRouter: MockRouter!
    private var todo: TodoItem!
    
    override func setUp() {
        super.setUp()
        todo = TodoItem(
            id: UUID(),
            todo: "Test",
            content: "Content",
            completed: false,
            date: .now
        )
        mockDetailView = MockDetailView()
        mockDelegate = MockDelegate()
        mockRouter = MockRouter()
        presenter = TodoDetailPresenter(
            view: mockDetailView,
            router: mockRouter,
            todo: todo
        )
        presenter.delegate = mockDelegate
    }
    
    override func tearDown() {
        presenter = nil
        mockDetailView = nil
        mockDelegate = nil
        mockRouter = nil
        todo = nil //nil struct
        super.tearDown()
    }
    
    
    // MARK: - Tests
    
    func testViewDidLoad_displaysTodo() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(mockDetailView.displayedTodo)
        XCTAssertEqual((mockDetailView.displayedTodo as? TodoItem)?.todo, "Test")
    }
    
    func testUpdateItem_updatesTodoAndCallsDelegate_whenNotCompleted() {
        // When
        presenter.updateItem(title: "Updated", content: "New Content")
        
        // Then
        XCTAssertTrue(mockDelegate.didUpdateItemCalled)
        let updated = mockDelegate.updatedTodo as? TodoItem
        XCTAssertEqual(updated?.todo, "Updated")
        XCTAssertEqual(updated?.content, "New Content")
    }
    
    func testUpdateItem_doesNotCallDelegate_whenCompleted() {
        // Given
        todo.completed = true
        presenter = TodoDetailPresenter(
            view: mockDetailView,
            router: mockRouter,
            todo: todo
        )
        presenter.delegate = mockDelegate
        
        // When
        presenter.updateItem(title: "Updated", content: "New Content")
        
        // Then
        XCTAssertFalse(mockDelegate.didUpdateItemCalled)
    }
    
    func testDidTapBack_callsRouterPop() {
        // When
        presenter.didTapBack()
        
        // Then
        XCTAssertTrue(mockRouter.didCallPop)
    }
    
    func testSetView_assignsView() {
        // Given
        let newView = MockDetailView()
        presenter.setView(newView)
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertEqual((newView.displayedTodo as? TodoItem)?.todo, "Test")
    }
}
