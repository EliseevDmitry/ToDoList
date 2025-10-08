//
//  TodoDetailPresenter.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

protocol ITodoDetailPresenter {
    func didTapBack()
    func viewDidLoad()
    func updateItem(title: String, content: String)
}

protocol ITodoDetailOutput: AnyObject {
    func didUpdateItem<T: IToDo>(entity: T)
}

final class TodoDetailPresenter  {
    private weak var view: ITodoDetailView?
    weak var delegate: ITodoDetailOutput?
    private let router: ITasksRouter
    private var todo: (any IToDo)
    
    init(view: ITodoDetailView? = nil, router: ITasksRouter,  todo: any IToDo) {
        self.view = view
        self.router = router
        self.todo = todo
    }
}

// MARK: - ITodoDetailPresenter functions

extension TodoDetailPresenter: ITodoDetailPresenter {

    func didTapBack() {
        router.pop(from: self.view)
    }
    
    func viewDidLoad() {
        view?.display(todo: todo)
    }
    
    func updateItem(title: String, content: String) {
        guard var todoEntity = todo as? TodoItem, !todoEntity.completed else { return }
        todoEntity.updateTodoAndContent(todo: title, content: content)
        delegate?.didUpdateItem(entity: todoEntity)
    }
}

// MARK: - Public functions

extension TodoDetailPresenter {
    func setView(_ view: ITodoDetailView) {
        self.view = view
    }
}
