//
//  Extension+UINavigationController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Расширение UINavigationController для применения кастомного стиля с черным фоном.
/// Настраивает Large Title с белым текстом и скрывает стандартный title.
extension UINavigationController {
    func applyBlackLargeTitleStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.clear
                ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.prefersLargeTitles = true
    }
}
