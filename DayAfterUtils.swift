//
//  DayAfterUtils.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 29.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DayAfterUtils {
    
    let moc = AppDelegate.getManagedObjectContext()
    
    func getHighestBAC() -> Double{
        var historikk = [Historikk]()
        var tempHighestProm = 0.0
        
        let timeStampFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for hoyesteProm in historikk {
                tempHighestProm = hoyesteProm.hoyestePromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempHighestProm
    }
}
