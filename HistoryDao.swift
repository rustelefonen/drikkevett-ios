//
//  HistoryDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.02.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class HistoryDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: UserData.self)
        super.init()
    }
    
    //Operations
    func createNewHistory() -> Historikk {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Historikk
    }
    
    func createNewHistory(antallDrink: NSNumber?, antallOl: NSNumber?, antallShot: NSNumber?, antallVin: NSNumber?, dato: Date?, datoTwo: String?, endOfSesDato: Date?, firstUnitTimeStamp: Date?, forbruk: NSNumber?, hoyestePromille: NSNumber?, sessionNumber: NSNumber?, plannedNrUnits: NSNumber?) -> Historikk{
        let newHistory = createNewHistory()
        newHistory.antallDrink = antallDrink
        newHistory.antallOl = antallOl
        newHistory.antallShot = antallShot
        newHistory.antallVin = antallVin
        newHistory.dato = dato
        newHistory.datoTwo = datoTwo
        newHistory.endOfSesDato = endOfSesDato
        newHistory.firstUnitTimeStamp = firstUnitTimeStamp
        newHistory.forbruk = forbruk
        newHistory.hoyestePromille = hoyestePromille
        newHistory.sessionNumber = sessionNumber
        newHistory.plannedNrUnits = plannedNrUnits
        return newHistory
    }
    
    func getAll() -> [Historikk] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let histories = (try? managedObjectContext.fetch(fetchRequest)) as? [Historikk]
        
        return histories ?? []
    }
}
