//
//  StartEndTimestampsDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import CoreData
import UIKit

class StartEndTimestampsDao: CoreDataDao {
    
    let entityName:String
    
    required init() {
        entityName = String(describing: StartEndTimeStamps.self)
        super.init()
    }
    
    func createNewStartEndTimestamps() -> StartEndTimeStamps {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! StartEndTimeStamps
    }
    
    func createNewStartEndTimestamps(startStamp:Date?, endStamp:Date?) -> StartEndTimeStamps{
        let startEndTimestamps = createNewStartEndTimestamps()
        startEndTimestamps.startStamp = startStamp
        startEndTimestamps.endStamp = endStamp
        return startEndTimestamps
    }
    
    func getAll() -> [StartEndTimeStamps] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let startEndTimestampsList = (try? managedObjectContext.fetch(fetchRequest)) as? [StartEndTimeStamps]
        
        return startEndTimestampsList ?? []
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let startEndTimestampsList = (try? managedObjectContext.fetch(fetchRequest)) as? [StartEndTimeStamps] ?? []
        
        deleteObjects(startEndTimestampsList)
    }
}
