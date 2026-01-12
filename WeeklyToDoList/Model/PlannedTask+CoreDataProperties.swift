//
//  PlannedTask+CoreDataProperties.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 05/01/2026.
//
//

import Foundation
import CoreData


extension PlannedTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlannedTask> {
        return NSFetchRequest<PlannedTask>(entityName: "PlannedTask")
    }

    @NSManaged public var day: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var item: Item?

}

extension PlannedTask : Identifiable {

}
