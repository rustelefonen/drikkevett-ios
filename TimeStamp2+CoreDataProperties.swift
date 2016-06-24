//
//  TimeStamp2+CoreDataProperties.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 13.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimeStamp2 {

    @NSManaged var timeStamp: NSDate?
    @NSManaged var unitAlkohol: String?

}
