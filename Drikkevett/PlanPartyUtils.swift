//
//  PlanPartyUtils.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 26.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import Foundation
import UIKit

class PlanPartyUtil {
    func setTextQuote(_ totalPromille: Double) -> String{
        var tempTextQuote = ""
        
        // HVA SKAL DET STÅ I TEKST FELTENE:
        if(totalPromille >= 0.0 && totalPromille < 0.4){
            tempTextQuote = "Kos deg!"
        }
        // LYKKE PROMILLE
        if(totalPromille >= 0.4 && totalPromille < 0.8){
            tempTextQuote = "Lykkepromille"
        }
        if(totalPromille >= 0.8 && totalPromille < 1.0){
            tempTextQuote = "Du blir mer kritikkløs og risikovillig"
        }
        if(totalPromille >= 1.0 && totalPromille < 1.2){
            tempTextQuote = "Balansen blir dårligere"
        }
        if(totalPromille >= 1.2 && totalPromille < 1.4){
            tempTextQuote = "Talen snøvlete og \nkontroll på bevegelser forverres"
        }
        if(totalPromille >= 1.4 && totalPromille < 1.8){
            tempTextQuote = "Man blir trøtt, sløv og \nkan bli kvalm"
        }
        if(totalPromille >= 1.8 && totalPromille < 3.0){
            tempTextQuote = "Hukommelsen sliter! "
        }
        if(totalPromille >= 3.0){
            tempTextQuote = "Svært høy promille! \nMan kan bli bevistløs!"
        }
        return tempTextQuote
    }
    
    func setTextQuoteColor(_ totalPromille: Double) -> UIColor{
        var tempQuoteColor = UIColor()
        
        if(totalPromille >= 0.0 && totalPromille < 0.4){
            tempQuoteColor = UIColor.white
        }
        // LYKKE PROMILLE
        if(totalPromille >= 0.4 && totalPromille < 0.8){
            tempQuoteColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        }
        if(totalPromille >= 0.8 && totalPromille < 1.0){
            tempQuoteColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
        }
        if(totalPromille >= 1.0 && totalPromille < 1.2){
            tempQuoteColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
        }
        if(totalPromille >= 1.2 && totalPromille < 1.4){
            tempQuoteColor = UIColor.orange
        }
        if(totalPromille >= 1.4 && totalPromille < 1.8){
            tempQuoteColor = UIColor.orange
        }
        if(totalPromille >= 1.8 && totalPromille < 3.0){
            tempQuoteColor = UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
        }
        if(totalPromille >= 3.0){
            tempQuoteColor = UIColor.red
        }
        
        return tempQuoteColor
    }
}
