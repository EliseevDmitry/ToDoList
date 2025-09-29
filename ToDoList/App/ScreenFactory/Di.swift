//
//  Di.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

//Dependency Injection Container

// Dependency Injection Container
final class Di {
    let todoRepository: ITodoRepository
    var todoListInteractor: ITodoListInteractor {
        TodoListInteractor(todoRepository: todoRepository)
    }
    lazy var screenFactory: ScreenFactory = {
        ScreenFactory(di: self)
    }()
    
    init() {
        self.todoRepository = TodoRepository()
    }
}
