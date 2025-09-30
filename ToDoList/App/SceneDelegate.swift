//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

/// Глобальный DI-контейнер для управления зависимостями всего приложения.
let di = Di()

/// Создаем UIWindow, назначаем корневой UINavigationController с TasksViewController и отображаем окно.
/// Устанавливаем фон и сохраняем ссылку на окно для жизненного цикла сцены.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: winScene)
        let rootVC = di.screenFactory.makeTasksViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.theme.footerBackground
        self.window = window
    }
}
