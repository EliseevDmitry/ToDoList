//
//  SearchUITextField.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

final class SearchUITextField: UITextField {
    /// Константы, используемые в `SearchUITextField`.
    enum Consts {
        static let cornerRadius: CGFloat = 10
        static let placeholderText = "Search"
        static let imageSystemName = "magnifyingglass"
        static let imageButtonSystemName = "xmark.circle.fill"
        static let leftPadding: CGFloat = 6
        static let rightPadding: CGFloat = 3
        static let iconSize: CGSize = CGSize(width: 20, height: 22)
        static let buttonSize: CGSize = CGSize(width: 20, height: 22)
    }
    
    var onTextChanged: ((String) -> Void)?
    
    // MARK: - Views
    
    private lazy var searchImageViewContainer: UIView = {
        let imageView = UIImageView()
        let searchImage = UIImage(systemName: Consts.imageSystemName)?
            .withTintColor(UIColor.theme.searchPlaceholder, renderingMode: .alwaysOriginal)
        imageView.image = searchImage
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            origin: CGPoint(x: Consts.leftPadding, y: 0),
            size: Consts.iconSize
        )
        let containerWidth = Consts.iconSize.width + Consts.leftPadding * 2
        let container = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: containerWidth,
                height: Consts.iconSize.height
            )
        )
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
        let container = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: containerWidth,
                height: Consts.buttonSize.height
            )
        )
        button.center.y = container.bounds.midY
        container.addSubview(button)
        return container
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProperties()
    }
}

// MARK: - Actions

extension SearchUITextField {
    /// Очищает текстовое поле и вызывает callback при изменении текста.
    /// Обновляет видимость кнопки очистки справа.
    @objc private func clearText() {
        self.text = ""
        onTextChanged?("")
        sendActions(for: .editingChanged)
        updateClearButtonVisibility()
    }
    
    /// Вызывается при изменении текста пользователем.
    /// Обновляет видимость кнопки очистки и уведомляет через callback.
    @objc private func textDidChange() {
        updateClearButtonVisibility()
        onTextChanged?(self.text ?? "")
    }
}

// MARK: - Private functions

extension SearchUITextField {
    /// Настраивает внешний вид и поведение текстового поля.
    /// Устанавливает плейсхолдер, цвета, скругления и вью для иконок.
    private func setupProperties() {
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
        rightViewMode = .never
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    /// Обновляет видимость кнопки очистки в зависимости от текста.
    /// Показывает кнопку, если текст не пустой, скрывает иначе.
    private func updateClearButtonVisibility() {
        rightViewMode = (text?.isEmpty == false) ? .always : .never
    }
}
