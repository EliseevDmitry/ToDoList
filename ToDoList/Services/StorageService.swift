//
//  StorageService.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import Foundation
import CoreData

/// Протокол сервиса работы с CoreData для CRUD операций и поиска.
protocol IStorageService {
    /// Добавляет одну задачу.
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Добавляет массив задач за одну транзакцию.
    func addTodos<T: IToDo>(
        items: [T],
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Получает все задачи.
    func getToDos<T: IToDo>(
        _ type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    )
    
    /// Обновляет задачу.
    func updateTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Удаляет задачу по ID.
    func deleteTodo(
        id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    /// Выполняет поиск задач по строке.
    func searchTodos<T: IToDo>(
        _ type: T.Type,
        query: String,
        completion: @escaping (Result<[T], Error>) -> Void
    )
}

/// Сервис хранения данных задач с использованием CoreData.
/// Все операции выполняются в фоновом потоке через `performBackgroundTask`.
final class StorageService: IStorageService {
    private let container: NSPersistentContainer
    
    /// Инициализация с NSPersistentContainer.
    /// - Parameter container: CoreData контейнер.
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
    /// Добавление одной задачи в CoreData.
    func addTodo<T: IToDo>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        container.performBackgroundTask { context in
            self.convertItem(item: item, context: context)
            self.saveContext(context, completion: completion)
        }
    }
    
    /// Добавление нескольких задач за один вызов сохранения.
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
    
    /// Получение всех задач из CoreData.
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
    
    /// Обновление существующей задачи.
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
    
    /// Удаление задачи по ID.
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
    
    /// Поиск задач по строке запроса.
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
    /// Фоновый запрос всех задач.
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
    
    /// Конвертация сущностей CoreData в модель IToDo.
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
    
    /// Конвертация модели IToDo в сущность CoreData.
    private func convertItem<T: IToDo>(item: T, context: NSManagedObjectContext) {
        let newEntity = TodoEntities(context: context)
        newEntity.id = item.id
        newEntity.todo = item.todo
        newEntity.content = item.content
        newEntity.completed = item.completed
        newEntity.date = item.date
    }
    
    /// Сохраняет контекст CoreData и вызывает completion.
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
    
    /// Обновление сущности CoreData по модели IToDo.
    private func updateEntity<T: IToDo>(entity: TodoEntities, item: T) {
        entity.todo = item.todo
        entity.content = item.content
        entity.completed = item.completed
        entity.date = item.date
    }
    
    /// NSPredicate по ID задачи.
    private func predicate(for id: UUID) -> NSPredicate {
        NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    /// NSPredicate для поиска по todo и content.
    private func searchPredicate(_ query: String) -> NSPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "todo CONTAINS[cd] %@", query),
            NSPredicate(format: "content CONTAINS[cd] %@", query)
        ])
    }
    
    /// Фильтрация моделей по дате и тексту.
    private func filterItems<T: IToDo>(_ items: [T], _ query: String) -> [T] {
        items.filter {
            $0.date.getToDoDateFormat.contains(query) ||
            $0.todo.localizedCaseInsensitiveContains(query) ||
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }
}
