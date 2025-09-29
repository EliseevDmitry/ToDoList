//
//  Extension+Lable.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit
// не работатет
extension UILabel {
    /// Зачёркивает весь текст текущего UILabel, сохраняя существующие атрибуты.
    func applyStrikethrough() {
        guard let currentText = self.attributedText ?? NSAttributedString(string: self.text ?? "") as NSAttributedString? else { return }
        let mutableAttr = NSMutableAttributedString(attributedString: currentText)
        mutableAttr.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: mutableAttr.length)
        )
        self.attributedText = mutableAttr
    }

    /// Убирает зачёркивание, сохраняя остальные атрибуты.
    func removeStrikethrough() {
        guard let currentText = self.attributedText else { return }
        let mutableAttr = NSMutableAttributedString(attributedString: currentText)
        mutableAttr.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: mutableAttr.length))
        self.attributedText = mutableAttr
    }
}
