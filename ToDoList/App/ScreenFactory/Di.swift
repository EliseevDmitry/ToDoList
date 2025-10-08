//
//  Di.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

/// Dependency container for app modules (VIPER-style).
final class Di {
    /// Repository for todo items.
    let todoRepository: ITodoRepository
    /// Router handling task navigation.
    let router: ITasksRouter
    /// Factory for creating screens or view controllers.
    let screenFactory: ScreenFactory
    
    init(
        todoRepository: ITodoRepository = TodoRepository(),
        router: ITasksRouter = TasksRouter(),
        screenFactory: ScreenFactory = ScreenFactory()
    ) {
        self.todoRepository = todoRepository
        self.router = router
        self.screenFactory = screenFactory
        screenFactory.di = self
    }
}
