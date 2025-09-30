//
//  Extension+UIFont.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Расширение для удобного доступа к кастомным шрифтам приложения через `UIFont.theme`.
extension UIFont {
    static let theme = ToDoFonts()
}

/// Структура с набором стандартных шрифтов приложения.
/// Позволяет централизованно управлять типографикой и унифицировать стиль UI.
struct ToDoFonts {
    let footerText = UIFont.systemFont(ofSize: 11, weight: .regular)
    let cardTitle = UIFont.systemFont(ofSize: 16, weight: .medium)
    let cardContentAndDate = UIFont.systemFont(ofSize: 12, weight: .regular)
    let searchPlaceholder = UIFont.systemFont(ofSize: 17, weight: .regular)
    let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    let contentText = UIFont.systemFont(ofSize: 16, weight: .regular)
}
