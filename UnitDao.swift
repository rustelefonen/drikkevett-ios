//
//  UnitDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class UnitDao: CoreDataDao {
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: Unit.self)
        super.init()
    }
    
    func createNewUnit() -> Unit {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Unit
    }
    
    func getAll() -> [Unit] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let units = (try? managedObjectContext.fetch(fetchRequest)) as? [Unit]
        
        return units ?? []
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let units = (try? managedObjectContext.fetch(fetchRequest)) as? [Unit] ?? []
        
        deleteObjects(units)
    }
}
