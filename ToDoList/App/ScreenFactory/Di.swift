//
//  Di.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

// MARK: - Dependency Injection Container

/// DI-контейнер для управления зависимостями приложения: репозитории, интеракторы, роутеры и фабрика экранов.
/// Обеспечивает централизованное создание и конфигурацию модулей для VIPER-сценариев.
final class Di {
    let todoRepository: ITodoRepository
    var todoListInteractor: ITodoListInteractor {
        TodoListInteractor(todoRepository: todoRepository)
    }
    let router: ITasksRouter
    lazy var screenFactory: ScreenFactory = {
        ScreenFactory(di: self)
    }()
    
    init() {
        self.todoRepository = TodoRepository()
        self.router = TasksRouter(viewController: nil)
    }
}
