//
//  SearchUITextField.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

final class SearchUITextField: UITextField {
    
    enum Consts {
        static let cornerRadius: CGFloat = 10
        static let placeholderText = "Search"
        static let imageSystemName = "magnifyingglass"
        static let imageButtonSystemName = "xmark.circle.fill"
    }
    
    private lazy var searchImageView: UIImageView = {
        let searchImage = UIImage(systemName: Consts.imageSystemName)?
            .withTintColor(
                UIColor.theme.searchPlaceholder,
                renderingMode: .alwaysOriginal
            )
        $0.frame = CGRect(x: 0, y: 0, width: 20, height: 22)
        $0.image = searchImage
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var clearButton: UIButton = {
        let clearImage = UIImage(systemName: Consts.imageButtonSystemName)?
            .withTintColor(
                UIColor.theme.searchPlaceholder,
                renderingMode: .alwaysOriginal
            )
        $0.setImage(clearImage, for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 17, height: 22)
        $0.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInitUITextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
        override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.leftViewRect(forBounds: bounds)
            rect.origin.x += 3
            return rect
        }
        override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.rightViewRect(forBounds: bounds)
            rect.origin.x -= 3
            return rect
        }
    
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.textRect(forBounds: bounds)
            rect.origin.x += 3
            return rect
        }
}

extension SearchUITextField {
    @objc private func clearText() {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}


extension SearchUITextField {
    private func customInitUITextField() {
        textColor = UIColor.theme.activeText
        backgroundColor = UIColor.theme.searchBackground
        borderStyle = .none
        layer.cornerRadius = Consts.cornerRadius
        clipsToBounds = true
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.theme.searchPlaceholder,
            .font: UIFont.theme.searchPlaceholder
        ]
        attributedPlaceholder = NSAttributedString(
            string: Consts.placeholderText,
            attributes: placeholderAttributes
        )
        leftView = searchImageView
        leftViewMode = .always
        rightView = clearButton
        rightViewMode = .whileEditing
    }
}
