//
//  SettingsService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

/// Interface for managing app settings.
protocol ISettingsService {
    /// Returns `true` if the app has been launched before.
    func isFirstLaunch() -> Bool
}

/// Service responsible for managing app settings and first-launch state.
/// Encapsulates `UserDefaults` and supports dependency injection for testing.
final class SettingsService: ISettingsService {
    enum StorageKey {
        static let hasLaunchedKey = "hasLaunchedBefore"
    }
    
    private let storage: UserDefaults
    
    /// Allows injecting a custom `UserDefaults` instance (useful for unit testing).
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
}

// MARK: - Public functions
extension SettingsService {
    /// Determines whether this is the app’s first launch.
    /// Sets the flag on the first call.
    func isFirstLaunch() -> Bool {
        let flag = storage.bool(forKey: StorageKey.hasLaunchedKey)
        if !flag {
            setFirstLaunch()
            return false
        }
        return true
    }
}

// MARK: - Private functions
extension SettingsService {
    /// Sets the first-launch flag in persistent storage.
    private func setFirstLaunch() {
        storage.set(true, forKey: StorageKey.hasLaunchedKey)
    }
}
