//
//  Historikk.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 11.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import CoreData


class Historikk: NSManagedObject {
    /*@NSManaged public var antallDrink: NSNumber?
    @NSManaged public var antallOl: NSNumber?
    @NSManaged public var antallShot: NSNumber?
    @NSManaged public var antallVin: NSNumber?
    @NSManaged public var dato: NSDate?
    @NSManaged public var datoTwo: String?
    @NSManaged public var endOfSesDato: NSDate?
    @NSManaged public var firstUnitTimeStamp: NSDate?
    @NSManaged public var forbruk: NSNumber?
    @NSManaged public var hoyestePromille: NSNumber?
    @NSManaged public var plannedNrUnits: NSNumber?
    @NSManaged public var sessionNumber: NSNumber?*/
    
    @NSManaged var antallDrink: NSNumber?
    @NSManaged var antallOl: NSNumber?
    @NSManaged var antallShot: NSNumber?
    @NSManaged var antallVin: NSNumber?
    @NSManaged var dato: Date?
    @NSManaged var datoTwo: String?
    @NSManaged var endOfSesDato: Date?
    @NSManaged var firstUnitTimeStamp: Date?
    @NSManaged var forbruk: NSNumber?
    @NSManaged var hoyestePromille: NSNumber?
    @NSManaged var sessionNumber: NSNumber?
    @NSManaged var plannedNrUnits: NSNumber?

    /*class func createInManagedObjectContext(_ moc: NSManagedObjectContext, dato: Date, forbruk: Int, hoyestePromille: Double, antOl: Int, antVin: Int, antDrink: Int, antShot: Int, stringDato: String) -> Historikk {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Historikk", into: moc) as! Historikk
        newItem.dato = dato
        newItem.forbruk = forbruk as NSNumber?
        newItem.hoyestePromille = hoyestePromille as NSNumber?
        newItem.antallOl = antOl as NSNumber?
        newItem.antallVin = antVin as NSNumber?
        newItem.antallDrink = antDrink as NSNumber?
        newItem.antallShot = antShot as NSNumber?
        newItem.datoTwo = stringDato
        
        return newItem
    }*/
}
