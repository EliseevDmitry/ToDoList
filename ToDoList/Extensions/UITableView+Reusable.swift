//
//  Extension+Reusable.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 25.09.2025.
//

import UIKit

/// Протокол для идентификации повторно используемых ячеек таблицы.
protocol Reusable {}

/// Все UITableViewCell автоматически соответствуют Reusable.
extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    /// Возвращает строку с названием класса для reuseIdentifier.
    static var reuseID: String {
        return String.init(describing: self)
    }
}

// MARK: - UITableView helper extensions

extension UITableView {
    /// Регистрация ячейки по классу с использованием reuseID.
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }
    
    /// Декодирование ячейки по IndexPath с безопасным приведением типа.
    func dequeueCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }
        return cell
    }
}
