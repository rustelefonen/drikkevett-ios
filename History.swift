//
//  History+CoreDataClass.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import CoreData


public class History: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }
    
    @NSManaged public var gender: NSNumber?
    @NSManaged public var weight: NSNumber?
    
    @NSManaged public var beerCost: NSNumber?
    @NSManaged public var wineCost: NSNumber?
    @NSManaged public var drinkCost: NSNumber?
    @NSManaged public var shotCost: NSNumber?
    
    @NSManaged public var beerGrams: NSNumber?
    @NSManaged public var wineGrams: NSNumber?
    @NSManaged public var drinkGrams: NSNumber?
    @NSManaged public var shotGrams: NSNumber?
    
    
    
    @NSManaged public var beginDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var plannedBeerCount: NSNumber?
    @NSManaged public var plannedWineCount: NSNumber?
    @NSManaged public var plannedDrinkCount: NSNumber?
    @NSManaged public var plannedShotCount: NSNumber?
    @NSManaged public var units: NSSet?
    
    @objc(addUnitsObject:)
    @NSManaged public func addToUnits(_ value: Unit)
    
    @objc(removeUnitsObject:)
    @NSManaged public func removeFromUnits(_ value: Unit)
    
    @objc(addUnits:)
    @NSManaged public func addToUnits(_ values: NSSet)
    
    @objc(removeUnits:)
    @NSManaged public func removeFromUnits(_ values: NSSet)
}
