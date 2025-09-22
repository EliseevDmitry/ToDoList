//
//  TodoItem.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

//Название
//Описание
//Дата создания
//Статус выполнена или нет

struct TodosResponse: Codable {
    let todos: [TodoItem]
    //подумать надо ли
    //let total: Int
    //let skip: Int
    //let limit: Int
}

struct TodoItem: Codable, Identifiable {
    let id: Int
    let todo: String
    let completed: Bool
    //let userId: Int
    
    var statusText: String {
        completed ? "Completed" : "Pending"
    }
}

struct TodoItemLocal: Codable {
    let todo: String
    let content: String
    let date: Date
    let completed: Bool
    
    var statusText: String {
        completed ? "Completed" : "Pending"
    }
}
