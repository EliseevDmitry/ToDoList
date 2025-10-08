//
//  Extension+UIFont.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Provides access to app-specific fonts via `UIFont.theme`.
extension UIFont {
    static let theme = ToDoFonts()
}

/// Centralized font palette for consistent app typography.
struct ToDoFonts {
    let cardContentAndDate = UIFont.systemFont(ofSize: 12, weight: .regular)
    let cardTitle = UIFont.systemFont(ofSize: 16, weight: .medium)
    let contentText = UIFont.systemFont(ofSize: 16, weight: .regular)
    let footerText = UIFont.systemFont(ofSize: 11, weight: .regular)
    let searchPlaceholder = UIFont.systemFont(ofSize: 17, weight: .regular)
    let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
}
