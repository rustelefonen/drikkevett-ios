//
//  StatusNew.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

enum StatusNew {
    case DEFAULT
    case RUNNING
    case NOT_RUNNING
    case DA_RUNNING
    
    var name: String {
        get { return String(describing: self) }
    }
}
