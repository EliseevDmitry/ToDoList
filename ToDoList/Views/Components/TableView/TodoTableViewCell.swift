//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    static let reuseId = "ToDoCell"
    
    private var toDoItem: TodoItem? {
        didSet {
            updateUIComponents()
        }
    }
    
    private lazy var containerView: UIView = {
        $0.backgroundColor = UIColor.theme.background
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .leading
        $0.distribution = .fill
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 12, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var circleImageView: UIImageView = {
        $0.image = UIImage(systemName: "checkmark.circle")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .yellow
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .fill
        $0.distribution = .fill
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 12, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.theme.cardTitle
        $0.textColor = UIColor.theme.activeText
        $0.textAlignment = .left
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.theme.cardContentAndDate
        $0.textColor = UIColor.theme.activeText
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .left
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.font = UIFont.theme.cardContentAndDate
        $0.textColor = UIColor.theme.cardDateText
        $0.textAlignment = .left
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodoTableViewCell {
    func update(_ toDoItem: TodoItem) {
        self.toDoItem = toDoItem
    }
    
    func setImage(_ flag: Bool) {
        circleImageView.image = flag ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        circleImageView.tintColor = flag ? UIColor.theme.customYellow : UIColor.theme.activeCircle
        titleLabel.textColor = flag ? UIColor.theme.cardDateText : UIColor.theme.activeText
        descriptionLabel.textColor = flag ? UIColor.theme.cardDateText : UIColor.theme.activeText
       // flag ? titleLabel.applyStrikethrough() : titleLabel.removeStrikethrough()
    }
}

extension TodoTableViewCell {
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            circleImageView.widthAnchor.constraint(equalToConstant: 24),
            circleImageView.heightAnchor.constraint(equalTo: circleImageView.widthAnchor),
        ])
        
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}


extension TodoTableViewCell {
    private func updateUIComponents(){
        guard let item = toDoItem else { return }
        titleLabel.text = item.todo
        descriptionLabel.text = item.content
        dateLabel.text = item.date.getToDoDateFormat
        setImage(item.completed)
    }
}
