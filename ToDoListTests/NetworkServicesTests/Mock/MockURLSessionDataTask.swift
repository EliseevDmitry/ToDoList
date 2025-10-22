//
//  MockURLSessionDataTask.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 23.10.2025.
//

import Foundation
@testable import ToDoList

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
