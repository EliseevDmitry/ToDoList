//
//  TodoItem.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

protocol IToDo: Identifiable {
    var id: UUID { get }
    var todo: String { get }
    var content: String { get }
    var completed: Bool { get }
    var date: Date { get }
    
    init(
        id: UUID,
        todo: String,
        content: String,
        completed: Bool,
        date: Date
    )
}

struct TodosResponse: Codable {
    let todos: [TodoItem]
}

struct TodoItem: Codable, IToDo {
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
    
    let id: UUID
    let todo: String
    let content: String
    var completed: Bool
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case todo
        case completed
    }
    
    enum Consts {
        static let content = "Тут должно быть подробное описание заметки"
        static let completed = false
        static let date = Date()
    }
    
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
    
    mutating func updateCompleted() {
        self.completed = true
    }
}
