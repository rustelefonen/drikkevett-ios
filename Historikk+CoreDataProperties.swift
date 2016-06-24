//
//  Historikk+CoreDataProperties.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 08.05.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Historikk {

    @NSManaged var antallDrink: NSNumber?
    @NSManaged var antallOl: NSNumber?
    @NSManaged var antallShot: NSNumber?
    @NSManaged var antallVin: NSNumber?
    @NSManaged var dato: NSDate?
    @NSManaged var datoTwo: String?
    @NSManaged var endOfSesDato: NSDate?
    @NSManaged var firstUnitTimeStamp: NSDate?
    @NSManaged var forbruk: NSNumber?
    @NSManaged var hoyestePromille: NSNumber?
    @NSManaged var sessionNumber: NSNumber?
    @NSManaged var plannedNrUnits: NSNumber?

}
