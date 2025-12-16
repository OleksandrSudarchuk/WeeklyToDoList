//
//  CoreDataStorage.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 15/12/2025.
//

import Foundation
import CoreData

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "WeeklyToDoList")
        conteiner.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return conteiner
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {return}
            do {
                try context.save()
            } catch {
                print("CoreData save error: \(error)")
        }
    }
}
