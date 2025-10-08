//
//  TodoDetailViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Протокол View для экрана деталей задачи.
/// Определяет публичный метод для отображения модели `IToDo`.
protocol ITodoDetailView: AnyObject {
    /// Отображает данные задачи на экране.
    /// - Parameter todo: Экземпляр задачи, реализующий IToDo.
    func display(todo: any IToDo)
}

/// ViewController для экрана деталей задачи.
/// Отвечает за отображение и редактирование информации о задаче.
/// Использует VIPER: взаимодействует с Presenter через `ITodoDetailPresenter`.
final class TodoDetailViewController: UIViewController {
    /// Константы, используемые в `TodoDetailViewController`.
    enum Consts {
        static let leftOffset: CGFloat = 20
        static let rightOffset: CGFloat = -20
        static let titleSpacing: CGFloat = 8
        static let dateSpacing: CGFloat = 16
        static let buttonTitle = "Назад"
        static let buttonImage = "chevron.left"
    }
    
    // MARK: - UI Components
    
    private lazy var titleText: UITextField = {
        $0.font = UIFont.theme.titleFont
        $0.textColor = UIColor.theme.activeText
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextField())
    
    private lazy var dateLabel: UILabel = {
        $0.font = UIFont.theme.cardContentAndDate
        $0.textColor = UIColor.theme.cardDateText
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var contentText: UITextView = {
        $0.font = UIFont.theme.contentText
        $0.textColor = UIColor.theme.activeText
        $0.backgroundColor = UIColor.theme.background
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    
    private var presenter: ITodoDetailPresenter!
    
    // MARK: - Init
    
    init(presenter: ITodoDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCustomBackButton()
        setupProperties()
     
        presenter.viewDidLoad()
    }
}

// MARK: - ITodoDetailView functions

extension TodoDetailViewController: ITodoDetailView {
    /// Отображение задачи на экране.
    /// Обновляет titleText, dateLabel и contentText.
    /// - Parameter todo: Экземпляр IToDo.
    func display(todo: any IToDo) {
        titleText.text = todo.todo
        dateLabel.text = todo.date.getToDoDateFormat
        contentText.text = todo.content
    }
}

// MARK: - Private functions

extension TodoDetailViewController {
    /// Добавляет все UI-компоненты в иерархию view.
    private func setupViews(){
        [titleText, dateLabel, contentText].forEach{
            view.addSubview($0)
        }
    }
    
    /// Настройка AutoLayout constraints для UI компонентов.
    private func setupConstraints() {
        
        // MARK: - TitleText constraints
        
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleText.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Consts.leftOffset
            ),
            titleText.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Consts.rightOffset
            )
        ])
        
        // MARK: - DateLabel constraints
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: titleText.bottomAnchor,
                constant: Consts.titleSpacing
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Consts.leftOffset
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Consts.rightOffset
            )
        ])
        
        // MARK: - ContentText constraints
        
        NSLayoutConstraint.activate([
            contentText.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: Consts.dateSpacing
            ),
            contentText.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Consts.leftOffset
            ),
            contentText.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Consts.rightOffset
            ),
            contentText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Настройка кастомной кнопки "Назад" в navigation bar.
    /// Сохраняет UX и визуальный стиль приложения.
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle(Consts.buttonTitle, for: .normal)
        backButton.setImage(UIImage(systemName: Consts.buttonImage), for: .normal)
        backButton.tintColor = UIColor.theme.customYellow
        backButton.titleLabel?.font = UIFont.theme.searchPlaceholder
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        backButton.semanticContentAttribute = .forceLeftToRight
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    }
    
    /// Настройка общих свойств view.
    /// Цвет фона, largeTitleDisplayMode и др.
    private func setupProperties() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor.theme.background
    }
}

// MARK: - @objc functions

extension TodoDetailViewController {
    /// Обработка нажатия на кастомную кнопку "Назад".
    /// Сначала обновляет данные через presenter, затем выполняет навигацию назад.
    @objc private func customBackButtonTapped() {
        let title = titleText.text ?? ""
        let content = contentText.text ?? ""
        presenter.updateItem(title: title, content: content)
        presenter.didTapBack()
    }
}
