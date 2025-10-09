//
//  FooterUIView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 27.09.2025.
//

import UIKit

final class FooterUIView: UIView {
    /// UI constants for layout and appearance.
    enum Consts {
        static let systemImageName = "square.and.pencil"
        static let hStackLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        static let imageSize: CGFloat = 28
        static let footerTitle = "Tasks"
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
    /// Updates the task count displayed in the footer.
    /// Automatically refreshes `titleLabel` to reflect the current count.
    func updateCount(_ newCount: Int) {
        self.count = newCount
        titleLabel.text = "\(count) \(Consts.footerTitle)"
    }
}

// MARK: - @objc Functions

extension FooterUIView {
    /// Handles the add-task button tap.
    /// Calls `onAddToDo` closure to delegate task creation externally.
    @objc func addNewTodo() {
        onAddToDo?()
    }
}

// MARK: - Private Functions

extension FooterUIView {
    /// Configures general view properties.
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Adds all UI components to the view hierarchy.
    private func setupViews() {
        [horizontalStackView].forEach {
            addSubview($0)
        }
        [emptyView, titleLabel, toDoAddingButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    
    /// Sets up Auto Layout constraints for UI components.
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
