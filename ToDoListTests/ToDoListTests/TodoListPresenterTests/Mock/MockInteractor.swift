//
//  MockInteractor.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 20.10.2025.
//

import Foundation
@testable import ToDoList

final class MockInteractor: ITodoInteractor {
    var didCallFetchItems = false
    var didCallAddItem = false
    var didCallUpdateItem = false
    var didCallDeleteItem = false
    var didCallSearchItems = false

    func fetchItems() { didCallFetchItems = true }
    func addItem<T>(_ item: T) where T : IToDo { didCallAddItem = true }
    func updateItem<T>(_ item: T) where T : IToDo { didCallUpdateItem = true }
    func deleteItem(id: UUID) { didCallDeleteItem = true }
    func searchItems(query: String) { didCallSearchItems = true }
}

final class MockView: ITodoListView {
    var didReloadData = false
    var didClearSearch = false
    var footerCount = 0
    func reloadData() { didReloadData = true }
    func showError(_ message: String) {}
    func clearSearch() { didClearSearch = true }
    func updateFooterCount(_ count: Int) { footerCount = count }
}

final class MockRouter: ITasksRouter {
    var didCallShowDetail = false
    var didCallPop = false
    func showTodoDetail(from source: (any ToDoList.ITodoListView)?, destination: any ToDoList.ITodoDetailView) {
        didCallShowDetail = true
    }
    
    func pop(from source: (any ToDoList.ITodoDetailView)?) {
        didCallPop = true
    }
}
