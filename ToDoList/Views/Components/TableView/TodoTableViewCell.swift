//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    /// Константы, используемые в `TodoTableViewCell`.
    /// Вынесены в enum для централизованного хранения значений, связанных с UI
    enum Consts {
        static let hStackSpacing: CGFloat = 8
        static let hStackaLyoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        static let completedImageName = "checkmark.circle"
        static let activeImageName = "circle"
        static let vStackSpacing: CGFloat = 6
        static let vStackaLyoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        static let contentLabelLines = 2
        static let circleWH: CGFloat = 24
    }
    
    /// Уникальный идентификатор для повторного использования ячейки `TodoTableViewCell` в таблице (`UITableView`).
    static let reuseId = "ToDoCell"
    
    /// Модель данных текущей задачи, отображаемой в ячейке.
    /// При изменении автоматически обновляет UI-компоненты через `updateUIComponents()`.
    private var toDoItem: TodoItem? {
        didSet {
            updateUIComponents()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var containerView: UIView = {
        $0.backgroundColor = UIColor.theme.background
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Consts.hStackSpacing
        $0.alignment = .leading
        $0.distribution = .fill
        $0.directionalLayoutMargins = Consts.hStackaLyoutMargins
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var circleImageView: UIImageView = {
        $0.image = UIImage(systemName: Consts.completedImageName)
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Consts.vStackSpacing
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.directionalLayoutMargins = Consts.vStackaLyoutMargins
        $0.isLayoutMarginsRelativeArrangement = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.theme.cardTitle
        $0.textColor = UIColor.theme.activeText
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.theme.cardContentAndDate
        $0.textColor = UIColor.theme.activeText
        $0.numberOfLines = Consts.contentLabelLines
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.font = UIFont.theme.cardContentAndDate
        $0.textColor = UIColor.theme.cardDateText
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public functions

extension TodoTableViewCell {
    /// Обновляет содержимое ячейки новым элементом `TodoItem`.
    /// Триггерит перерисовку UI-компонентов через `updateUIComponents()`.
    func update(_ toDoItem: TodoItem) {
        self.toDoItem = toDoItem
    }
}

// MARK: - Private functions

extension TodoTableViewCell {
    /// Конфигурирует иерархию вью: добавляет сабвью и настраивает stack view.
    /// Отвечает за структурное размещение UI-компонентов внутри ячейки.
    private func setupViews(){
        [containerView].forEach {
            contentView.addSubview($0)
        }
        [horizontalStackView].forEach {
            containerView.addSubview($0)
        }
        
        [circleImageView, verticalStackView].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
        [titleLabel, descriptionLabel, dateLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    /// Активирует Auto Layout констрейнты для всех UI-элементов.
    /// Обеспечивает корректное позиционирование и размеры внутри `UITableViewCell`.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // MARK: - ContainerView constraints
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // MARK: - HorizontalStackView constraints
            
            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // MARK: - CircleImageView constraints
            
            circleImageView.widthAnchor.constraint(equalToConstant: Consts.circleWH),
            circleImageView.heightAnchor.constraint(equalTo: circleImageView.widthAnchor),
            circleImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            // MARK: - VerticalStackView constraints
            
            verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.layoutMarginsGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: horizontalStackView.layoutMarginsGuide.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: horizontalStackView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    /// Применяет дополнительные свойства к ячейке.
    /// В текущей реализации отключает выделение (`selectionStyle = .none`).
    private func setupProperties() {
        selectionStyle = .none
    }
    
    /// Перезаполняет UI-компоненты данными из `toDoItem`.
    /// Вызывается при изменении модели для актуализации текста и стиля.
    private func updateUIComponents(){
        guard let item = toDoItem else { return }
        titleLabel.text = item.todo
        descriptionLabel.text = item.content
        dateLabel.text = item.date.getToDoDateFormat
        setImage(item.completed)
    }
    
    /// Устанавливает состояние иконки и стилей текста в зависимости от `completed`.
    /// Использует тему приложения и строковое расширение для атрибутированного текста.
    /// Атрибутированный текст устанавливается через экстеншн `String.styled(isCompleted:)`,
    /// что обеспечивает корректное применение зачеркивания и цвета текста.
    private func setImage(_ flag: Bool) {
        circleImageView.image = flag ? UIImage(systemName: Consts.completedImageName) : UIImage(systemName: Consts.activeImageName)
        circleImageView.tintColor = flag ? UIColor.theme.customYellow : UIColor.theme.activeCircle
        titleLabel.textColor = flag ? UIColor.theme.cardDateText : UIColor.theme.activeText
        descriptionLabel.textColor = flag ? UIColor.theme.cardDateText : UIColor.theme.activeText
        //через расширение String
        titleLabel.attributedText = flag ? titleLabel.text?.styled(isCompleted: true) ?? .none : titleLabel.text?.styled(isCompleted: false) ?? .none
    }
}
