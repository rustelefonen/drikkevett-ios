//  SkallMenyBrain.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 24.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import Foundation
import CoreData
import UIKit

class SkallMenyBrain
{
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    let universalBeerGrams = 17.0
    let universalWineGrams = 13.5
    let universalDrinkGrams = 14.0
    let universalShotGrams = 17.0
    
    func checkHighestPromille(gender: Bool, weight: Double, endOfSesStamp: NSDate, terminatedStamp: NSDate, startOfSesStamp: NSDate) -> Double {
        var highestPromille : Double = 0.0
        var sum : Double = 0.0
        var valueBetweenTerminated : Double = 0.0
        var genderScore : Double = 0.0
        
        genderScore = setGenderScore(gender)
        
        var countIterasjons = 0
        var count = 0
        
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        // Check if an higher promille has accured between app termination and app start.
        let currentTimeStamp = NSDate()
        var intervalTerminatedToResumed : NSTimeInterval = NSTimeInterval()
        let checkIfSessionOver = endOfSesStamp.timeIntervalSinceDate(currentTimeStamp)
        if (checkIfSessionOver < 0.0){
            intervalTerminatedToResumed = endOfSesStamp.timeIntervalSinceDate(terminatedStamp)
        } else {
            intervalTerminatedToResumed = currentTimeStamp.timeIntervalSinceDate(terminatedStamp)
        }
        
        while(valueBetweenTerminated < intervalTerminatedToResumed){
            do {
                timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
                valueBetweenTerminated += 60
                
                countIterasjons += 1
                count = 0
                
                for unitOfAlcohol in timeStamps {
                    let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    let unit : String = unitOfAlcohol.unitAlkohol! as String
                    
                    count += 1
                    
                    let setOneMinFromUnitDate = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startOfSesStamp, options: NSCalendarOptions(rawValue: 0))!
                    
                    let intervallShiz = setOneMinFromUnitDate.timeIntervalSinceDate(timeStampTesting)
                    
                    if(intervallShiz <= 0){
                    } else {
                        // enhet lagt til
                        let convertMin = intervallShiz / 60
                        
                        var checkPromille : Double = 0.0
                        
                        let convertHours = convertMin / 60 as Double
                        if(unit == "Beer"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Wine"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Drink"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Shot"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        sum += checkPromille
                        if(sum > highestPromille){
                            highestPromille = sum
                        }
                    }
                }
                sum = 0
            } catch {
                fatalError("bad things happened \(error)")
            }
        }
        return highestPromille
    }
    
    func setGenderScore(gender: Bool) -> Double {
        var genderScore = 0.0
        if(gender == true) { // TRUE ER MANN
            genderScore = 0.70
        } else if (gender == false) { // FALSE ER KVINNE
            genderScore = 0.60
        }
        return genderScore
    }
    
    func liveUpdatePromille(weight: Double, gender: Bool, firstUnitAddedTimeS: NSDate) -> Double{
        print("Første enhet lagt til timestamp: \(firstUnitAddedTimeS)")
        
        var sum : Double = 0.0
        
        let genderScore = setGenderScore(gender)
        
        var beerCount = 0.0
        var wineCount = 0.0
        var drinkCount = 0.0
        var shotCount = 0.0
        
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        do {
            timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
            for unitOfAlcohol in timeStamps {
                //let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                let unit : String = unitOfAlcohol.unitAlkohol! as String
                
                if(unit == "Beer"){
                    beerCount += 1
                }
                if(unit == "Wine"){
                    wineCount += 1
                }
                if(unit == "Drink"){
                    drinkCount += 1
                }
                if(unit == "Shot"){
                    shotCount += 1
                }
                
                let totalGrams = countingGrams(beerCount, wineUnits: wineCount, drinkUnits: drinkCount, shotUnits: shotCount)
                
                let currentTimeStamp = NSDate()
                
                // FLYTTES OPP TIL PARAMETERET.
                //let firstUnitAddedTimeStamp = NSDate()
                
                // fra første enhet lagt til og opp til et kvarter kjør en fiktiv metode for promille
                let firstFifMinutesFromFirstUnitAdded = currentTimeStamp.timeIntervalSinceDate(firstUnitAddedTimeS)
                let convertToMin = firstFifMinutesFromFirstUnitAdded / 60
                let convertToHour = convertToMin / 60 as Double
                
                // FRA 0-15 MIN
                if(convertToHour <= 0.25){
                    sum = simulateFirstFifteen(convertToHour, totalUnits: (beerCount + wineCount + drinkCount + shotCount))
                }
                if(convertToHour > 0.25){
                    // 15 MIN OG OPPOVER
                    sum = calculatePromille(gender, weight: weight, grams: totalGrams, timer: convertToHour)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        if(sum < 0.0){
            sum = 0
        }
        return sum
    }
    
    func simulateFirstFifteen(timeDifference: Double, totalUnits: Double) -> Double{
        var BAC : Double = 0.0
        let minute : Double = (1.0 / 60.0 )
        
        if(timeDifference >= 0.0 && timeDifference <= minute){ // 1 min
            BAC = totalUnits * 0.01 // 50
        }
        if(timeDifference > minute && timeDifference <= (minute * 2)){ // 2 min
            BAC = Double(totalUnits) * 0.02 // 23.5
        }
        if(timeDifference > (minute * 2) && timeDifference <= (minute * 3)){ // 3 min
            BAC = Double(totalUnits) * 0.03 // 11.5
        }
        if(timeDifference > (minute * 3) && timeDifference <= (minute * 4)){ // 4 min
            BAC = Double(totalUnits) * 0.04 // 6.8
        }
        if(timeDifference > (minute * 4) && timeDifference <= (minute * 5)){ // 5 min
            BAC = Double(totalUnits) * 0.05 // 4.8
        }
        if(timeDifference > (minute * 5) && timeDifference <= (minute * 6)){ // 6 min
            BAC = Double(totalUnits) * 0.06 // 3.5
        }
        if(timeDifference > (minute * 6) && timeDifference <= (minute * 7)){ // 7 min
            BAC = Double(totalUnits) * 0.07 // 2.55
        }
        if(timeDifference > (minute * 7) && timeDifference <= (minute * 8)){ // 8 min
            BAC = Double(totalUnits) * 0.08 // 2.0
        }
        if(timeDifference > (minute * 8) && timeDifference <= (minute * 9)){ // 9 min
            BAC = Double(totalUnits) * 0.09 // 1.5
        }
        if(timeDifference > (minute * 9) && timeDifference <= (minute * 10)){ // 10 min
            BAC = Double(totalUnits) * 0.10 // 1.15
        }
        if(timeDifference > (minute * 10) && timeDifference <= (minute * 11)){ // 11 min
            BAC = Double(totalUnits) * 0.11 // 0.85
        }
        if(timeDifference > (minute * 11) && timeDifference <= (minute * 12)){ // 12 min
            BAC = Double(totalUnits) * 0.12 // 0.53
        }
        if(timeDifference > (minute * 12) && timeDifference <= (minute * 13)){ // 13 min
            BAC = Double(totalUnits) * 0.13 // 0.33
        }
        if(timeDifference > (minute * 13) && timeDifference <= (minute * 14)){ // 14 min
            BAC = Double(totalUnits) * 0.14 // 0.28
        }
        if(timeDifference > (minute * 14) && timeDifference <= (minute * 15)){ // 15 min
            BAC = Double(totalUnits) * 0.15 // 0.15
        }
        
        return BAC
    }
    
    // NOTIFICATIONS
    func randomNotification(keyWord: String) -> String{
        var quoteArray = [String]()
        
        if(keyWord == "First"){
            quoteArray =
                [
                    // etter 1 time
                    "Planlegger du inntaket, har du mer kontroll"
                    , "Alkohol tørker ut korppen. Drikk vann!"
                    , "Drikkevett i dag, bedre form i morgen"
                    , "Promillen stiger jevnere med mat i magen"
            ]
        }
        if(keyWord == "Second"){
            quoteArray =
                [
                    // etter 3 timer
                    "Det er vanlig å bli lettirritert av alkohol",
                    "Det er ingen skam å tåle minst",
                    "Visste du at akohol har masse kalorier? ",
                    "Treningsmål og alkohol er dårlig match",
                    "Er promillen over 1.4 kan du få blackout"
            ]
        }
        if(keyWord == "Third"){
            quoteArray =
                [
                    // etter 5 timer
                    "Sprit kan gjøre at du blir for full, for fort",
                    "Shotting er sjelden en god ide",
                    "Føler du at promillen er høy nok, bør du stoppe",
                    "Høy promille øker sjansen for å ta dumme valg"
            ]
        }
        if(keyWord == "Fourth"){
            quoteArray =
                [
                    // etter 7 timer
                    "Ikke legg det på stigende høy promille!",
                    "Ikke gjør noe du vil angre på",
                    "Har du drukket nok vann?",
                    "Ikke legg deg på tom mage, spis litt!"
            ]
        }
        let randomIndex = Int(arc4random_uniform(UInt32(quoteArray.count)))
        let finalString = quoteArray[randomIndex]
        return finalString
    }
    
    func checkPromilleFifteen(fromMinHour: Double, maxMin: Double, minMin: Double, weight: Double, gender: Double, grams: Double, promilleDown: Double) -> Double {
        var regneUtPromille = 0.0
        
        print("\nCheck Promille Fifteen: \(regneUtPromille)")
        if (fromMinHour > minMin && fromMinHour <= maxMin) {
            print("Promille Down: \(promilleDown)")
            
            print("FORMULA VALUES INSIDE CHECK PROMILLE FIFTEEN: ")
            print("GRAMS: \(grams), WEIGHT: \(weight), GENDER: \(gender), PROMILLEDOWN: \(promilleDown). FROM MIN HOUR: \(fromMinHour)")
            
            regneUtPromille = grams/(weight * gender) - (promilleDown * fromMinHour)
            
            print("regneutProm: \(regneUtPromille)")
            
            if (regneUtPromille < 0.0) {
                regneUtPromille = 0.0
                print("Promilla var under 0")
            }
        }
        print("Returned regneUtPromille: \(regneUtPromille)")
        return regneUtPromille
    }
    
    func checkPromilleLargerFifteen(fromMinHour: Double, minMin: Double, weight: Double, gender: Double, grams: Double, promilleDown: Double) -> Double {
        
        var regneUtPromille = 0.0
        
        if (fromMinHour > minMin) {
            print("Promille Down: \(promilleDown)")
            regneUtPromille = grams/(weight * gender) - (promilleDown * fromMinHour)
            if (regneUtPromille < 0.0) {
                regneUtPromille = 0.0
            }
        }
        print("checkPromLargerFif returned regneutProm : \(regneUtPromille)")
        return regneUtPromille
    }
    
    func calculatePromille(gender: Bool, weight: Double, grams: Double, timer: Double) -> Double{
        var genderScore : Double = 0.0
        var oppdatertPromille : Double = 0.0
        
        if(grams == 0.0){
            oppdatertPromille = 0.0
        } else {
            if(gender == true){
                genderScore = 0.70
            } else if (gender == false) {
                genderScore = 0.60
            }
            oppdatertPromille = grams/(weight * genderScore) - (0.15 * timer)
            
            if (oppdatertPromille < 0.0){
                oppdatertPromille = 0.0
            }
        }
        return oppdatertPromille
    }
    
    func countingGrams(beerUnits: Double, wineUnits: Double, drinkUnits: Double, shotUnits: Double) -> Double{
        let totalGrams = (beerUnits * universalBeerGrams) + (wineUnits * universalWineGrams) + (drinkUnits * universalDrinkGrams) + (shotUnits * universalShotGrams)
        return totalGrams
    }
    
    enum defKeyBool {
        static let isDayAfterRun = "dayAfterKey"
    }
    
    func setTextQuote(totalPromille: Double) -> String{
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
    
    func setTextQuoteColor(totalPromille: Double) -> UIColor{
        var tempQuoteColor = UIColor()
        
        // HVA SKAL DET STÅ I TEKST FELTENE:
        if(totalPromille >= 0.0 && totalPromille < 0.4){
            tempQuoteColor = UIColor.whiteColor()
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
            tempQuoteColor = UIColor.orangeColor()
        }
        if(totalPromille >= 1.4 && totalPromille < 1.8){
            tempQuoteColor = UIColor.orangeColor()
        }
        if(totalPromille >= 1.8 && totalPromille < 3.0){
            tempQuoteColor = UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
        }
        if(totalPromille >= 3.0){
            tempQuoteColor = UIColor.redColor()
        }
        
        return tempQuoteColor
    }
    
    func firstFifteen(timeFif: Double, weightFif: Double, genderFif: Double, unitAlco: String) -> Double{
        var checkPromille = 0.0
        var grams = 0.0
        
        let beerGrams = universalBeerGrams
        let wineGrams = universalWineGrams
        let drinkGrams = universalDrinkGrams
        let shotGrams = universalShotGrams
        
        let minute : Double = 1 / 60
        let twoMinute : Double = minute * 2
        let threeMinute : Double = minute * 3
        let fourMinute : Double = minute * 4
        let fiveMinute : Double = minute * 5
        let sixMinute : Double = minute * 6
        let sevenMinute : Double = minute * 7
        let eightMinute : Double = minute * 8
        let nineMinute : Double = minute * 9
        let tenMinute : Double = minute * 10
        let ellevenMinute : Double = minute * 11
        let twelveMinute : Double = minute * 12
        let thirteenMinute : Double = minute * 13
        let fourteenMinute : Double = minute * 14
        let fifteenMinute : Double = minute * 15
        
        if(unitAlco == "Beer"){
            grams = beerGrams
        }
        if(unitAlco == "Wine"){
            grams = wineGrams
        }
        if(unitAlco == "Drink"){
            grams = drinkGrams
        }
        if(unitAlco == "Shot"){
            grams = shotGrams
        }
        
        if(timeFif <= 0.085){
            checkPromille += 0
            print("Mindre enn 4 minutter...")
        }
        // FRA 4-15 MIN
        if(timeFif > 0.085 && timeFif <= 0.25){
            print("Fra 4 minutter til 15 minutter...")
            // 1 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: minute, minMin: 0.00, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 50.00)
            // 2 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: twoMinute, minMin: minute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 23.5)
            // 3 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: threeMinute, minMin: twoMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 11.5)
            // 4 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: fourMinute, minMin: threeMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 6.8)
            // 5 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: fiveMinute, minMin: fourMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 4.8)
            // 6 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: sixMinute, minMin: fiveMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 3.5)
            // 7 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: sevenMinute, minMin: sixMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 2.55)
            // 8 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: eightMinute, minMin: sevenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 2.0)
            // 9 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: nineMinute, minMin: eightMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 1.5)
            // 10 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: tenMinute, minMin: nineMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 1.15)
            // 11 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: ellevenMinute, minMin: tenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.85)
            // 12 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: twelveMinute, minMin: ellevenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.53)
            // 13 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: thirteenMinute, minMin: twelveMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.33)
            // 14 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: fourteenMinute, minMin: thirteenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.28)
            // 15 MIN
            checkPromille += checkPromilleFifteen(timeFif, maxMin: fifteenMinute, minMin: fourteenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.20)
        }
        if(timeFif > 0.25){
            print("Større enn et kvarter...")
            // 15 MIN OG OPPOVER
            checkPromille += checkPromilleLargerFifteen(timeFif, minMin: fifteenMinute, weight: weightFif, gender: genderFif, grams: beerGrams, promilleDown: 0.15)
        }
        print("firstFifteen checkPromille: \(checkPromille)")
        
        return checkPromille
    }
    
    func populateGraphValues(gender: Bool, weight: Double, startPlanStamp: NSDate, endPlanStamp: NSDate, sessionNumber: Int){
        var sum : Double = 0.0
        var valueBetweenTerminated : Double = 0.0
        var genderScore : Double = 0.0
        var datePerMin : NSDate = NSDate()
        var updateHighestPromhist = 0.0
        
        genderScore = setGenderScore(gender)
        
        var countIterasjons = 0
        var count = 0
        
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        let sesPlanKveldIntervall = endPlanStamp.timeIntervalSinceDate(startPlanStamp)
        
        while(valueBetweenTerminated < sesPlanKveldIntervall){
            do {
                timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
                
                count = 0
                var beer = 0.0
                var wine = 0.0
                var drink = 0.0
                var shot = 0.0
                
                datePerMin = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startPlanStamp, options: NSCalendarOptions(rawValue: 0))!
               
                let mathematicalDateFromStart = datePerMin.timeIntervalSinceDate(startPlanStamp)
                let convertMin = mathematicalDateFromStart / 60
                let convertHours = convertMin / 60 as Double
                for unitOfAlcohol in timeStamps {
                    let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    let unit : String = unitOfAlcohol.unitAlkohol! as String
                    
                    count += 1
                    
                    let intervallShiz = datePerMin.timeIntervalSinceDate(timeStampTesting)
                    let mathematicalDateFromStart = datePerMin.timeIntervalSinceDate(startPlanStamp)
                    
                    if(intervallShiz <= 0){
                        // enhet ikke lagt til
                    } else {
                        // enhet lagt til
                        let convertMin = intervallShiz / 60
                        var checkPromille : Double = 0.0
                        let convertHours = convertMin / 60 as Double
                        
                        if(unit == "Beer"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            beer += 1
                        }
                        if (unit == "Wine"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            wine += 1
                        }
                        if (unit == "Drink"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            drink += 1
                        }
                        if (unit == "Shot"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            shot += 1
                        }
                        sum += checkPromille
                    }
                }
                sum = 0
                
                let totalGrams = countingGrams(beer, wineUnits: wine, drinkUnits: drink, shotUnits: shot)
                sum += calculatePromille(gender, weight: weight, grams: totalGrams, timer: convertHours)
                
                if(sum > updateHighestPromhist){
                    updateHighestPromhist = sum
                    print("Lengde på sesjon: \(sesPlanKveldIntervall)")
                    brainCoreData.updateGraphHighestProm(updateHighestPromhist)
                }
                let tempSum = Double(sum).roundToPlaces(2)
                print("Double sum with 2 integers: \(tempSum)")
                if(sum <= 0){
                    sum = 0
                    brainCoreData.seedGraphValues(datePerMin, promPerMin: tempSum, sessionNumber: sessionNumber)
                } else {
                    brainCoreData.seedGraphValues(datePerMin, promPerMin: tempSum, sessionNumber: sessionNumber)
                }
                valueBetweenTerminated += 900
                
                countIterasjons += 15
                sum = 0
            } catch {
                fatalError("bad things happened \(error)")
            }
        }
    }
    
    func updateSpecificValue(isDateForekommet: NSDate, summelum: Double, datePerMin: NSDate, promPerMin: Double, sesNr: Int){
        var datesGraph = [GraphHistorikk]()
        
        let fetchRequest = NSFetchRequest(entityName: "GraphHistorikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "timeStampAdded", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [GraphHistorikk] {
                datesGraph = fetchResults
                for items in datesGraph {
                    print("GRAPH - GRAPH - GRAPH - GRAPH")
                    print("DATE HOME: \(items.timeStampAdded! as NSDate)")
                    let checkTimeStamp = items.timeStampAdded! as NSDate
                    if(checkTimeStamp.isEqualToDate(isDateForekommet)){
                        let currNr = items.currentPromille! as Double
                        print("Current value prom: \(currNr)")
                        let sumPromille = currNr + summelum
                        print("Sum promillen da: \(sumPromille)")
                        items.currentPromille! = sumPromille
                        print("ny sum promille er: \(items.currentPromille!)")
                    } else {
                        print("Legg til ny verdi")
                        brainCoreData.seedGraphValues(datePerMin, promPerMin: promPerMin, sessionNumber: sesNr)
                    }
                }
            }
            do {
                try moc.save()
            } catch {
                fatalError("failure to save timestamp: \(error)")
            }
        } catch {
            fatalError("HAHA; ITS CRASHED")
        }
    }
    
    func randomWord(wordArray: [String]) -> String{
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        let finalString = wordArray[randomIndex]
        return finalString
    }
    
    enum defaultKeysInst {
        static let boolKey = "notificationKey"
    }
    
    func calcualteTotalCosts(beer: Int, wine: Int, drink: Int, shot: Int, bPrice: Int, wPrice: Int, dPrice:Int, sPrice:Int) -> Int{
        var totalCost = 0
        totalCost = (beer * bPrice) + (wine * wPrice) + (drink * dPrice) + (shot * sPrice)
        return totalCost
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}