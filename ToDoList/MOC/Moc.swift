//
//  Moc.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import Foundation

struct Moc {
    static let data: [TodoItem] = [
        TodoItem(
            todo: "Уборка в квартире",
            content: "Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире",
            completed: true,
            date: Date()
        ),
        TodoItem(
            todo: "Покупки",
            content: "Купить продукты: молоко, хлеб, овощи",
            completed: false,
            date: Date().addingTimeInterval(3600)
        ),
        TodoItem(
            todo: "Тренировка",
            content: "Сделать пробежку 5 км и растяжку",
            completed: false,
            date: Date().addingTimeInterval(7200)
        ),
        TodoItem(
            todo: "Работа над проектом",
            content: "Завершить экран авторизации в приложении",
            completed: true,
            date: Date().addingTimeInterval(10800)
        ),
        TodoItem(
            todo: "Чтение книги",
            content: "Прочитать 20 страниц книги по SwiftUI",
            completed: false,
            date: Date().addingTimeInterval(14400)
        ),
        TodoItem(
            todo: "Звонок другу",
            content: "Позвонить и обсудить поездку на выходных",
            completed: false,
            date: Date().addingTimeInterval(18000)
        ),
        TodoItem(
            todo: "Просмотр фильма",
            content: "Посмотреть новый детектив в онлайне",
            completed: false,
            date: Date().addingTimeInterval(21600)
        )
    ]
}
