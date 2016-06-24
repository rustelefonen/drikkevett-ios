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

    class func createInManagedObjectContext(moc: NSManagedObjectContext, dato: NSDate, forbruk: Int, hoyestePromille: Double, antOl: Int, antVin: Int, antDrink: Int, antShot: Int, stringDato: String) -> Historikk {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Historikk", inManagedObjectContext: moc) as! Historikk
        newItem.dato = dato
        newItem.forbruk = forbruk
        newItem.hoyestePromille = hoyestePromille
        newItem.antallOl = antOl
        newItem.antallVin = antVin
        newItem.antallDrink = antDrink
        newItem.antallShot = antShot
        newItem.datoTwo = stringDato
        
        return newItem
    }
}
