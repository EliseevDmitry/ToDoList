//
//  SearchUITextField.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//
/*
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
        rightViewMode = .always
    }
}
*/

import UIKit

final class SearchUITextField: UITextField {
    
    enum Consts {
        static let cornerRadius: CGFloat = 10
        static let placeholderText = "Search"
        static let imageSystemName = "magnifyingglass"
        static let imageButtonSystemName = "xmark.circle.fill"
        static let leftPadding: CGFloat = 6      // отступ для иконки поиска
        static let rightPadding: CGFloat = 30    // отступ для кнопки очистки
        static let iconSize: CGSize = CGSize(width: 20, height: 22)
        static let buttonSize: CGSize = CGSize(width: 17, height: 22)
    }
    var onTextChanged: ((String) -> Void)?
    
    // MARK: - Views
    
    private lazy var searchImageViewContainer: UIView = {
        let imageView = UIImageView()
        let searchImage = UIImage(systemName: Consts.imageSystemName)?
            .withTintColor(UIColor.theme.searchPlaceholder, renderingMode: .alwaysOriginal)
        imageView.image = searchImage
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(origin: CGPoint(x: Consts.leftPadding, y: 0),
                                 size: Consts.iconSize)
        
        let containerWidth = Consts.iconSize.width + Consts.leftPadding * 2
        let container = UIView(frame: CGRect(x: 0, y: 0,
                                             width: containerWidth,
                                             height: Consts.iconSize.height))
        container.addSubview(imageView)
        return container
    }()
    
    private lazy var clearButtonContainer: UIView = {
        let button = UIButton(type: .custom)
        let clearImage = UIImage(systemName: Consts.imageButtonSystemName)?
            .withTintColor(UIColor.theme.searchPlaceholder, renderingMode: .alwaysOriginal)
        button.setImage(clearImage, for: .normal)
        button.frame = CGRect(origin: .zero, size: Consts.buttonSize)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        let containerWidth = Consts.buttonSize.width + Consts.rightPadding
        let container = UIView(frame: CGRect(x: 0, y: 0,
                                             width: containerWidth,
                                             height: Consts.buttonSize.height))
        
        // размещаем кнопку в начале контейнера
        button.center.y = container.bounds.midY
        container.addSubview(button)
        return container
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInitUITextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInitUITextField()
    }
}

// MARK: - Actions

extension SearchUITextField {
    @objc private func clearText() {
        self.text = ""
        sendActions(for: .editingChanged)
        updateClearButtonVisibility()
    }
    
    @objc private func textDidChange() {
        updateClearButtonVisibility()
        onTextChanged?(self.text ?? "")
    }
    
    private func updateClearButtonVisibility() {
        rightViewMode = (text?.isEmpty == false) ? .always : .never
    }
}

// MARK: - Setup

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
        
        leftView = searchImageViewContainer
        leftViewMode = .always
        rightView = clearButtonContainer
        rightViewMode = .never // скрыта по умолчанию
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}


