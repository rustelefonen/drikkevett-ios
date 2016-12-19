//
//  StatusUtils.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 29.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import UIKit

class StatusUtils{
    func setState(_ status : AnyObject){ // SETTING
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: defaultKeys.statusKey)
        defaults.synchronize()
    }
    
    func getState() -> AnyObject{
        var tempStatus : AnyObject = Status.DEFAULT as AnyObject
        let defaults = UserDefaults.standard
        if let status : AnyObject = defaults.object(forKey: defaultKeys.statusKey) as AnyObject? {
            tempStatus = status
        }
        return tempStatus
    }
}
