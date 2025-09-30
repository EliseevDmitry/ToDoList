//
//  Extension+URLSession.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Протокол для абстракции URLSession, чтобы облегчить тестирование через dependency injection.
/// Позволяет подменять реальный URLSession моками или заглушками.
protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

/// Расширение реального URLSession для соответствия протоколу.
extension URLSession: URLSessionProtocol {}
