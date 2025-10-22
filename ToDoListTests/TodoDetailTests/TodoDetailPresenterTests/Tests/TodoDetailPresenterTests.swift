//
//  TodoDetailPresenterTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

import XCTest
@testable import ToDoList

/// Tests for TodoDetailPresenter
final class TodoDetailPresenterTests: XCTestCase {
    
    enum Consts {
        static let updateTitle = "Updated"
        static let updateContent = "New Content"
        static let todoItem = "Test"
    }
    
    private var presenter: TodoDetailPresenter!
    private var mockDetailView: MockDetailView!
    private var mockDelegate: MockDelegate!
    private var mockRouter: MockRouter!
    private var todo: TodoItem!
    
    override func setUp() {
        super.setUp()
        todo = self.mockTodoItem
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
        super.tearDown()
    }
    
    
    // MARK: - Tests
    
    /// Ensures the view displays the Todo on load
    func testViewDidLoad_displaysTodo() {
        // When
        presenter.viewDidLoad()
        // Then
        XCTAssertNotNil(mockDetailView.displayedTodo)
        XCTAssertEqual((mockDetailView.displayedTodo as? TodoItem)?.todo, Consts.todoItem)
    }
    
    /// Updates the Todo and calls delegate if not completed
    func testUpdateItem_updatesTodoAndCallsDelegate_whenNotCompleted() {
        // When
        presenter.updateItem(title: Consts.updateTitle, content: Consts.updateContent)
        // Then
        XCTAssertTrue(mockDelegate.didUpdateItemCalled)
        let updated = mockDelegate.updatedTodo as? TodoItem
        XCTAssertEqual(updated?.todo, Consts.updateTitle)
        XCTAssertEqual(updated?.content, Consts.updateContent)
    }
    
    /// Does not call delegate when the Todo is already completed
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
        presenter.updateItem(title: Consts.updateTitle, content: Consts.updateContent)
        // Then
        XCTAssertFalse(mockDelegate.didUpdateItemCalled)
    }
    
    /// Calls router's pop when back is tapped
    func testDidTapBack_callsRouterPop() {
        // When
        presenter.didTapBack()
        // Then
        XCTAssertTrue(mockRouter.didCallPop)
    }
    
    /// Assigns a new view correctly using setView
    func testSetView_assignsView() {
        // Given
        let newView = MockDetailView()
        presenter.setView(newView)
        // When
        presenter.viewDidLoad()
        // Then
        XCTAssertEqual((newView.displayedTodo as? TodoItem)?.todo, Consts.todoItem)
    }
}
