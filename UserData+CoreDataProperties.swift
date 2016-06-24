//
//  UserData+CoreDataProperties.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 01.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserData {

    @NSManaged var age: NSNumber?
    @NSManaged var costsBeer: NSNumber?
    @NSManaged var costsDrink: NSNumber?
    @NSManaged var costsShot: NSNumber?
    @NSManaged var costsWine: NSNumber?
    @NSManaged var gender: NSNumber?
    @NSManaged var height: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var goalPromille: NSNumber?
    @NSManaged var goalDate: NSDate?

}
