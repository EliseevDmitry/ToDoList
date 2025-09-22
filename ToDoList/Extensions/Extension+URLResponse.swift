//
//  Extension+URLResponse.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import Foundation

/// Server response handling is encapsulated in this extension.
/// Currently, it performs a basic validation for successful HTTP responses (status code 200–299).
/// Detailed handling of different status codes is not implemented, as this project is for learning purposes.
/// This extension can be easily extended to handle additional HTTP status codes if needed.

// MARK: - Public functions
extension URLResponse {
    /// Validates that the response is an HTTP response with a successful status code.
    /// - Throws: `URLError.badServerResponse` if the response is not an HTTP response or if the status code indicates a failure.
    func validate() throws {
        guard let httpResponse = self as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
