//
//  StringExtension.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

extension String {
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) == nil
    }
    
    func isNumeric() -> Bool{
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
}
