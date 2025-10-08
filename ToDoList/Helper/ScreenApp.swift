//
//  ScreenApp.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Utility for accessing device screen dimensions.
struct ScreenApp {
    /// Screen size of the current window, or `.zero` if unavailable.
    static var screenSize: CGSize {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.size ?? .zero
    }
    
    /// Screen width.
    static var width: CGFloat { screenSize.width }
    
    /// Screen height.
    static var height: CGFloat { screenSize.height }
}
