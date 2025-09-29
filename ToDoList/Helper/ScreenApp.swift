//
//  ScreenApp.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Утилита для получения размеров экрана устройства.
struct ScreenApp {
    /// Размер экрана текущего окна (`UIScreen.bounds`) или `.zero`, если окно не доступно.
    static var screenSize: CGSize {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.size ?? .zero
    }
    
    /// Ширина экрана текущего устройства.
    static var width: CGFloat { screenSize.width }
    
    /// Высота экрана текущего устройства.
    static var height: CGFloat { screenSize.height }
}
