//
//  Di.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//


final class Di {
    let todoRepository: ITodoRepository
    let router: ITasksRouter
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
