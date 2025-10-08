//
//  Extension+UIColor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Provides access to app color palette via `UIColor.theme`.
extension UIColor {
    static let theme = ColorTheme()
}

/// Centralized color palette for consistent UI styling.
struct ColorTheme {
    let activeCircle = UIColor(resource: .activeCircle)
    let activeText = UIColor(resource: .activeToDoText)
    let background = UIColor(resource: .background)
    let cardBackground = UIColor(resource: .card)
    let cardDateText = UIColor(resource: .cardDateText)
    let completedText = UIColor(resource: .completedToDoText)
    let customYellow = UIColor(resource: .customYellow)
    let footerBackground = UIColor(resource: .footer)
    let searchBackground = UIColor(resource: .searchBackground)
    var searchPlaceholder: UIColor {
        cardDateText
    }
}
