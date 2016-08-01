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
    func setState(status : AnyObject){ // SETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(status, forKey: defaultKeys.statusKey)
        defaults.synchronize()
    }
    
    func getState() -> AnyObject{
        var tempStatus : AnyObject = Status.DEFAULT
        let defaults = NSUserDefaults.standardUserDefaults()
        if let status : AnyObject = defaults.objectForKey(defaultKeys.statusKey) {
            tempStatus = status
        }
        return tempStatus
    }
}