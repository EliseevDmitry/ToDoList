//
//  ToDoAlertError.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

/// Handles errors and displays standard alerts for `ToDo` tasks.
enum ToDoAlertError {
    /// Constants used in `ToDoAlertError`.
    enum Consts {
        static let title = "Error"
        static let buttonTitle = "OK"
    }
    
    /// Shows a standard alert with a title, message, and confirmation button.
    ///
    /// - Parameters:
    ///   - viewController: Controller to present the alert on.
    ///   - title: Alert title (default `Consts.title`).
    ///   - message: Alert message.
    ///   - buttonTitle: Confirmation button text (default `Consts.buttonTitle`).
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
