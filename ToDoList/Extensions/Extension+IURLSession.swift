//
//  Extension+URLSession.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation


/// Abstraction over URLSession to enable dependency injection and unit testing.
protocol IURLSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> IURLSessionDataTask
}

/// Abstraction over URLSessionDataTask to make it mockable in tests.
protocol IURLSessionDataTask {
    func resume()
}

/// Makes URLSession conform to IURLSession.
extension URLSession: IURLSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> IURLSessionDataTask {
        let task: URLSessionDataTask = self.dataTask(with: url, completionHandler: completionHandler)
        return task
    }
}

/// Makes URLSessionDataTask conform to IURLSessionDataTask.
extension URLSessionDataTask: IURLSessionDataTask { }
