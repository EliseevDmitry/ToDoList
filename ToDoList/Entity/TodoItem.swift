//
//  TodoItem.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Abstract representation of a Todo item.
/// Allows working with any ToDo implementation without depending on a specific model.
protocol IToDo: Identifiable {
    var id: UUID { get }
    var todo: String { get }
    var content: String { get }
    var completed: Bool { get }
    var date: Date { get }
    
    /// Full initializer for explicit creation.
    init(
        id: UUID,
        todo: String,
        content: String,
        completed: Bool,
        date: Date
    )
    mutating func updateCompleted()
    mutating func updateTodoAndContent(todo: String, content: String)
}

/// API response with a list of todos.
struct TodosResponse: Codable {
    let todos: [TodoItem]
}

/// Todo model for local and network data.
/// Implements `IToDo`.
struct TodoItem: Codable, IToDo {
    enum CodingKeys: String, CodingKey {
        case todo
        case completed
    }
    
    /// Centralized constants for Todo item defaults.
    enum Consts {
        static let content = "Add a detailed note description"
        static let completed = false
        static let date = Date()
    }
    
    let id: UUID
    var todo: String
    var content: String
    var completed: Bool
    var date: Date
    
    /// Full initializer for explicit task creation.
    init(
        id: UUID,
        todo: String,
        content: String,
        completed: Bool,
        date: Date
    ) {
        self.id = id
        self.todo = todo
        self.content = content
        self.completed = completed
        self.date = date
    }
    
    /// Decoding initializer from network.
    /// Generates local `id`, `content`, and `date`.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.todo = try container.decode(String.self, forKey: .todo)
        self.completed = try container.decode(
            Bool.self,
            forKey: .completed
        )
        self.id = UUID()
        self.content = Consts.content
        self.date = Consts.date
    }
    
    /// Convenience initializer for local creation.
    init(
        todo: String,
        content: String = Consts.content,
        completed: Bool = Consts.completed,
        date: Date = Consts.date
    ) {
        self.id = UUID()
        self.todo = todo
        self.content = content
        self.completed = completed
        self.date = date
    }
    
    /// Marks the task as completed.
    mutating func updateCompleted() {
        self.completed = true
    }
    
    /// Updates title and content, refreshing the modification date.
    mutating func updateTodoAndContent(todo: String, content: String) {
        self.todo = todo
        self.content = content
        self.date = Date.now
    }
}
