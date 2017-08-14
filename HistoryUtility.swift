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

func getHighestBacBy(history:History) ->Double {
    var addedBeerUnits = 0.0
    var addedWineUnits = 0.0
    var addedDrinkUnits = 0.0
    var addedShotUnits = 0.0
    
    if let units = history.units {
        for unit in units.allObjects as! [Unit] {
            if unit.unitType == "Beer" {
                addedBeerUnits += 1.0
            } else if unit.unitType == "Wine" {
                addedWineUnits += 1.0
            } else if unit.unitType == "Drink" {
                addedDrinkUnits += 1.0
            } else if unit.unitType == "Shot" {
                addedShotUnits += 1.0
            }
        }
    }
    
    let totalGrams = (addedBeerUnits * Double(history.beerGrams ?? 0.0)) + (addedWineUnits * Double(history.wineGrams ?? 0.0)) + (addedDrinkUnits * Double(history.drinkGrams ?? 0.0)) + (addedShotUnits * Double(history.shotGrams ?? 0.0))
    
    let genderScore = Bool(history.gender ?? 1) ? 0.7 : 0.6
    
    var highestBac = (totalGrams/(Double(history.weight ?? 0.0) * genderScore)).roundTo(places: 2)
    if highestBac < 0.0 {highestBac = 0.0}
    
    return highestBac
}

func getAllHistories() -> [History] {
    let histories = NewHistoryDao().getAll()
    var filteredHistories = [History]()
    
    for history in histories {
        if history.endDate != nil {
            filteredHistories.append(history)
        }
    }
    return filteredHistories
}
