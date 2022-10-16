//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoListexample
//
//  Created by sweta makuwala on 20/11/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
    @NSManaged public var name: String?
    @NSManaged public var date: String?
}

extension Item : Identifiable {

}
