//
//  StorageService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import Foundation
import CoreData

protocol IStorageService {
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func addTodos<T: IToDo>(
        items: [T],
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func getToDos<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    )
    func updateTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func deleteTodo(
        id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
}

final class StorageService: IStorageService {
    private let container: NSPersistentContainer
    
    init(container:  NSPersistentContainer){
        self.container = container
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            } else {
                print("Successfully loaded core data!")
            }
        }
    }
}

extension StorageService {
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            self.convertItem(item: item, context: context)
            self.saveContext(context, completion: completion)
        }
    }
    
    func addTodos<T: IToDo>(
        items: [T],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            for item in items {
                self.convertItem(item: item, context: context)
            }
            self.saveContext(context, completion: completion)
        }
    }
    
    func getToDos<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        fetchTodos { entities in
            switch entities {
            case .success(let entities):
                let items: [T] = self.convertEntities(entities)
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TodoEntities> = TodoEntities.fetchRequest()
            request.predicate = self.predicate(for: item.id)
            request.fetchLimit = 1
            do {
                if let entity = try context.fetch(request).first {
                    self.updateEntity(entity: entity, item: item)
                }
                self.saveContext(context, completion: completion)
            } catch {
                    completion(.failure(error))
            }
        }
    }

    func deleteTodo(
        id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TodoEntities> = TodoEntities.fetchRequest()
            request.predicate = self.predicate(for: id)
            do {
                let todos = try context.fetch(request)
                todos.forEach { context.delete($0) }
                self.saveContext(context, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension StorageService {
    //запрос данный у CoreData в фоновом потоке
    private func fetchTodos(completion: @escaping (Result<[TodoEntities], Error>) -> Void) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TodoEntities> = TodoEntities.fetchRequest()
            do {
                let todos = try context.fetch(request)
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //конвертируем TodoEntities - CoreData, в модель данных соответствующую протоку IToDo
    private func convertEntities<T: IToDo>(_ entities: [TodoEntities]) -> [T] {
        let items: [T] = entities.compactMap { entity in
            guard
                let id = entity.id,
                let todo = entity.todo,
                let content = entity.content,
                let date = entity.date
            else {
                return nil
            }
            return T(
                id: id,
                todo: todo,
                content: content,
                completed: entity.completed,
                date: date
            )
        }
        return items
    }
    
    private func convertItem<T: IToDo>(item: T, context: NSManagedObjectContext) {
        let newEntity = TodoEntities(context: context)
        newEntity.id = item.id
        newEntity.todo = item.todo
        newEntity.content = item.content
        newEntity.completed = item.completed
        newEntity.date = item.date
    }
    
    private func saveContext(
        _ context: NSManagedObjectContext,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            try context.save()
                completion(.success(true))
        } catch {
                completion(.failure(error))
        }
    }
    
    private func updateEntity<T: IToDo>(entity: TodoEntities, item: T) {
        entity.todo = item.todo
        entity.content = item.content
        entity.completed = item.completed
        entity.date = item.date
    }
    
    private func predicate(for id: UUID) -> NSPredicate {
        NSPredicate(format: "id == %@", id as CVarArg)
    }
    
}
