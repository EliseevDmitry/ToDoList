//
//  Extension+ITodoListView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 21.10.2025.
//

import Foundation

/// Provides default empty implementations for `ITodoListView` methods.
///
/// This extension allows for simpler testing of the `Router` by enabling
/// mocks or other classes to conform to `ITodoListView` without
/// implementing all the methods. Useful in VIPER for isolating navigation
/// logic during unit tests.
extension ITodoListView {
    func reloadData() {}
    func showError(_ message: String) {}
    func clearSearch() {}
    func updateFooterCount(_ count: Int) {}
}
