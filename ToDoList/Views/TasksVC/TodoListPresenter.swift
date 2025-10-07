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
    func todo(at index: Int) ->  TodoItem?
    func didSelectTodo(at index: Int)
    func didTapAddNewItem()
    func setView(_ view: ITodoListView)
    
    // MARK: - CRUD
    
    func addNewFixedItem<T: IToDo>(item: T)
    func loadTodos()
    func completedToDo(at index: Int)
    func updateItem<T: IToDo>(entity: T)
    func deleteToDo(at index: Int)
    
    // MARK: - Search
    
    func searchToDoItems(query: String)
}

/// Презентер списка задач.
/// Отвечает за бизнес-логику списка, обработку CRUD операций и поиск.
/// Использует Interactor для работы с данными и Router для навигации.
/// Обновление UI централизовано через `handleResult` и `update`.
final class TodoListPresenter  {
    private let interactor: ITodoInteractor
    private weak var view: ITodoListView?
    private let router: ITasksRouter
    private var todos: [any IToDo] = []
    var numberOfTodos: Int {
        todos.count
    }
    
    /// Инициализация презентера с interactor и router.
    /// - Parameters:
    ///   - interactor: Инстанс ITodoListInteractor.
    ///   - view: Необязательный экземпляр ITodoListView.
    ///   - router: Экземпляр ITasksRouter для навигации.
    init(interactor: ITodoInteractor, view: ITodoListView? = nil, router: ITasksRouter) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {

    
    func todo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index] as? TodoItem
    }


    
    /// Обработка выбора задачи пользователем.
    /// Делегирует навигацию через Router.
    func didSelectTodo(at index: Int) {
        guard let todo = todo(at: index) else { return }
        //router.showTodoDetail(todoItem: todo)
    }
    
    /// Добавление новой фиксированной задачи.
    /// UX: сначала добавляем задачу, затем очищаем поиск и обновляем UI.
    func didTapAddNewItem() {
        view?.clearSearch()
        searchToDoItems(query: "")
        addNewFixedItem(item: TasksViewController.Consts.newFixedToDoItem())
    }
    
    /// Устанавливает view для связи Presenter ↔ View.
    func setView(_ view: ITodoListView) {
        self.view = view
    }
    

    
    /// Загрузка всех задач из Interactor в фоне.
    func loadTodos() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.fetchItems()
        }
    }
    
    /// Добавление нового TodoItem через Interactor.

    func addNewFixedItem<T: IToDo>(item: T) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.addItem(item)
        }
    }
    
    /// Отметка задачи как выполненной.
    /// какой то ловит глюк
    func completedToDo(at index: Int) {
        guard var entity = todo(at: index) else { return }
        entity.updateCompleted()
        updateItem(entity: entity)
    }
    
    /// Обновление задачи через Interactor.
    func updateItem<T: IToDo>(entity: T) {
        interactor.updateItem(entity)
    }
    
    /// Удаление задачи через Interactor.
    func deleteToDo(at index: Int) {
        guard let entity = todo(at: index) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.deleteItem(id: entity.id)
        }
    }
    
    /// Поиск задач по строке запроса.
    /// Если query пустой — подгружаем все задачи через loadTodos.
    func searchToDoItems(query: String) {
        guard !query.isEmpty else {
            interactor.fetchItems()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.searchItems(query: query)
        }
    }
}

// MARK: - Private Helpers

extension TodoListPresenter {
    /// Навигация к экрану деталей задачи.
    private func showTodoDetail<T: IToDo>(todoItem: T) {
        //router.showTodoDetail(todoItem: todoItem)
    }
    
    /// Обновление UI после изменения списка задач.
    /// Перезагружает таблицу и обновляет footer.
    private func update(){
        self.view?.reloadData()
        self.view?.updateFooterCount(self.todos.count)
    }
    
    /// Сортировка задач по дате (от новых к старым).
    private func sortTodos<T: IToDo>(_ items: [T]) -> [T] {
        items.sorted { $0.date > $1.date }
    }

}


extension TodoListPresenter: ITodoInteractorOutput {
   
    
    func didAddTodo<T: IToDo>(_ todo: T) {
        self.todos.insert(todo, at: 0)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func didUpdateTodo<T: IToDo>(_ todo: T) {
        guard let index = self.todos.firstIndex(where: { $0.id == todo.id }) else { return }
        self.todos[index] = todo
        DispatchQueue.main.async {
            self.update()
        }
    }
    func didFetchTodos<T: IToDo>(_ todos: [T]) {
        self.todos.removeAll()
        self.todos = sortTodos(todos)
        DispatchQueue.main.async {
            self.update()
        }
    }

    func didDeleteTodo(id: UUID) {
        guard let index = todos.firstIndex(where: { $0.id == id }) else { return }
        self.todos.remove(at: index)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func didFail(with error: Error) {
        view?.showError(error.localizedDescription)
    }

    func didSearchTodos<T: IToDo>(_ todos: [T]) {
        self.todos.removeAll()
        self.todos = self.sortTodos(todos)
        DispatchQueue.main.async {
            self.update()
        }
    }
 
}
