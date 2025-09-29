//
//  SettingsService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

/// Протокол для работы с настройками приложения и определения первого запуска.
/// Позволяет подменять реализацию для тестирования.
protocol ISettingsService {
    /// Проверяет, был ли это первый запуск приложения.
    /// - Returns: `true`, если приложение уже запускалось ранее; иначе `false`.
    func isFirstLaunch() -> Bool
}

/// Сервис для управления настройками приложения и отслеживания состояния первого запуска.
/// Инкапсулирует работу с `UserDefaults` и предоставляет возможность легкого тестирования через внедрение зависимостей.
final class SettingsService: ISettingsService {
    enum StorageKey {
        /// Ключ для хранения информации о том, запускалось ли приложение ранее.
        static let hasLaunchedKey = "hasLaunchedBefore"
    }
    
    private let storage: UserDefaults
    
    /// Инициализация сервиса с возможностью внедрения кастомного хранилища, что упрощает unit-тестирование.
    /// - Parameter storage: экземпляр `UserDefaults`, по умолчанию `.standard`.
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
}

// MARK: - Public functions
extension SettingsService {
    /// Проверяет, был ли это первый запуск приложения.
    ///
    /// В случае первого запуска (`false`) вызывается `setFirstLaunch()` и данные загружаются из сети через `NetworkServices`.
    /// Для последующих запусков (`true`) данные извлекаются из локального хранилища (`CoreData`) через `StorageService`.
    ///
    /// - Returns: `true`, если приложение уже запускалось ранее; `false` в случае первого запуска.
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
    /// Устанавливает флаг первого запуска в хранилище, чтобы последующие обращения возвращали `true`.
    private func setFirstLaunch() {
        storage.set(true, forKey: StorageKey.hasLaunchedKey)
    }
}
