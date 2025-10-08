//
//  Constants.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// App-wide constants.
enum Constants {
    /// Base URL for fetching todo list from API.
    /// Built using `URLComponents` for safety and readability.
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
