//
//  TodoTableView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import UIKit

final class TodoTableView: UITableView {
    /// Constants used in `TodoTableView`.
    /// Centralized appearance and behavior configuration.
    enum Consts {
        static let topPadding: CGFloat = 0
        static let rowHeight: CGFloat = 90
        static let separatorInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }
    
    // MARK: - Lifecycle
    
    /// Initializes the table view with a configurable style.
    /// Sets up default appearance and behavior via `setupProperties()`.
    override init(
        frame: CGRect = .zero,
        style: UITableView.Style = .plain
    ) {
        super.init(frame: frame, style: style)
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions

extension TodoTableView {
    /// Configures key table view properties: layout, row height, cell registration, and separators.
    /// For iOS 15+, removes section header top padding for consistent layout across iOS versions.
    private func setupProperties() {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = Consts.topPadding
        }
        registerCell(TodoTableViewCell.self)
        backgroundColor = .clear
        estimatedRowHeight = Consts.rowHeight
        rowHeight = UITableView.automaticDimension
        separatorStyle = .singleLine
        separatorColor = .lightGray
        separatorInset = Consts.separatorInset
        translatesAutoresizingMaskIntoConstraints = false
    }
}
