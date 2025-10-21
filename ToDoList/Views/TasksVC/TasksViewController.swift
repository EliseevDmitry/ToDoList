//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

/// Protocol for Presenter → View communication in VIPER.
/// Defines basic methods for UI updates and error handling in TasksViewController.
protocol ITodoListView: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func clearSearch()
    func updateFooterCount(_ count: Int)
}

final class TasksViewController: UIViewController {
    
    /// Constants used in `TasksViewController`.
    /// Centralized storage for UI-related values and default ToDo item.
    enum Consts {
        static let footerInitCount = 0
        static let navTitle = "Tasks"
        static let footerHeight: CGFloat = 49
        static let heightSearchView: CGFloat = 52
        static func newFixedToDoItem() -> TodoItem {
            TodoItem(
                todo: "New task",
                content:
    """
    This is your new note. You can use it to jot down thoughts, ideas, and tasks. Edit the text, add details, and use it to plan your day or store important ideas.
    """
                ,
                completed: false,
                date: .now
            )
        }
    }
    
    // MARK: - UI Components
    
    /// Table view displaying the list of tasks.
    /// Custom subclass encapsulating basic setup.
    private lazy var tableView = TodoTableView()
    
    /// Search field for filtering notes.
    private lazy var searchView: SearchUITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchUITextField())
    
    /// Background view shown when the list is empty or during search.
    private lazy var backgroundView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.theme.background
        return $0
    }(UIView())
    
    /// Footer view showing task count and providing an add button.
    /// Uses `onAddToDo` closure to delegate actions to the presenter.
    private lazy var footer: FooterUIView = {
        $0.onAddToDo = { [weak self] in
            self?.presenter.didTapAddNewItem()
        }
        return $0
    }(FooterUIView())
    
    /// Presenter handling business logic for the task list in VIPER.
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
    
    /// Adjusts the backgroundView frame when the table view layout changes.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.backgroundView?.frame = tableView.bounds
    }
}

// MARK: - ITodoListView Implementation

extension TasksViewController: ITodoListView {
    
    /// Reloads the table view and updates the footer with the current task count.
    func reloadData() {
        tableView.reloadData()
    }
    
    /// Displays an error alert to the user.
    /// - Parameter message: Localized error message.
    func showError(_ message: String) {
        ToDoAlertError.present(on: self, message: message)
    }
    
    /// Clears the search field.
    func clearSearch() {
        searchView.text = ""
    }
    
    /// Updates the footer with the current task count.
    func updateFooterCount(_ count: Int) {
        footer.updateCount(count)
    }
}


// MARK: - UITableViewDataSource

extension TasksViewController: UITableViewDataSource {
    /// Returns the number of tasks in the list.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTodos
    }
    
    /// Configures and returns a TodoTableViewCell.
    /// Uses `Reusable` protocol for safe dequeuing.
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
    /// Returns the context menu configuration for a task.
    /// Logic is encapsulated in `ToDoContextMenu` for readability and reuse.
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        ToDoContextMenu.makeMenu(for: indexPath, entity: presenter.todo(at: indexPath.row)) { action in
            switch action {
            case .edit: self.presenter.didSelectTodo(at: indexPath.row)
            case .share: self.presenter.completedToDo(at: indexPath.row)
            case .delete: self.presenter.deleteToDo(at: indexPath.row)
            }
        }
    }
    
    /// Custom preview for highlighting the context menu (on long press).
    /// Delegated to UITableView extension for reusability.
    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        tableView.makeTargetedPreview(for: configuration)
    }
    
    /// Custom preview for dismissing the context menu.
    /// Delegated to UITableView extension for centralized logic.
    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        tableView.makeTargetedPreview(for: configuration)
    }
    
    /// Returns the custom header for the first section (sticky search field).
    /// Encapsulated in UIView extension for better separation.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? UIView.getHeader(with: searchView) : nil
    }
    
    /// Returns the header height for the section.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? Consts.heightSearchView : 0
    }
    
    /// Handles row selection: notifies presenter and deselects the row.
    /// Navigation handled via Presenter → Router.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTodo(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private functions

extension TasksViewController {
    /// Sets up table view delegates and data source.
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Configures the navigation bar title with large style.
    private func createNavigationItemTitle() {
        navigationItem.title = Consts.navTitle
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.applyBlackLargeTitleStyle()
    }
    
    /// Adds all subviews to the view hierarchy.
    private func setupViews() {
        [backgroundView, tableView, footer].forEach{
            view.addSubview($0)
        }
    }
    
    /// Sets up Auto Layout constraints for all subviews.
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
    
    /// Sets up the search handler and delegates text changes to the presenter.
    private func setupSearchHandler() {
        searchView.onTextChanged = { [weak self] query in
            self?.presenter.searchToDoItems(query: query)
        }
    }
}

// MARK: - Keyboard handling

extension TasksViewController {
    /// Adds a tap gesture to dismiss the keyboard when tapping outside text fields.
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Dismisses the keyboard.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
