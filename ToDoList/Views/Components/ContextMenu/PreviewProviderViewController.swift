//
//  PreviewProviderViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

final class PreviewProviderViewController: UIViewController {
    
    private let entity: (any IToDo)?
    
    init(entity: (any IToDo)?) {
        self.entity = entity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Consts {
        static let vStackLayoutMargins = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        static let vStackSpacing: CGFloat = 6
        static let imageSize: CGFloat = 28
        static let footerTitle = "Задач"
        static let cornerRadius: CGFloat = 12
        static let preferredContentSize = CGSize(
            width: ScreenApp.width - 40,
            height: 106
        )
    }
    
    // MARK: - UI Components
    private lazy var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = Consts.vStackSpacing
        $0.directionalLayoutMargins = Consts.vStackLayoutMargins
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = UIColor.theme.footerBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = entity?.todo
        $0.textColor = UIColor.theme.activeText
        $0.font = UIFont.theme.cardTitle
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var contentLabel: UILabel = {
        $0.text = entity?.content
        $0.textColor = UIColor.theme.activeText
        $0.font = UIFont.theme.cardContentAndDate
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.text = entity?.date.getToDoDateFormat
        $0.textColor = UIColor.theme.cardDateText
        $0.font = UIFont.theme.cardContentAndDate
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInitPreviewProvider()
        setupViews()
        setupConstraints()
    }
}

// MARK: - Private functions
extension PreviewProviderViewController {
    /// Конфигурирует внешний вид и базовые свойства UIViewController.
    private func customInitPreviewProvider() {
        view.backgroundColor = UIColor.theme.cardBackground
        view.layer.cornerRadius = Consts.cornerRadius
        view.layer.masksToBounds = true
        preferredContentSize = Consts.preferredContentSize
    }
    
    /// Строит иерархию view (`subviews`) для контроллера.
    private func setupViews() {
        [verticalStackView].forEach{
            view.addSubview($0)
        }
        
        [titleLabel, contentLabel, dateLabel].forEach{
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    /// Настраивает и активирует констрейнты для всех подвидов контроллера.
    private func setupConstraints() {
        // MARK: - verticalStackView
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
