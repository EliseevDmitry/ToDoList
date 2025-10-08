//
//  Extension+URLSession.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Abstraction over URLSession to enable dependency injection and unit testing.
protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

/// Makes URLSession conform to URLSessionProtocol.
extension URLSession: URLSessionProtocol { }
