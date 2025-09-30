//
//  Extension+Date.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import Foundation

extension Date {
    /// Статический `DateFormatter` для форматирования даты задач.
    /// Создается один раз, чтобы избежать затрат на многократное создание при больших списках.
    private static let toDoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// Преобразует `Date` в строку в формате "dd/MM/yyyy" для отображения в UI.
    /// Использует статический `DateFormatter` для оптимизации производительности.
    var getToDoDateFormat: String {
        return Date.toDoDate.string(from: self)
    }
}
