//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

final class TasksViewController: UIViewController {
    
    /// Константы, используемые в `TasksViewController`.
    /// Вынесены в enum для централизованного хранения значений, связанных с UI и фиксированным ToDo-объектом.
    enum Consts {
        static let navTitle = "Задачи"
        static let footerHeight: CGFloat = 49
        static let heightSearchView: CGFloat = 52
        static let newFixedToDoItem = TodoItem(
            id: UUID(),
            todo: "Новая заметка",
            content: "Отредактируй заметку",
            completed: false,
            date: .now
        )
    }
    
    // MARK: - UI Components
    
    /// Таблица для отображения списка задач.
    /// Кастомный subclass, инкапсулирующий базовые настройки.
    private lazy var tableView = TodoTableView()
    
    /// Поисковое поле для фильтрации заметок.
    private lazy var searchView: SearchUITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchUITextField())
    
    /// Фоновая вью, отображаемая при пустом списке или в режиме поиска.
    private lazy var backgroundView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.theme.background
        return $0
    }(UIView())
    
    /// Нижняя панель (footer), показывающая количество задач и позволяющая добавить новую.
    /// Использует замыкание `onAddToDo` для делегирования действия презентеру.
    private lazy var footer: FooterUIView = {
        $0.updateCount(presenter?.numberOfTodos ?? 0)
        $0.onAddToDo = { self.presenter.addNewFixedItem(item: Consts.newFixedToDoItem) }
        return $0
    }(FooterUIView())
    
    /// Презентер, реализующий бизнес-логику списка задач в рамках VIPER-архитектуры.
    private var presenter: ITodoListPresenter!
    
    // MARK: - Init
    
    init(presenter: ITodoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationItemTitle()
        setupViews()
        setupConstraints()
        setupTableView()
        setupDismissKeyboardGesture()
        presenter.loadTodos()
        setupSearchHandler()
    }
    
    /// Обновляет размер `backgroundView` при изменении размеров таблицы.
    /// Вызывается системой автоматически при layout-pass.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.backgroundView?.frame = tableView.bounds
    }
}

// MARK: - ITodoListView Implementation

extension TasksViewController: ITodoListView {
    /// Перезагружает таблицу задач и синхронизирует состояние футера с актуальным числом задач.
    func reloadData() {
        tableView.reloadData()
        footer.updateCount(presenter.numberOfTodos)
    }
    
    /// Отображает ошибку пользователю через `UIAlertController`.
    /// Используется при ошибках, возникающих в сетевых или локальных сервисах.
    /// - Parameter message: Локализованный текст ошибки.
    func showError(_ message: String) {
        ToDoAlertError.present(on: self, message: message)
    }
}


// MARK: - UITableViewDataSource

extension TasksViewController: UITableViewDataSource {
    /// Возвращает количество элементов в секции таблицы.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTodos
    }
    
    /// Конфигурирует и возвращает кастомную ячейку `TodoTableViewCell`.
    /// Использует протокол `Reusable` для безопасного dequeuing.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todo = presenter.todo(at: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueCell(indexPath) as TodoTableViewCell
        cell.update(todo)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TasksViewController: UITableViewDelegate {
    /// Возвращает конфигурацию контекстного меню для элемента.
    /// Логика вынесена в `ToDoContextMenu` и `UIMenu.makeToDoActionMenu` для повышения читаемости и переиспользуемости.
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        ToDoContextMenu.makeMenu(for: indexPath, entity: presenter.todo(at: indexPath.row)) { action in
            switch action {
            case .edit: print("Edit tapped at row \(indexPath.row)")
            case .share: self.presenter.completedToDo(at: indexPath.row)
            case .delete: self.presenter.deleteToDo(at: indexPath.row)
            }
        }
    }
    
    /// Кастомизирует превью при долгом тапе (анимация появления).
    /// Делегирует создание `UITargetedPreview` в extension `UITableView`, что упрощает поддержку и повторное использование.
    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        tableView.makeTargetedPreview(for: configuration)
    }
    
    /// Кастомизирует превью при закрытии контекстного меню (анимация скрытия).
    /// Реализация вынесена в extension `UITableView` для централизованного управления логикой.
    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        tableView.makeTargetedPreview(for: configuration)
    }
    
    /// Возвращает кастомный Header для первой секции.
    /// Используется для закрепления строки поиска (sticky-header).
    /// Логика вынесена в extension `UIView.getHeader(with:)` для изоляции UI-конструкции.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? UIView.getHeader(with: searchView) : nil
    }
    
    /// Возвращает высоту Header-а для секции.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? Consts.heightSearchView : 0
    }
}

// MARK: - Private functions

extension TasksViewController {
    /// Настраивает делегаты и источники данных для таблицы задач.
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Настраивает заголовок навигационного бара.
    /// Устанавливает `navigationItem.title` и применяет кастомный стиль отображения через `UINavigationController.applyBlackLargeTitleStyle()`.
    private func createNavigationItemTitle() {
        navigationItem.title = Consts.navTitle
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.applyBlackLargeTitleStyle()
    }
    
    /// Строит иерархию view (`subviews`) для контроллера.
    private func setupViews() {
        [backgroundView, tableView, footer].forEach{
            view.addSubview($0)
        }
    }
    
    /// Конфигурирует AutoLayout-констрейнты для всех subviews.
    private func setupConstraints() {
        
        // MARK: - BackgroundView constraints
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: footer.topAnchor)
        ])
        
        // MARK: - TableView constraints
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
        ])
        
        // MARK: - Footer constraints
        
        NSLayoutConstraint.activate([
            footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: Consts.footerHeight)
        ])
    }
    
    /// Настраивает замыкание для поиска.
    /// Обеспечивает реакцию на ввод текста в `searchView` и делегирует поиск презентеру.
    private func setupSearchHandler() {
        searchView.onTextChanged = { [weak self] query in
            self?.presenter.searchToDoItems(query: query)
        }
    }
}

// MARK: - Keyboard handling

extension TasksViewController {
    /// Добавляет tap-gesture для скрытия клавиатуры по нажатию вне текстовых полей.
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Закрывает клавиатуру.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
