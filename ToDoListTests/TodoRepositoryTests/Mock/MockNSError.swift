//
//  MockNSError.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 23.10.2025.
//

import Foundation

/// Mocked `NSError` cases for simulating failures in tests.
/// Used to emulate network and storage layer errors.
enum MockNSError: Error {
    case network
    case storageWrite
    case storageRead
    
    /// Returns a corresponding `NSError` instance for each mock error case.
    var nsError: NSError {
        switch self {
        case .network:
            return NSError(domain: "network", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Simulated network error"
            ])
        case .storageWrite:
            return NSError(domain: "storage", code: -2, userInfo: [
                NSLocalizedDescriptionKey: "Simulated storage write error"
            ])
        case .storageRead:
            return NSError(domain: "storage", code: -3, userInfo: [
                NSLocalizedDescriptionKey: "Simulated storage read error"
            ])
        }
    }
}
