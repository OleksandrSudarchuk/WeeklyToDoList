//
//  Section+CoreDataProperties.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 01/12/2025.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var titleOfSection: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var item: NSSet?

}

// MARK: Generated accessors for item
extension Section {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

extension Section : Identifiable {

}
