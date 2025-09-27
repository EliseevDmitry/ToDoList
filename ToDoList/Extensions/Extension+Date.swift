//
//  Extension+Date.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import Foundation

//создаем расширение Date - для однократного создания DateFormatter() - так как опреация дорогостоящая и при большом количестве запесей в таблице, создавать ее под каждую запись нецелесообразно
extension Date {
    private static let toDoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var getToDoDateFormat: String {
        return Date.toDoDate.string(from: self)
    }
}
