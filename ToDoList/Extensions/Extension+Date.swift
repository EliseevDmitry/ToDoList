//
//  Extension+Date.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import Foundation

extension Date {
    /// Shared DateFormatter for task dates ("dd/MM/yyyy").
    private static let toDoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// Returns date string in "dd/MM/yyyy" format using shared formatter.
    var getToDoDateFormat: String {
        return Date.toDoDate.string(from: self)
    }
}
