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
    func storedPlannedCounter(_ planCount: Double){
        let defaults = UserDefaults.standard
        defaults.set(planCount, forKey: defaultKeys.keyForPlannedCounter)
        defaults.synchronize()
    }
    
    func getPlannedCounter() -> Double {
        var tempPlanCounter : Double = 0.0
        let defaults = UserDefaults.standard
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let planCount : Double = defaults.double(forKey: defaultKeys.keyForPlannedCounter) {
            tempPlanCounter = planCount
        }
        return tempPlanCounter
    }
    
    func getFetchedValue() -> String{
        var tempFetchedValue = ""
        let defaults = UserDefaults.standard
        if let fetchedValue : AnyObject = defaults.object(forKey: defaultKeys.fetchUnitType) as AnyObject? {
            tempFetchedValue = fetchedValue as! String
        }
        return tempFetchedValue
    }
    
    func getPrevSessionNumber() -> Int{
        var tempPrevSes = 0
        let defaults = UserDefaults.standard
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let sessions : Int = defaults.integer(forKey: defaultKeys.numberOfSessions) {
            tempPrevSes = sessions
        }
        return tempPrevSes
    }
    
    func storeSessionNumber(_ sesNumber: Int){
        let defaults = UserDefaults.standard
        defaults.set(sesNumber, forKey: defaultKeys.numberOfSessions)
        defaults.synchronize()
    }
}
