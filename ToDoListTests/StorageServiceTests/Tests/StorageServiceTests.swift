//
//  StorageServiceTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 13.10.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class StorageServiceTests: XCTestCase {
    
    enum Consts {
        //Для проверки добавления одной записи в хранилище CoreData
        static let fixedEntityCount = 1
        static let emptyCount = 0
        static let updateTodo = "Updated title"
        static let updateContent = "Updated description"
        static let timeout:Double = 2.0
    }
    
    var sut: StorageService!
    var container: NSPersistentContainer!
    var todo: [MockToDo] = []
    
    override func setUpWithError() throws {
        super.setUp()
        container = NSPersistentContainer.makeInMemoryContainer()
        sut = StorageService(container: container)
        for index in 0 ... 2 {
            todo.append( MockToDo(
                id: UUID(),
                todo: "Test ToDo \(index)",
                content: "Test Description \(index)",
                completed: false,
                date: .now
            ))
        }
    }
    
    override func tearDownWithError() throws {
        sut = nil
        container = nil
        todo = []
        super.tearDown()
    }

    func test_addTodo_createsNewEntity() {
        // Given
        let expectation = expectation(description: "Save single Todo")
        guard let entity = todo.first else {
            XCTFail("No MockToDo available to test update")
            return
        }
        // When
        sut.addTodo(item: entity) { result in
            switch result {
            case .success(let success):
                // Then — addTodo успешно
                XCTAssertTrue(success)
                // When — получаем все сущности после сохранения
                self.sut.getToDos(MockToDo.self) { fetchResult in
                    switch fetchResult {
                    case .success(let todos):
                        // Then — проверка, что сущность добавлена
                        XCTAssertEqual(todos.count, Consts.fixedEntityCount)
                        XCTAssertEqual(todos.first?.id, entity.id)
                        expectation.fulfill()
                    case .failure(let error):
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }

    func test_addTodos_createsMultipleEntities() {
            // Given
            let expectation = expectation(description: "Save multiple Todos")
            // When
            sut.addTodos(items: todo) { result in
                switch result {
                case .success(let success):
                    // Then — addTodos успешно
                    XCTAssertTrue(success)
                    // When — получаем все сущности после сохранения
                    self.sut.getToDos(MockToDo.self) { fetchResult in
                        switch fetchResult {
                        case .success(let todos):
                            // Then — проверка, что все сущности добавлены
                            self.assertTodosEqual(todos, self.todo, expectation: expectation)
                        case .failure(let error):
                            self.fail(error: error, expectation: expectation)
                        }
                    }
                case .failure(let error):
                    self.fail(error: error, expectation: expectation)
                }
            }
            wait(for: [expectation], timeout: Consts.timeout)
        }
    
    
    func test_addTodos_shouldSaveAllEntities() {
        //Given
        let expectation = expectation(description: "Get")
        sut.addTodos(items: todo) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
                //When
                self.sut.getToDos(MockToDo.self) { result in
                    switch result {
                    case .success(let todos):
                        //Then
                        self.assertTodosEqual(todos, self.todo, expectation: expectation)
                    case .failure(let error):
                        //Then
                        self.fail(error: error, expectation: expectation)
                    }
                }
            case .failure(let error):
                self.fail(error: error, expectation: expectation)
            }
        }
        wait(for: [expectation], timeout: Consts.timeout)
    }
    
    func test_updateTodo_shouldChangeFields() {
           // Given
           let expectation = expectation(description: "Update Todo")
           guard var entity = todo.first else {
               XCTFail("No MockToDo available to test update")
               return
           }
           // When — сначала добавляем задачу
           sut.addTodo(item: entity) { result in
               switch result {
               case .success(let success):
                   // Then — добавление успешно
                   XCTAssertTrue(success)
                   entity.updateTodoAndContent(todo: Consts.updateTodo, content: Consts.updateContent)
                   // When — обновляем задачу
                   self.sut.updateTodo(item: entity) { result in
                       switch result {
                       case .success(let success):
                           // Then — обновление успешно
                           XCTAssertTrue(success)
                           // When — получаем все сущности после обновления
                           self.sut.getToDos(MockToDo.self) { result in
                               switch result {
                               case .success(let todos):
                                   // Then — проверяем изменения
                                   XCTAssertEqual(todos.count, Consts.fixedEntityCount)
                                   XCTAssertEqual(todos.first?.id, entity.id)
                                   XCTAssertNotEqual(todos.first?.todo, self.todo.first?.todo)
                                   XCTAssertEqual(todos.first?.todo, Consts.updateTodo)
                                   XCTAssertEqual(todos.first?.content, Consts.updateContent)
                                   expectation.fulfill()
                               case .failure(let error):
                                   self.fail(error: error, expectation: expectation)
                               }
                           }
                       case .failure(let error):
                           self.fail(error: error, expectation: expectation)
                       }
                   }
               case .failure(let error):
                   self.fail(error: error, expectation: expectation)
               }
           }
           wait(for: [expectation], timeout: Consts.timeout)
       }
    
    func test_deleteTodo_shouldRemoveEntity() {
            // Given
            let expectation = expectation(description: "Delete Todo")
            guard let entity = todo.first else {
                XCTFail("No MockToDo available to test delete")
                return
            }
            // When — добавляем задачу
            sut.addTodo(item: entity) { result in
                switch result {
                case .success(let success):
                    // Then — добавление успешно
                    XCTAssertTrue(success)
                    // When — удаляем задачу
                    self.sut.deleteTodo(id: entity.id) { result in
                        switch result {
                        case .success(let success):
                            // Then — удаление успешно
                            XCTAssertTrue(success)
                            // When — проверяем, что список пуст
                            self.sut.getToDos(MockToDo.self) { result in
                                switch result {
                                case .success(let todos):
                                    // Then — список пуст
                                    XCTAssertEqual(todos.count, Consts.emptyCount)
                                    expectation.fulfill()
                                case .failure(let error):
                                    self.fail(error: error, expectation: expectation)
                                }
                            }
                        case .failure(let error):
                            self.fail(error: error, expectation: expectation)
                        }
                    }
                case .failure(let error):
                    self.fail(error: error, expectation: expectation)
                }
            }
            wait(for: [expectation], timeout: Consts.timeout)
        }
        
    
}

extension StorageServiceTests {
   private func assertTodosEqual(_ fetched: [MockToDo], _ expected: [MockToDo], expectation: XCTestExpectation) {
        let fetchedIDs = Set(fetched.map { $0.id })
        let expectedIDs = Set(expected.map { $0.id })
        XCTAssertEqual(fetchedIDs, expectedIDs)
        expectation.fulfill()
    }
    
    private func fail(error: Error, expectation: XCTestExpectation) {
        XCTFail("Add Todo failed: \(error.localizedDescription)")
        expectation.fulfill()
    }
}

/*
 удаление несуществующего id

 обновление несуществующей сущности

 добавление сущности с уже существующим id
 */
