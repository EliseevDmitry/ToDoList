//
//  SettingsService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

protocol ISettingsService {
    func isFirstLaunch() -> Bool
}

final class SettingsService: ISettingsService {
    enum StorageKey {
        static let hasLaunchedKey = "hasLaunchedBefore"
    }
    
    private let storage: UserDefaults
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
}

// MARK: - Public functions
extension SettingsService {
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
    private func setFirstLaunch() {
        storage.set(true, forKey: StorageKey.hasLaunchedKey)
    }
}
