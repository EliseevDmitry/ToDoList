//
//  MockURLSession.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 12.10.2025.
//

import Foundation
@testable import ToDoList

final class MockURLSession: IURLSession {
    private(set) var lastURL: URL?
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    /// Returns a mock data task that triggers the completion immediately.
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> IURLSessionDataTask {
        lastURL = url
        return MockURLSessionDataTask {
            completionHandler(self.nextData, self.nextResponse, self.nextError)
        }
    }
}

/// Mock `IURLSessionDataTask` that executes a closure on `resume()`.
final class MockURLSessionDataTask: IURLSessionDataTask {
    private let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    /// Simulate task start.
    func resume() {
        closure()
    }
}
