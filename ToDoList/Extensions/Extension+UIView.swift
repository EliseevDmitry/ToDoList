//
//  Extension+UIView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

extension UIView {
    /// Константы для создания стандартного заголовка view.
    enum Consts {
        static let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let heightSubview: CGFloat = 36
    }
    
    /// Создает контейнерный view с заданным subview и инсетами, упрощая конфигурацию header для UITableView.
    /// - Parameters:
    ///   - subview: Любой view, который будет добавлен в контейнер
    ///   - insets: Отступы вокруг subview
    ///   - backgroundColor: Цвет фона контейнера
    /// - Returns: UIView, готовый к использованию как заголовок секции
    static func getHeader(
        with subview: UIView,
        insets: UIEdgeInsets = Consts.edgeInsets,
        backgroundColor: UIColor = UIColor.theme.background
    ) -> UIView {
        let container = UIView()
        container.backgroundColor = backgroundColor
        container.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right),
            subview.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            subview.heightAnchor.constraint(equalToConstant: Consts.heightSubview)
        ])
        return container
    }
}
