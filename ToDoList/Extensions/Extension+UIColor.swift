//
//  Extension+UIColor.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

extension UIColor {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let activeText = UIColor(resource: .activeToDoText)
    let completedText = UIColor(resource: .completedToDoText)
    let background = UIColor(resource: .background)
    let cardBackground = UIColor(resource: .card)
    let customYellow = UIColor(resource: .customYellow)
    let footerBackground = UIColor(resource: .footer)
    let cardDateText = UIColor(resource: .cardDateText)
    let searchBackground = UIColor(resource: .searchBackground)
    var searchPlaceholder: UIColor {
        cardDateText
    }
}
