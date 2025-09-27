//
//  FooterUIView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

final class FooterUIView: UIView {
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .leading
        $0.distribution = .fill
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .footer
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var emptyView: UIView = {
        backgroundColor = .clear
        return $0
    }(UIView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = "7 Записей"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textAlignment = .center
        //$0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        //$0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var toDoAddingButton: UIButton = {
           let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
           let image = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?
               .withRenderingMode(.alwaysTemplate)
           $0.setImage(image, for: .normal)
           $0.tintColor = .systemYellow
        $0.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    override init(frame: CGRect = .zero) {
            super.init(frame: frame)
        customInitUIView()
        setupViews()
        setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            customInitUIView()
        }
}

// MARK: - Public Functions
extension FooterUIView {
    func updateCount(_ count: Int) {
            titleLabel.text = "\(count) Записей"
        }
}

extension FooterUIView {
    @objc func addNewTodo() {
        print("Test")
    }
}

// MARK: - Private Functions
extension FooterUIView {
    private func customInitUIView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViews() {
        [horizontalStackView].forEach {
            addSubview($0)
        }
        [emptyView, titleLabel, toDoAddingButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        // Растягиваем горизонтальный стек на весь Footer
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Ограничиваем кнопку справа
            toDoAddingButton.widthAnchor.constraint(equalToConstant: 28),
            toDoAddingButton.heightAnchor.constraint(equalTo: toDoAddingButton.widthAnchor),
           // toDoAddingButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Центрируем titleLabel горизонтально
            titleLabel.centerXAnchor.constraint(equalTo: horizontalStackView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor)
        ])
        
        // Даем emptyView возможность занимать оставшееся пространство слева
        emptyView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        emptyView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Кнопка и titleLabel не будут сжиматься
        toDoAddingButton.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}


