//
//  StringExtension.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int {
        return characters.count
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
