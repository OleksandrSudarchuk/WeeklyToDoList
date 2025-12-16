//
//  Item+CoreDataProperties.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 01/12/2025.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var todos: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var section: Section?

}

extension Item : Identifiable {

}
