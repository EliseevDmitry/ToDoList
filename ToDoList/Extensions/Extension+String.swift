//
//  Extension+String.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

extension String {
    /// Формирует NSAttributedString с учетом статуса выполнения задачи.
    /// Добавляет зачеркивание и изменяет цвет для завершенных задач.
    func styled(
        isCompleted: Bool,
        font: UIFont = UIFont.theme.cardTitle,
        activeTextColor: UIColor = UIColor.theme.activeText,
        strikethroughColor: UIColor = UIColor.theme.cardDateText
    ) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        if isCompleted {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            attributes[.foregroundColor] = strikethroughColor
            attributes[.strikethroughColor] = strikethroughColor
        } else {
            attributes[.strikethroughStyle] = 0
            attributes[.foregroundColor] = activeTextColor
        }
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
