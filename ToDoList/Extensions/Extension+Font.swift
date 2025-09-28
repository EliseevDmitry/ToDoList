//
//  Extension+Font.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

extension UIFont {
    static let theme = ToDoFonts()
}

struct ToDoFonts {
    let footerText = UIFont.systemFont(ofSize: 11, weight: .regular)
    let cardTitle = UIFont.systemFont(ofSize: 16, weight: .medium)
    let cardContentAndDate = UIFont.systemFont(ofSize: 12, weight: .regular)
    let searchPlaceholder = UIFont.systemFont(ofSize: 17, weight: .regular)
}
