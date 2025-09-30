//
//  Extension+UIColor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Расширение для удобного доступа к кастомным цветам приложения через `UIColor.theme`.
extension UIColor {
    static let theme = ColorTheme()
}

/// Структура с набором стандартных цветов приложения.
/// Централизует цветовую палитру и упрощает поддержку UI.
struct ColorTheme {
    let activeText = UIColor(resource: .activeToDoText)
    let completedText = UIColor(resource: .completedToDoText)
    let background = UIColor(resource: .background)
    let cardBackground = UIColor(resource: .card)
    let customYellow = UIColor(resource: .customYellow)
    let footerBackground = UIColor(resource: .footer)
    let cardDateText = UIColor(resource: .cardDateText)
    let searchBackground = UIColor(resource: .searchBackground)
    let activeCircle = UIColor(resource: .activeCircle)
    var searchPlaceholder: UIColor {
        cardDateText
    }
}
