//
//  ToDoAlertError.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

enum ToDoAlertError {
    
    enum Consts {
        static let title = "Ошибка"
        static let buttonTitle = "OK"
    }
    
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
