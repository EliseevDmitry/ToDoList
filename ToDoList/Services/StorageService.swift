//
//  StorageService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import Foundation
import CoreData

/// Core Data service protocol defining CRUD and search operations.
protocol IStorageService {
    /// Adds a single todo item.
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Adds multiple todo items in a single transaction.
    func addTodos<T: IToDo>(
        items: [T],
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Fetches all todo items.
    func getToDos<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    )
    
    /// Updates an existing todo item.
    func updateTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Deletes a todo item by its ID.
    func deleteTodo(
        id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Searches todo items matching the given query.
    func searchTodos<T: IToDo>(
        _ type: T.Type,
        query: String,
        completion: @escaping (Result<[T], Error>) -> Void
    )
}

/// Core Data–based storage service performing all operations on background contexts.
final class StorageService: IStorageService {
    private let container: NSPersistentContainer
    
    /// Initializes the service with a given Core Data container.
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

// MARK: - CRUD & Search

extension StorageService {
    /// Inserts a single todo item into Core Data.
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            self.convertItem(item: item, context: context)
            self.saveContext(context, completion: completion)
        }
    }
    
    /// Inserts multiple todo items in one background context save.
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
    
    /// Retrieves all todo entities and maps them to model objects.
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
    
    /// Updates an existing todo entity by ID.
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
    
    /// Deletes a todo entity matching the given ID.
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
    
    /// Performs a text-based search on todo and content fields.
    func searchTodos<T: IToDo>(
        _ type: T.Type,
        query: String,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TodoEntities> = TodoEntities.fetchRequest()
            request.predicate = self.searchPredicate(query)
            do {
                let entities = try context.fetch(request)
                var items: [T] = self.convertEntities(entities)
                items = self.filterItems(items, query)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private helpers

extension StorageService {
    /// Fetches all TodoEntities from the background context.
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
    
    /// Maps Core Data entities to domain models.
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
    
    /// Creates a new Core Data entity from the given domain model.
    private func convertItem<T: IToDo>(item: T, context: NSManagedObjectContext) {
        let newEntity = TodoEntities(context: context)
        newEntity.id = item.id
        newEntity.todo = item.todo
        newEntity.content = item.content
        newEntity.completed = item.completed
        newEntity.date = item.date
    }
    
    /// Saves the given managed object context and propagates errors.
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
    
    /// Updates an existing Core Data entity from a domain model.
    private func updateEntity<T: IToDo>(entity: TodoEntities, item: T) {
        entity.todo = item.todo
        entity.content = item.content
        entity.completed = item.completed
        entity.date = item.date
    }
    
    /// Returns a predicate for filtering by UUID.
    private func predicate(for id: UUID) -> NSPredicate {
        NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    /// Returns a compound predicate for full-text search in todo and content.
    private func searchPredicate(_ query: String) -> NSPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "todo CONTAINS[cd] %@", query),
            NSPredicate(format: "content CONTAINS[cd] %@", query)
        ])
    }
    
    /// Filters domain models by date, title, or content matching the query.
    private func filterItems<T: IToDo>(_ items: [T], _ query: String) -> [T] {
        items.filter {
            $0.date.getToDoDateFormat.contains(query) ||
            $0.todo.localizedCaseInsensitiveContains(query) ||
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }
}
