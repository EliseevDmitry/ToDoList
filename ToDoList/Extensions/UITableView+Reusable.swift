//
//  Extension+Reusable.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 25.09.2025.
//

import UIKit

/// Marker protocol for reusable table view cells.
protocol Reusable {}

/// All UITableViewCell conform to Reusable by default.
extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    /// Class name as reuseIdentifier.
    static var reuseID: String {
        return String.init(describing: self)
    }
}

// MARK: - UITableView helpers

extension UITableView {
    /// Registers a UITableViewCell subclass using its reuseID.
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }
    
    /// Dequeues a reusable cell with type-safe cast.
    func dequeueCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }
        return cell
    }
}
