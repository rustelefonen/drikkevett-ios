//
//  UserDefaultUtils.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 29.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultUtils {
    func storedPlannedCounter(planCount: Double){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(planCount, forKey: defaultKeys.keyForPlannedCounter)
        defaults.synchronize()
    }
    
    func getPlannedCounter() -> Double {
        var tempPlanCounter : Double = 0.0
        let defaults = NSUserDefaults.standardUserDefaults()
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let planCount : Double = defaults.doubleForKey(defaultKeys.keyForPlannedCounter) {
            tempPlanCounter = planCount
        }
        return tempPlanCounter
    }
    
    func getFetchedValue() -> String{
        var tempFetchedValue = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let fetchedValue : AnyObject = defaults.objectForKey(defaultKeys.fetchUnitType) {
            tempFetchedValue = fetchedValue as! String
        }
        return tempFetchedValue
    }
    
    func getPrevSessionNumber() -> Int{
        var tempPrevSes = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let sessions : Int = defaults.integerForKey(defaultKeys.numberOfSessions) {
            tempPrevSes = sessions
        }
        return tempPrevSes
    }
    
    func storeSessionNumber(sesNumber: Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(sesNumber, forKey: defaultKeys.numberOfSessions)
        defaults.synchronize()
    }
}