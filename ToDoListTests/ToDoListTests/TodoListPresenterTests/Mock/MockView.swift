//
//  MockView.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 22.10.2025.
//

@testable import ToDoList

/// Mock implementation of ITodoListView
final class MockView: ITodoListView {
    var didReloadData = false
    var didClearSearch = false
    var footerCount = 0
    
    /// Tracks reloadData calls
    func reloadData() { didReloadData = true }
    
    /// Tracks error display (stub)
    func showError(_ message: String) {}
    
    /// Tracks clearSearch calls
    func clearSearch() { didClearSearch = true }
    
    /// Tracks footer count updates
    func updateFooterCount(_ count: Int) { footerCount = count }
}
