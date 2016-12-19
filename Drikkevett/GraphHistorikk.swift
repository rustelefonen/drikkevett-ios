//
//  GraphHistorikk.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 02.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import CoreData


class GraphHistorikk: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    @NSManaged var timeStampAdded: Date?
    @NSManaged var currentPromille: NSNumber?
    @NSManaged var sessionNumber: NSNumber?

}
