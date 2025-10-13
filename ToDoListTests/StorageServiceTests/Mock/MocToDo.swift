//
//  MocToDo.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 13.10.2025.
//

import Foundation
@testable import ToDoList

struct MockToDo: IToDo {
    var id: UUID
    var todo: String
    var content: String
    var completed: Bool
    var date: Date
    
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
    
    mutating func updateCompleted() {
        self.completed = true
    }
    
    mutating func updateTodoAndContent(
        todo: String,
        content: String
    ) {
        self.todo = todo
        self.content = content
    }
}
