//
//  Moc.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import Foundation

struct Moc {
    static let data: [TodoItemLocal] = [
        TodoItemLocal(todo: "Уборка в квартире", content: "Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире, Провести уборку в квартире", date: Date(), completed: true),
        TodoItemLocal(todo: "Покупки", content: "Купить продукты: молоко, хлеб, овощи", date: Date().addingTimeInterval(3600), completed: false),
        TodoItemLocal(todo: "Тренировка", content: "Сделать пробежку 5 км и растяжку", date: Date().addingTimeInterval(7200), completed: false),
        TodoItemLocal(todo: "Работа над проектом", content: "Завершить экран авторизации в приложении", date: Date().addingTimeInterval(10800), completed: true),
        TodoItemLocal(todo: "Чтение книги", content: "Прочитать 20 страниц книги по SwiftUI", date: Date().addingTimeInterval(14400), completed: false),
        TodoItemLocal(todo: "Звонок другу", content: "Позвонить и обсудить поездку на выходных", date: Date().addingTimeInterval(18000), completed: false),
        TodoItemLocal(todo: "Просмотр фильма", content: "Посмотреть новый детектив в онлайне", date: Date().addingTimeInterval(21600), completed: false)
    ]
}
