//
//  TodoItem.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Протокол для абстрактного представления задачи.
/// Позволяет работать с любыми реализациями ToDo на уровне сервисов,
/// не привязываясь к конкретной модели данных.
protocol IToDo: Identifiable {
    var id: UUID { get }
    var todo: String { get }
    var content: String { get }
    var completed: Bool { get }
    var date: Date { get }
    
    /// Инициализация объекта через все поля.
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

/// Ответ от API с массивом задач.
/// В задании не требуется пагинация, поэтому забираем только базовые данные.
struct TodosResponse: Codable {
    let todos: [TodoItem]
}

/// Модель задачи приложения.
/// Используется для хранения локальных и сетевых данных, реализует `IToDo`.
/// `id`, `content` и `date` генерируется локально, остальные поля соответствуют требованиям задания.
struct TodoItem: Codable, IToDo {
    enum CodingKeys: String, CodingKey {
        case todo
        case completed
    }
    
    enum Consts {
        static let content = "Тут должно быть подробное описание заметки"
        static let completed = false
        static let date = Date()
    }
    
    let id: UUID
    var todo: String
    var content: String
    var completed: Bool
    var date: Date
    
    /// Полный инициализатор для явного создания задачи.
    /// Позволяет задать все свойства, включая локально генерируемый `id` и дату.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - todo: Заголовок задачи.
    ///   - content: Подробное описание.
    ///   - completed: Статус выполнения.
    ///   - date: Дата создания задачи.
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
    
    /// Инициализация из сети (декодирование).
    /// Локально создаются `id`, `content` и `date`.
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
    
    /// Основной инициализатор для локального создания задач.
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
    
    /// Помечает задачу как выполненную.
    mutating func updateCompleted() {
        self.completed = true
    }
    
    /// Обновляет заголовок и содержание задачи, одновременно обновляя дату последнего изменения.
    /// Используется при редактировании задачи пользователем, чтобы сохранить актуальность данных.
    mutating func updateTodoAndContent(todo: String, content: String) {
        self.todo = todo
        self.content = content
        self.date = Date.now
    }
}
