//
//  TodoDetailPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

/// Протокол Presenter для экрана деталей задачи.
/// Определяет методы для управления жизненным циклом View и обновления модели задачи.
protocol ITodoDetailPresenter {
    /// Вызывается при нажатии кнопки "Назад".
    /// Отвечает за навигацию назад.
    func didTapBack()
    
    /// Вызывается при загрузке View.
    /// Отвечает за инициализацию данных на экране и их отображение.
    func viewDidLoad()
    
    /// Обновляет данные задачи.
    /// - Parameters:
    ///   - title: Новый заголовок задачи.
    ///   - content: Новый текст задачи.
    func updateItem(title: String, content: String)
}

/// Presenter для экрана деталей задачи.
/// Отвечает за взаимодействие View и Router, а также за обновление основной задачи через toDoListPresenter.
final class TodoDetailPresenter  {
    private weak var view: ITodoDetailView?
    private let router: ITasksRouter
    private let todo: any IToDo
    private let toDoListPresenter: ITodoListPresenter
    
    // MARK: - Init
    
    /// Инициализация Presenter.
    /// - Parameters:
    ///   - view: Опциональная View, реализующая ITodoDetailView.
    ///   - router: Router для навигации.
    ///   - todo: Текущая задача для отображения и редактирования.
    ///   - toDoListPresenter: Presenter списка задач для синхронизации CRUD-операций.
    init(view: ITodoDetailView? = nil, router: ITasksRouter, todo: any IToDo, listPresenter: ITodoListPresenter) {
        self.view = view
        self.router = router
        self.todo = todo
        self.toDoListPresenter = listPresenter
    }
}

// MARK: - ITodoDetailPresenter functions

extension TodoDetailPresenter: ITodoDetailPresenter {
    /// Обрабатывает нажатие кнопки "Назад".
    /// Делегирует навигацию Router-у.
    func didTapBack() {
        router.pop()
    }
    
    /// Вызывается после загрузки View.
    /// Передает текущую задачу в View для отображения.
    func viewDidLoad() {
        view?.display(todo: todo)
    }
    
    /// Обновляет данные задачи.
    /// Проверяет, что модель соответствует `TodoItem`, обновляет поля и передает изменения в toDoListPresenter.
    /// - Parameters:
    ///   - title: Новый заголовок задачи.
    ///   - content: Новый текст задачи.
    func updateItem(title: String, content: String) {
        guard var todoEntity = todo as? TodoItem else { return }
        todoEntity.updateTodoAndContent(todo: title, content: content)
        toDoListPresenter.updateItem(entity: todoEntity)
    }
}

// MARK: - Public functions

extension TodoDetailPresenter {
    /// Устанавливает View после инициализации.
    /// Используется, если View создается позже, чем Presenter.
    /// - Parameter view: Экземпляр ITodoDetailView.
    func setView(_ view: ITodoDetailView) {
        self.view = view
    }
}
