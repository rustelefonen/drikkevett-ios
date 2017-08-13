//
//  NewHistoryDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class NewHistoryDao: CoreDataDao {
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: History.self)
        super.init()
    }
    
    func createNewHistory() -> History {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! History
    }
    
    func getAll() -> [History] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let histories = (try? managedObjectContext.fetch(fetchRequest)) as? [History]
        
        return histories ?? []
    }
    
    func getAllOrderedByDate() -> [History]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginDate", ascending: false)]
        
        let histories = (try? managedObjectContext.fetch(fetchRequest)) as? [History]
        
        return histories ?? []
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let histories = (try? managedObjectContext.fetch(fetchRequest)) as? [History] ?? []
        
        deleteObjects(histories)
    }
}
