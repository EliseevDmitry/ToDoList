//
//  ViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

final class TasksViewController: UIViewController {
    
    enum Consts {
        static let navTitle = "Задачи"
        static let footerHeight: CGFloat = 49
        static let heightSearchView: CGFloat = 52
    }
     
    private lazy var tableView = TodoTableView()
    private lazy var searchView: SearchUITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchUITextField())
    private lazy var footer: FooterUIView = {
        $0.updateCount(presenter?.numberOfTodos ?? 0)
        return $0
    }(FooterUIView())
    private var presenter: ITodoListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        
        createNavigationItemTitle()
        setupViews()
        setupConstraints()
        setupTableView()
        setupDismissKeyboardGesture()
        
        //viper
        let interactor = TodoListInteractor()
        presenter = TodoListPresenter(interactor: interactor, view: self)
        presenter.loadTodos()
    }
    
}

// MARK: - ITodoListView Implementation
extension TasksViewController: ITodoListView {
    /// Перезагружает данные таблицы и обновляет счетчик задач в футере.
    /// Вызывается после получения актуального списка задач от презентера.
    func reloadData() {
        tableView.reloadData()
        footer.updateCount(presenter.numberOfTodos)
    }
    
    /// Отображает ошибку пользователю.
        /// В приложении используются сетевые и локальные сервисы, которые через GCD с @escaping возвращают `Result<T, Error>`.
        /// В случае возникновения ошибки она обрабатывается и выводится пользователю в виде UIAlertController.
        /// - Parameter message: Текст ошибки для отображения.
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
    
    /// Создает и конфигурирует кастомную ячейку, зарегистрированную через протокол Reusable, для конкретного индекса в таблице.
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

    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        tableView.makeTargetedPreview(for: configuration)
    }
    
    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return tableView.makeTargetedPreview(for: configuration)
    }
    
    //создаем Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? UIView.getHeader(with: searchView) : nil
    }
    
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
        [tableView, footer].forEach{
            view.addSubview($0)
        }
    }

    /// Настраивает и активирует констрейнты для всех подвидов контроллера.
    private func setupConstraints() {
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
}


extension TasksViewController {
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
