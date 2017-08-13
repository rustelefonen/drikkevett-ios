//
//  HistoryUtility.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit



func calculateTotalCostBy(history:History) -> Int{
    var totalCost = 0
    if let units = history.units?.allObjects as? [Unit] {
        for unit in units {
            if unit.unitType == "Beer" {
                totalCost += Int(history.beerCost ?? 0)
            }
            else if unit.unitType == "Wine" {
                totalCost += Int(history.wineCost ?? 0)
            }
            else if unit.unitType == "Drink" {
                totalCost += Int(history.drinkCost ?? 0)
            }
            else if unit.unitType == "Shot" {
                totalCost += Int(history.shotCost ?? 0)
            }
        }
    }
    return totalCost
}
