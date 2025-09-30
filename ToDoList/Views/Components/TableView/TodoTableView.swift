//
//  TodoTableView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import UIKit

final class TodoTableView: UITableView {
    /// Константы, используемые в `TodoTableView`.
    /// Централизованное хранение настроек внешнего вида и поведения таблицы.
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
    
    /// Инициализатор таблицы с возможностью выбора стиля.
    /// Выполняет настройку базовых свойств через `setupProperties()`.
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
    /// Настраивает основные свойства таблицы: внешний вид, высоту строк, регистрация ячеек и разделителей.
    /// Для iOS 15+ обнуляет верхний padding заголовка секции для согласованного отображения с предыдущими версиями iOS.
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
