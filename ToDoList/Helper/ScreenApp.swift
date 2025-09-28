//
//  ScreenApp.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

struct ScreenApp {
    static var screenSize: CGSize {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.size ?? .zero
    }
    
    static var width: CGFloat { screenSize.width }
    static var height: CGFloat { screenSize.height }
}
