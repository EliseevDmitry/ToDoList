//
//  Constants.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Константы приложения.
enum Constants {
    /// URL для получения списка задач с API.
    /// Формируется через `URLComponents` для безопасного построения URL.
    static let todosURL: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/todos"
        guard let url = components.url else {
            fatalError("Не удалось создать URL")
        }
        return url
    }()
}


//напиши комментарии к основным элементам в формате /// - сделай его профессиональным для ios программистов senior уровня, некоторые блоки я пометил комментарием // для твоего акцента
