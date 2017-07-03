//
//  UnitAddedDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import CoreData
import UIKit

class UnitAddedDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: TimeStamp2.self)
        super.init()
    }
    
    //Operations
    func createNewUnitAdded() -> TimeStamp2 {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! TimeStamp2
    }
    
    func createNewUnitAdded(timeStamp:Date?, unitAlkohol:String?) -> TimeStamp2{
        let unitAdded = createNewUnitAdded()
        unitAdded.timeStamp = timeStamp
        unitAdded.unitAlkohol = unitAlkohol
        return unitAdded
    }
    
    func getAll() -> [TimeStamp2] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let unitAddedList = (try? managedObjectContext.fetch(fetchRequest)) as? [TimeStamp2]
        
        return unitAddedList ?? []
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let unitAddedList = (try? managedObjectContext.fetch(fetchRequest)) as? [TimeStamp2] ?? []
        
        deleteObjects(unitAddedList)
    }
}
