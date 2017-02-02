//
//  GraphHistoryDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.02.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class GraphHistoryDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: GraphHistorikk.self)
        super.init()
    }
    
    //Operations
    func createNewGraphHistory() -> GraphHistorikk {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! GraphHistorikk
    }
    
    func createNewGraphHistory(timeStampAdded: Date?, currentPromille: NSNumber?, sessionNumber: NSNumber?) -> GraphHistorikk{
        let newGraphHistory = createNewGraphHistory()
        newGraphHistory.timeStampAdded = timeStampAdded
        newGraphHistory.currentPromille = currentPromille
        newGraphHistory.sessionNumber = sessionNumber
        return newGraphHistory
    }
    
    func getAll() -> [GraphHistorikk] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let graphHistories = (try? managedObjectContext.fetch(fetchRequest)) as? [GraphHistorikk]
        
        return graphHistories ?? []
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let graphHistories = (try? managedObjectContext.fetch(fetchRequest)) as? [GraphHistorikk] ?? []
        
        deleteObjects(graphHistories)
    }
    
}
