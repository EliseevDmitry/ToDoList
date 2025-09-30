//
//  FooterUIView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

final class FooterUIView: UIView {
    /// Константы, используемые в `FooterUIView`.
    enum Consts {
        static let systemImageName = "square.and.pencil"
        static let hStackLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        static let imageSize: CGFloat = 28
        static let footerTitle = "Задач"
    }
    
    var onAddToDo: (() -> Void)?
    private var count: Int = 0
    
    // MARK: - UI Components
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.directionalLayoutMargins = Consts.hStackLayoutMargins
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = UIColor.theme.footerBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var emptyView: UIView = {
        backgroundColor = .clear
        return $0
    }(UIView())
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = UIColor.theme.activeText
        $0.font = UIFont.theme.footerText
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var toDoAddingButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: Consts.imageSize,
            weight: .regular
        )
        let image = UIImage(
            systemName: Consts.systemImageName,
            withConfiguration: configuration
        )?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.theme.customYellow
        $0.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    // MARK: - Init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupProperties()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Public Functions

extension FooterUIView {
    /// Обновляет количество задач, отображаемое в футере.
    /// - Parameter newCount: Новое количество задач.
    ///
    /// Функция обновляет внутреннее состояние `count` и автоматически обновляет текст `titleLabel`,
    /// чтобы пользователь видел актуальное количество задач в интерфейсе.
    func updateCount(_ newCount: Int) {
        self.count = newCount
        titleLabel.text = "\(count) \(Consts.footerTitle)"
    }
}

// MARK: - @objc Functions

extension FooterUIView {
    /// Обработчик нажатия кнопки добавления новой задачи.
    ///
    /// Вызывает замыкание `onAddToDo`, которое должно быть установлено извне,
    /// чтобы делегировать логику добавления задачи контроллеру или Presenter-у.
    /// Используется @objc для привязки к UIButton через `addTarget`.
    @objc func addNewTodo() {
        onAddToDo?()
    }
}

// MARK: - Private Functions

extension FooterUIView {
    /// Настройка общих свойств view.
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Добавляет все UI-компоненты в иерархию view.
    private func setupViews() {
        [horizontalStackView].forEach {
            addSubview($0)
        }
        [emptyView, titleLabel, toDoAddingButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    /// Настройка AutoLayout constraints для UI компонентов.
    private func setupConstraints() {
        
        // MARK: - horizontalStackView
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // MARK: - toDoAddingButton
        
        NSLayoutConstraint.activate([
            toDoAddingButton.widthAnchor.constraint(equalToConstant: Consts.imageSize),
            toDoAddingButton.heightAnchor.constraint(equalTo: toDoAddingButton.widthAnchor)
        ])
        
        // MARK: - titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: horizontalStackView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor)
        ])
    }
}
