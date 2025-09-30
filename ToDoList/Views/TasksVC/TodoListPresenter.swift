//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 24.09.2025.
//

import Foundation

/// Протокол презентера для TasksViewController.
/// Определяет публичный API для CRUD и поиска задач.
/// Используется в VIPER-архитектуре для связи View ↔ Presenter.
protocol ITodoListPresenter {
    var numberOfTodos: Int { get }
    func todo(at index: Int) -> TodoItem?
    func didSelectTodo(at index: Int)
    func didTapAddNewItem()
    func setView(_ view: ITodoListView)
    
    // MARK: - CRUD
    
    func addNewFixedItem(item: TodoItem)
    func loadTodos()
    func completedToDo(at index: Int)
    func updateItem(entity: TodoItem)
    func deleteToDo(at index: Int)
    
    // MARK: - Search
    
    func searchToDoItems(query: String)
}

/// Презентер списка задач.
/// Отвечает за бизнес-логику списка, обработку CRUD операций и поиск.
/// Использует Interactor для работы с данными и Router для навигации.
/// Обновление UI централизовано через `handleResult` и `update`.
final class TodoListPresenter {
    private let interactor: ITodoListInteractor
    private weak var view: ITodoListView?
    private let router: ITasksRouter
    private var todos: [TodoItem] = []
    var numberOfTodos: Int {
        todos.count
    }
    
    /// Инициализация презентера с interactor и router.
    /// - Parameters:
    ///   - interactor: Инстанс ITodoListInteractor.
    ///   - view: Необязательный экземпляр ITodoListView.
    ///   - router: Экземпляр ITasksRouter для навигации.
    init(interactor: ITodoListInteractor, view: ITodoListView? = nil, router: ITasksRouter) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    /// Возвращает задачу по индексу, безопасно проверяя границы массива.
    func todo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
    
    /// Обработка выбора задачи пользователем.
    /// Делегирует навигацию через Router.
    func didSelectTodo(at index: Int) {
        guard let todo = todo(at: index) else { return }
        router.showTodoDetail(todoItem: todo)
    }
    
    /// Добавление новой фиксированной задачи.
    /// UX: сначала добавляем задачу, затем очищаем поиск и обновляем UI.
    func didTapAddNewItem() {
        view?.clearSearch()
        searchToDoItems(query: "")
        addNewFixedItem(item: TasksViewController.Consts.newFixedToDoItem)
    }
    
    /// Устанавливает view для связи Presenter ↔ View.
    func setView(_ view: ITodoListView) {
        self.view = view
    }
    
    /// Добавление нового TodoItem через Interactor.
    /// UI обновляется через handleResult.
    func addNewFixedItem(item: TodoItem) {
        interactor.addItem(item: item) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result) {
                self.todos.insert(item, at: 0)
                self.update()
            }
        }
    }
    
    /// Загрузка всех задач из Interactor в фоне.
    /// UI обновляется через `update`.
    func loadTodos() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.fetchItems { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    self.todos.removeAll()
                    self.todos = self.sortTodos(items)
                    DispatchQueue.main.async {
                        self.update()
                    }
                case .failure(let error):
                    DispatchQueue.main.async { self.view?.showError(error.localizedDescription) }
                }
            }
        }
    }
    
    /// Отметка задачи как выполненной.
    /// Обновление UI через handleResult.
    func completedToDo(at index: Int) {
        guard var entity = todo(at: index) else { return }
        entity.updateCompleted()
        interactor.updateItem(item: entity) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result) {
                self.todos[index] = entity
                self.update()
            }
        }
    }
    
    /// Обновление задачи через Interactor.
    /// UI обновляется через handleResult.
    func updateItem(entity: TodoItem) {
        interactor.updateItem(item: entity) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result) {
                if let index = self.todos.firstIndex(where: { $0.id == entity.id }) {
                    self.todos[index] = entity
                }
                self.view?.reloadData()
            }
        }
    }
    
    /// Удаление задачи через Interactor.
    /// UI обновляется через handleResult.
    func deleteToDo(at index: Int) {
        guard let entity = todo(at: index) else { return }
        interactor.deleteItem(id: entity.id) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result) {
                self.todos.remove(at: index)
                self.update()
            }
        }
    }
    
    /// Поиск задач по строке запроса.
    /// Если query пустой — подгружаем все задачи через loadTodos.
    /// UI обновляется через handleFetchResult.
    func searchToDoItems(query: String) {
        guard !query.isEmpty else {
            loadTodos()
            return
        }
        interactor.searchItems(query: query) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.todos.removeAll()
                    self.todos = self.sortTodos(items)
                    self.update()
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private Helpers

extension TodoListPresenter {
    /// Навигация к экрану деталей задачи.
    private func showTodoDetail(todoItem: TodoItem) {
        router.showTodoDetail(todoItem: todoItem)
    }
    
    /// Обновление UI после изменения списка задач.
    /// Перезагружает таблицу и обновляет footer.
    private func update(){
        self.view?.reloadData()
        self.view?.updateFooterCount(self.todos.count)
    }
    
    /// Сортировка задач по дате (от новых к старым).
    private func sortTodos(_ items: [TodoItem]) -> [TodoItem] {
        items.sorted { $0.date > $1.date }
    }
    
    /// Унифицированная обработка Result<Bool, Error> для CRUD операций.
    /// UI обновляется на главном потоке через DispatchQueue.main.async.
    /// - Parameters:
    ///   - result: Результат операции Interactor.
    ///   - onSuccess: Замыкание для выполнения при успешной операции.
    private func handleResult(_ result: Result<Bool, Error>, onSuccess: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch result {
            case .success(_):
                onSuccess()
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
