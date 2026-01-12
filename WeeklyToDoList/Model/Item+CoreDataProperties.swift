//
//  Item+CoreDataProperties.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 05/01/2026.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var todos: String?
    @NSManaged public var plannedOccurrences: NSSet?
    @NSManaged public var section: Section?

}

// MARK: Generated accessors for plannedOccurrences
extension Item {

    @objc(addPlannedOccurrencesObject:)
    @NSManaged public func addToPlannedOccurrences(_ value: PlannedTask)

    @objc(removePlannedOccurrencesObject:)
    @NSManaged public func removeFromPlannedOccurrences(_ value: PlannedTask)

    @objc(addPlannedOccurrences:)
    @NSManaged public func addToPlannedOccurrences(_ values: NSSet)

    @objc(removePlannedOccurrences:)
    @NSManaged public func removeFromPlannedOccurrences(_ values: NSSet)

}

extension Item : Identifiable {

}
