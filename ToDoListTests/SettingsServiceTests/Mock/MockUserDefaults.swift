//
//  MockUserDefaults.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 12.10.2025.
//

import Foundation

/// In-memory mock of `UserDefaults` for unit testing without persisting data.
final class MockUserDefaults: UserDefaults {
    private var storage = [String: Any]()
    
    /// Returns the stored Boolean value for the given key, or `false` if not found.
    override func bool(forKey defaultName: String) -> Bool {
        return storage[defaultName] as? Bool ?? false
    }
    
    /// Stores the given value in memory for the specified key.
    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
}
