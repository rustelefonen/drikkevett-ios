//
//  Unit+CoreDataClass.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import CoreData


public class Unit: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }
    
    @NSManaged public var unitType: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var history: History?
}
