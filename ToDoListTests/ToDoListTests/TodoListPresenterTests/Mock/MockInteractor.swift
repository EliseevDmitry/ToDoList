//
//  MockInteractor.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 20.10.2025.
//

import Foundation
@testable import ToDoList

/// Mock implementation of ITodoInteractor
final class MockInteractor: ITodoInteractor {
    var delegate: ITodoInteractorOutput?
    var didCallFetchItems = false
    var didCallAddItem = false
    var didCallUpdateItem = false
    var didCallDeleteItem = false
    var didCallSearchItems = false
    
    /// Tracks fetchItems calls
    func fetchItems() { didCallFetchItems = true }
    
    /// Tracks addItem calls
    func addItem<T>(_ item: T) where T : IToDo { didCallAddItem = true }
    
    /// Tracks updateItem calls
    func updateItem<T>(_ item: T) where T : IToDo { didCallUpdateItem = true }
    
    /// Tracks deleteItem calls
    func deleteItem(id: UUID) { didCallDeleteItem = true }
    
    /// Tracks searchItems calls
    func searchItems(query: String) { didCallSearchItems = true }
}
