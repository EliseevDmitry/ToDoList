//
//  Ns.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 13.10.2025.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    static func makeInMemoryContainer(name: String = "Todo") -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            precondition(error == nil, "In-memory store error: \(error!.localizedDescription)")
        }
        return container
    }
}
