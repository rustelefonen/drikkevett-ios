//
//  CoreDataDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.02.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDao {
    
    var managedObjectContext:NSManagedObjectContext
    
    required init(){
        managedObjectContext = AppDelegate.getManagedObjectContext()
    }
    
    func save() -> Bool{
        let result:Void? = try? managedObjectContext.save()
        return result == nil ? false : true
    }
    
    func delete(_ object:NSManagedObject){
        managedObjectContext.delete(object)
    }
    
    func deleteObjects(_ objects:[NSManagedObject]){
        for o in objects{
            delete(o)
        }
    }
}
