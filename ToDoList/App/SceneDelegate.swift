//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

/// Global DI container for managing app dependencies.
/// Used here for VIPER architecture demonstration and UI layout compliance.
let di = Di()

/// Sets up the main window with a root UINavigationController hosting `TasksViewController`.
/// Configures window background and keeps a strong reference for the scene lifecycle.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: winScene)
        guard let rootVC = di.screenFactory.makeToDoList() as? UIViewController else { return }
        let navigationController = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.theme.footerBackground
        self.window = window
    }
}
