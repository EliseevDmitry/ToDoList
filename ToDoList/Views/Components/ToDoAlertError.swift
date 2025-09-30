//
//  ToDoAlertError.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

/// Обработчик ошибок и отображения стандартных alert для задач `ToDo`.
enum ToDoAlertError {
    /// Константы, используемые в `ToDoAlertError`.
    enum Consts {
        static let title = "Ошибка"
        static let buttonTitle = "OK"
    }
    
    /// Отображает UIAlertController с указанным заголовком и сообщением.
    ///
    /// - Parameters:
    ///   - viewController: Контроллер, на котором будет показан alert.
    ///   - title: Заголовок alert, по умолчанию `Consts.title`.
    ///   - message: Сообщение alert.
    ///   - buttonTitle: Текст кнопки подтверждения, по умолчанию `Consts.buttonTitle`.
    static func present(
        on viewController: UIViewController,
        title: String = Consts.title,
        message: String,
        buttonTitle: String = Consts.buttonTitle
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: buttonTitle,
                style: .default
            )
        )
        viewController.present(alert, animated: true)
    }
}
