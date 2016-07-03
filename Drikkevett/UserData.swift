//
//  UserData.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 13.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import CoreData


class UserData: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
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
