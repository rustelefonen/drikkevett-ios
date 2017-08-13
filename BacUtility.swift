//
//  BacUtility.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 10.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

func getQuoteTextBy(bac:Double) -> String {
    switch bac {
    case _ where bac < 0.2:
        return "Kos deg!"
    case 0.2..<0.3:
        return "Du begynner så vidt å merke at du har drukket."
    case 0.3..<0.4:
        return "Du føler deg lett påvirket."
    case 0.4..<0.6:
        return "De fleste kjenner seg avslappet."
    case 0.6..<0.8:
        return "Lykkepromille: Hevet stemningsleie og en følelse av velbehag, men man blir også mer impulsiv, kritikkløs og risikovillig."
    case 0.8..<1.0:
        return "Koordinasjon og balanse påvirkes. Drikker du mer nå vil de uønskede virkningene av alkoholen bli mer fremtredende enn de ønskede."
    case 1.0..<1.3:
        return "Balansen blir dårligere, man snakker snøvlete, og kontroll med bevegelser forverres."
    case 1.3..<1.5:
        return "Uønskede virkninger som kvalme, brekninger, tretthet og sløvhet øker. Mange blir også mer aggressive."
    case 1.5..<2.0:
        return "Hukommelsen sliter, faren for blackout øker."
    case 2.0..<2.5:
        return "Bevissthetsgraden senkes og man blir vanskelig å få kontakt med."
    case 2.5..<3.0:
        return "Bevisstløshet og pustehemning kan inntreffe."
    case 3.0..<4.0:
        return "Pustestans og død kan inntre. Risikoen for dette øker betydelig ved promille over 3."
    default:
        return "De aller fleste vil være døde ved promille over 4."
    }
}

func getQuoteRegisterTextBy(bac:Double) -> String {
    switch bac {
    case _ where bac < 0.2:
        return "Legg inn en langsiktig makspromille du ønsker å holde deg under. Makspromillen tilsvarer et promillenivå du ikke ønsker å gå over i løpet av én kveld/fest/drikkeepisode."
    case 0.2..<0.3:
        return "Du merker så vidt at du har drukket."
    case 0.3..<0.4:
        return "Du føler deg lett påvirket."
    case 0.4..<0.6:
        return "De fleste kjenner seg avslappet og man blir mer pratsom."
    case 0.6..<0.8:
        return "Lykkepromille: Hevet stemningsleie og en følelse av velbehag, men man blir også mer impulsiv, kritikkløs og risikovillig."
    case 0.8..<1.0:
        return "Koordinasjon og balanse påvirkes. Drikker du mer enn dette vil de uønskede virkningene av alkoholen bli mer fremtredende enn de ønskede."
    case 1.0..<1.3:
        return "Balansen blir dårligere, man snakker snøvlete, og kontroll med bevegelser forverres."
    case 1.3..<1.5:
        return "Uønskede virkninger som kvalme, brekninger, tretthet og sløvhet øker. Mange blir også mer aggressive."
    case 1.5..<2.0:
        return "Hukommelsen sliter, faren for blackout øker."
    case 2.0..<2.5:
        return "Bevissthetsgraden senkes og man blir vanskelig å få kontakt med."
    default:
        return "Bevisstløshet og pustehemning kan inntreffe."
    }
}

func getUIImageRegisterBy(bac:Double) -> UIImage? {
    switch bac {
    case _ where bac < 0.9:
        return UIImage(named: "Happy-100")
    case 0.9..<1.7:
        return UIImage(named: "Sad-100")
    default:
        return UIImage(named: "Vomited-100")
    }
}

func getQuoteTextColorBy(bac:Double) -> UIColor {
    switch bac {
    case _ where bac < 0.8:
        return UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
    case 0.8..<1.3:
        return UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
    case 1.3..<2.0:
        return UIColor.orange
    case 2.0..<3.0:
        return UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
    default:
        return UIColor.red
    }
}

func calculateBac(beerUnits:Double, wineUnits:Double, drinkUnits:Double, shotUnits:Double, hours:Double, weight:Double, gender:Bool) -> Double {
    let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
    
    let genderScore = gender ? 0.7 : 0.6
    
    let currentBac = (totalGrams/(weight * genderScore) - (0.15 * hours)).roundTo(places: 2)
    if currentBac < 0.0 {return 0.0}
    else {return currentBac}
}

func calculateAlcoholKiloCalories(beerUnits:Double, wineUnits:Double, drinkUnits:Double, shotUnits:Double) -> Double{
    let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
    
    return totalGrams * 7.0
}

func calculateAlcoholKiloJoules(beerUnits:Double, wineUnits:Double, drinkUnits:Double, shotUnits:Double) -> Double{
    let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
    
    return totalGrams * 29.3
}

func calculateTotalCost(beerUnits:Int, wineUnits:Int, drinkUnits:Int, shotUnits:Int) ->Int {
    guard let userData = AppDelegate.getUserData() else {return 0}
    
    return beerUnits * Int(userData.costsBeer ?? 0) + wineUnits * Int(userData.costsWine ?? 0) + drinkUnits * Int(userData.costsDrink ?? 0) + shotUnits * Int(userData.costsShot ?? 0)
}

func getUnitGrams(unitType:Int) -> Double{
    let defaults = UserDefaults.standard
    
    let savedPercentage = defaults.double(forKey: ResourceList.percentageKeys[unitType]) > 0.0 ? defaults.double(forKey: ResourceList.percentageKeys[unitType]) : ResourceList.defaultPercentage[unitType]
    let savedAmount = defaults.double(forKey: ResourceList.amountKeys[unitType]) > 0.0 ? defaults.double(forKey: ResourceList.amountKeys[unitType]) : ResourceList.defaultAmount[unitType]
    
    return savedAmount * savedPercentage / 10.0
}
