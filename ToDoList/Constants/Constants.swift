//
//  Constants.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

enum Constants {
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


//checkmark.circle

//circle
