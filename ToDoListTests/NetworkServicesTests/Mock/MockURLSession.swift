//
//  MockURLSession.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 12.10.2025.
//

import Foundation
@testable import ToDoList

/// Mock implementation of `IURLSession` that captures the last requested URL
/// and returns predefined data, response, or error for testing.
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
