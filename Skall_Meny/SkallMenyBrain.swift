//  SkallMenyBrain.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 24.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

/*
 OVERSIKT:
 CMD - F = (Over-Overskriften du vil finne)
 
 0001 - ATTRIBUTTER
 0002 - HOME VIEW
 0003 - FIRST VIEW / PLANLEGG KVELDEN
 0004 - PROMILLE KALKULATOR
 0005 - DAGEN DERPÅ
 0006 - HISTORIKK
 0007 - INFORMASJON
 0008 - INSTILLINGER 
 
 */


import Foundation
import CoreData
import UIKit

class SkallMenyBrain
{
    ////////////////////////////////////////////////////////////////////////
    //                        ATTRIBUTTER (0001)                          //
    ////////////////////////////////////////////////////////////////////////
    
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // GRAMS
    let universalBeerGrams = 17.0
    let universalWineGrams = 13.5
    let universalDrinkGrams = 14.0
    let universalShotGrams = 17.0
    
    
    ////////////////////////////////////////////////////////////////////////
    //                          HOME VIEW (0002)                          //
    ////////////////////////////////////////////////////////////////////////
    
    //------------------------   LAST MONTH   ----------------------------//
    /*
    func checkDatesOneMonth(checkDate: NSDate) -> Bool{
        
        var isDateWithinMonth = false
        
        let calendar = NSCalendar.currentCalendar()
        // SJEKK DATOER INNEFOR 1 MÅNED
        let comps = NSDateComponents()
        // ANTALL DAGER BAK I TID DU SJEKKER ( SISTE 30 DAGER )
        comps.day = -6
        
        let date2 = calendar.dateByAddingComponents(comps, toDate: NSDate(), options: NSCalendarOptions())
        //print("DATOE FOR 30 DAGER SIDEN: \(date2!)")
        if checkDate.compare(date2!) == NSComparisonResult.OrderedDescending
        {
            isDateWithinMonth = true
            //print("DATOEN ER INNENFOR 1 MÅNED")
        } else if checkDate.compare(date2!) == NSComparisonResult.OrderedAscending
        {
            isDateWithinMonth = false
            //print("DATOEN ER LENGER UNNA ENN 1 MÅNED")
        } else
        {
            isDateWithinMonth = false
            //print("due in exactly a week (to the second, this will rarely happen in practice)")
        }
        return isDateWithinMonth
    }*/
    
    ////////////////////////////////////////////////////////////////////////
    //              FIRST VIEW / PLANLEGG KVELDEN (0003)                  //
    ////////////////////////////////////////////////////////////////////////
    
    func checkHighestPromille(gender: Bool, weight: Double, endOfSesStamp: NSDate, terminatedStamp: NSDate, startOfSesStamp: NSDate) -> Double {
        var highestPromille : Double = 0.0
        var sum : Double = 0.0
        var valueBetweenTerminated : Double = 0.0
        var genderScore : Double = 0.0
        
        if(gender == true) { // TRUE ER MANN
            genderScore = 0.70
        } else if (gender == false) { // FALSE ER KVINNE
            genderScore = 0.60
        }
        
        var countIterasjons = 0
        var count = 0
        
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        // Check if an higher promille has accured between app termination and app start.
        let currentTimeStamp = NSDate()
        
        var intervalTerminatedToResumed : NSTimeInterval = NSTimeInterval()
        
        var checkIfSessionOver = endOfSesStamp.timeIntervalSinceDate(currentTimeStamp)
        
        if (checkIfSessionOver < 0.0){
            intervalTerminatedToResumed = endOfSesStamp.timeIntervalSinceDate(terminatedStamp)
        } else {
            intervalTerminatedToResumed = currentTimeStamp.timeIntervalSinceDate(terminatedStamp)
        }
        
        while(valueBetweenTerminated < intervalTerminatedToResumed){
            do {
                timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
                
                // Henter ut verdier hvert (valg av sekunder) for å se hva promillen var på det tidspunkt
                valueBetweenTerminated += 60
                
                countIterasjons += 1
                
                print("\n\nIterasjoner: \(countIterasjons)(\(valueBetweenTerminated))\n")
                count = 0
                
                for unitOfAlcohol in timeStamps {
                    let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    let unit : String = unitOfAlcohol.unitAlkohol! as String
                    
                    count += 1
                    print("Timestamp nr: \(count)")
                    
                    let setOneMinFromUnitDate = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startOfSesStamp, options: NSCalendarOptions(rawValue: 0))!
                    
                    print("Timestamp: \(timeStampTesting) ---")
                    let intervallShiz = setOneMinFromUnitDate.timeIntervalSinceDate(timeStampTesting)
                    print("Tid fra unit til \(countIterasjons) min: \(intervallShiz)")
                    
                    // Hvis intervallshiz er negativ vil det si at enheten ikke enda er lagt til
                    if(intervallShiz <= 0){
                        // enhet ikke lagt til
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
                print("\n")
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
                let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
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
                print("Tid fra første enhet lagt til og fremover: \(convertToHour)")
                // deretter skip inn på den "vanlige" metoden
                // FRA 0-4 MIN
                if(convertToHour <= 0.085){
                    sum = 0
                    print("Mindre enn 4 minutter...")
                }
                // FRA 4-15 MIN
                if(convertToHour > 0.085 && convertToHour <= 0.25){
                    print("Fra 4 minutter til 15 minutter...")
                    sum = firstFifteen(convertToHour, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                }
                if(convertToHour > 0.25){
                    print("Større enn et kvarter...")
                    // 15 MIN OG OPPOVER
                    sum = calculatePromille(gender, weight: weight, grams: totalGrams, timer: convertToHour)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return sum
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
    
    func getPromille2(unitInGram: Double, arrayUnits: [NSDate], weight: Double, gender: Bool) -> Double{
        
        var sum : Double = 0.0
        var genderScore : Double = 0.0
        
        if(gender == true) { // TRUE ER MANN
            genderScore = 0.70
        } else if (gender == false) { // FALSE ER KVINNE
            genderScore = 0.60
        }
        
        var minute : Double = 1 / 60
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
        
        for timeStamp in arrayUnits {
            
            let currentTimeStamp = NSDate()
            
            // FLYTTES OPP TIL PARAMETERET.
            let firstUnitAddedTimeStamp = NSDate()
            
            let distanceBetweenStartNow = currentTimeStamp.timeIntervalSinceDate(timeStamp)
            let fromSecondsToMinutes = distanceBetweenStartNow / 60
            let fromMinutesToHours = fromSecondsToMinutes / 60 as Double
            
            // fra første enhet lagt til og opp til et kvarter kjør en fiktiv metode for promille
            let firstFifMinutesFromFirstUnitAdded = currentTimeStamp.timeIntervalSinceDate(firstUnitAddedTimeStamp)
            let convertToMin = firstFifMinutesFromFirstUnitAdded / 60
            let convertToHour = convertToMin / 60 as Double
            
            // deretter skip inn på den "vanlige" metoden
            
            if(convertToHour < 0.25){
                print("Less than a quarter...")
                // 1 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: minute, minMin: 0.00, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 50.00)
                // 2 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: twoMinute, minMin: minute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 23.5)
                // 3 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: threeMinute, minMin: twoMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 11.5)
                // 4 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: fourMinute, minMin: threeMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 6.8)
                // 5 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: fiveMinute, minMin: fourMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 4.8)
                // 6 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: sixMinute, minMin: fiveMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 3.5)
                // 7 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: sevenMinute, minMin: sixMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 2.55)
                // 8 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: eightMinute, minMin: sevenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 2.0)
                // 9 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: nineMinute, minMin: eightMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 1.5)
                // 10 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: tenMinute, minMin: nineMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 1.15)
                // 11 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: ellevenMinute, minMin: tenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.85)
                // 12 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: twelveMinute, minMin: ellevenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.53)
                // 13 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: thirteenMinute, minMin: twelveMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.33)
                // 14 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: fourteenMinute, minMin: thirteenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.28)
                // 15 MIN
                sum += checkPromilleFifteen(fromMinutesToHours, maxMin: fifteenMinute, minMin: fourteenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.20)
            } else {
                print("Larger than a quarter...")
                // 15 MIN OG OPPOVER
                sum += checkPromilleLargerFifteen(fromMinutesToHours, minMin: fifteenMinute, weight: weight, gender: genderScore, grams: unitInGram, promilleDown: 0.15)
            }
        }
        return sum
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
    
    ////////////////////////////////////////////////////////////////////////
    //                PROMILLE KALKULATOR (0003)                          //
    ////////////////////////////////////////////////////////////////////////
    
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
    
    ////////////////////////////////////////////////////////////////////////
    //                        DAGEN DERPÅ (0004)                          //
    ////////////////////////////////////////////////////////////////////////
    
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
    
    func populateGraphValues(gender: Bool, weight: Double, startPlanStamp: NSDate, endPlanStamp: NSDate){
        var sum : Double = 0.0
        var valueBetweenTerminated : Double = 0.0
        var genderScore : Double = 0.0
        var datePerMin : NSDate = NSDate()
        var updateHighestPromhist = 0.0
        
        if(gender == true) { // TRUE ER MANN
            genderScore = 0.70
        } else if (gender == false) { // FALSE ER KVINNE
            genderScore = 0.60
        }
        
        var countIterasjons = 0
        var count = 0
        
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        // SET FIRST VALUE TO BE 0
        // brainCoreData.seedGraphValues(startPlanStamp, promPerMin: 0, sessionNumber: brainCoreData.fetchPlanPartySessionNr())
        
        // SESJON PLANLEGG KVELDEN TIME INTEVALL
        let sesPlanKveldIntervall = endPlanStamp.timeIntervalSinceDate(startPlanStamp)
        print("Tolv timer skal det være: 120 sek ish: \(sesPlanKveldIntervall)")
        
        while(valueBetweenTerminated < sesPlanKveldIntervall){
            do {
                timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
                
                count = 0
                var beer = 0.0
                var wine = 0.0
                var drink = 0.0
                var shot = 0.0
                
                print("\n\nIterasjoner: \(countIterasjons)(\(valueBetweenTerminated))\n---------------\n")
                
                datePerMin = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startPlanStamp, options: NSCalendarOptions(rawValue: 0))!
               
                let mathematicalDateFromStart = datePerMin.timeIntervalSinceDate(startPlanStamp)
                let convertMin = mathematicalDateFromStart / 60
                var checkPromille : Double = 0.0
                let convertHours = convertMin / 60 as Double
                
                
                
                print("SjekkDato + \(countIterasjons) min =  \(datePerMin)")
                
                for unitOfAlcohol in timeStamps {
                    let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    let unit : String = unitOfAlcohol.unitAlkohol! as String
                    
                    count += 1
                    print("\nTimestamp nr: \(count)")
                    
                    /*datePerMin = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startPlanStamp, options: NSCalendarOptions(rawValue: 0))!
                    
                    print("Set one min from unit date: \(datePerMin)")*/
                    
                    print("Timestamp: \(timeStampTesting)")
                    let intervallShiz = datePerMin.timeIntervalSinceDate(timeStampTesting)
                    let mathematicalDateFromStart = datePerMin.timeIntervalSinceDate(startPlanStamp)
                    print("FROM START OF SES: \(mathematicalDateFromStart)")
                    
                    print("Tid fra unit til \(countIterasjons) min: \(intervallShiz)")
                    
                    // Hvis intervallshiz er negativ vil det si at enheten ikke enda er lagt til
                    if(intervallShiz <= 0){
                        // enhet ikke lagt til
                    } else {
                        // enhet lagt til
                        let convertMin = intervallShiz / 60
                        var checkPromille : Double = 0.0
                        let convertHours = convertMin / 60 as Double
                        print("ConvertHours: \(convertHours)")
                        if(unit == "Beer"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            print("beer checkprom: \(checkPromille)")
                            beer += 1
                        }
                        if (unit == "Wine"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            print("wine checkprom: \(checkPromille)")
                            wine += 1
                        }
                        if (unit == "Drink"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            print("drink checkprom: \(checkPromille)")
                            drink += 1
                        }
                        if (unit == "Shot"){
                            checkPromille += firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                            print("bshot checkprom: \(checkPromille)")
                            shot += 1
                        }
                        sum += checkPromille
                        print("sum+= checkProm inside popGraph: \(sum)")
                    }
                }
                print("\n\n\(datePerMin) - \(countIterasjons) UNITS:")
                print("Beers: \(beer)")
                print("Wines: \(wine)")
                print("Drinks: \(drink)")
                print("Shots: \(shot)\n\n")
                
                sum = 0
                
                let totalGrams = countingGrams(beer, wineUnits: wine, drinkUnits: drink, shotUnits: shot)
                sum += calculatePromille(gender, weight: weight, grams: totalGrams, timer: convertHours)
                
                let getSesNr = brainCoreData.fetchPlanPartySessionNr()
                print("Populate Graph dates: \(datePerMin)")
                print("Sesjon Number: \(getSesNr)")
                print("Sum: \(sum)")
                //sum += 1
                //print("sum + 1: \(sum)")
                if(sum > updateHighestPromhist){
                    updateHighestPromhist = sum
                    print("popGraph highProm: \(updateHighestPromhist)")
                    brainCoreData.updateGraphHighestProm(updateHighestPromhist)
                }
                
                if(sum <= 0){
                    sum = 0
                    print("if sum = 0: \(datePerMin), \(sum), \(brainCoreData.fetchPlanPartySessionNr())")
                    brainCoreData.seedGraphValues(datePerMin, promPerMin: sum, sessionNumber: brainCoreData.fetchPlanPartySessionNr())
                } else {
                    print("else: \(datePerMin), \(sum), \(brainCoreData.fetchPlanPartySessionNr())")
                    brainCoreData.seedGraphValues(datePerMin, promPerMin: sum, sessionNumber: brainCoreData.fetchPlanPartySessionNr())
                }
                // Henter ut verdier hvert (valg av sekunder) for å se hva promillen var på det tidspunkt
                valueBetweenTerminated += 900
                
                countIterasjons += 15
                sum = 0
                print("\n\nIterasjon STOPP: \(countIterasjons)(\(valueBetweenTerminated))\n------------------------\n")
                print("\n")
            } catch {
                fatalError("bad things happened \(error)")
            }
        }
    }
    
    // TESTING UPDATING SPECIFIC VALUE
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
                        var currNr = items.currentPromille! as Double
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
    
    ////////////////////////////////////////////////////////////////////////
    //                    GENERELLE METODER (0001)                        //
    ////////////////////////////////////////////////////////////////////////
    
    func randomWord(wordArray: [String]) -> String{
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        let finalString = wordArray[randomIndex]
        return finalString
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                  FORMATERING AV DATOER (0001)                      //
    ////////////////////////////////////////////////////////////////////////
    
    func getDayOfWeekAsString(today: NSDate?) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalender.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Søndag"
            case 2:
                return "Mandag"
            case 3:
                return "Tirsdag"
            case 4:
                return "Onsdag"
            case 5:
                return "Torsdag"
            case 6:
                return "Fredag"
            case 7:
                return "Lørdag"
            default:
                print("error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
    func getDateOfMonth(today: NSDate?)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Day, fromDate: todayDate)
            let weekDay = myComponents.day
            switch weekDay {
            case 1:
                return "1"
            case 2:
                return "2"
            case 3:
                return "3"
            case 4:
                return "4"
            case 5:
                return "5"
            case 6:
                return "6"
            case 7:
                return "7"
            case 8:
                return "8"
            case 9:
                return "9"
            case 10:
                return "10"
            case 11:
                return "11"
            case 12:
                return "12"
            case 13:
                return "13"
            case 14:
                return "14"
            case 15:
                return "15"
            case 16:
                return "16"
            case 17:
                return "17"
            case 18:
                return "18"
            case 19:
                return "19"
            case 20:
                return "20"
            case 21:
                return "21"
            case 22:
                return "22"
            case 23:
                return "23"
            case 24:
                return "24"
            case 25:
                return "25"
            case 26:
                return "26"
            case 27:
                return "27"
            case 28:
                return "28"
            case 29:
                return "29"
            case 30:
                return "30"
            case 31:
                return "31"
            default:
                print("Error fetching Date Of Month")
                return "Dag"
            }
        } else {
            return nil
        }
    }
    
    func getMonthOfYear(today:NSDate?)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Month, fromDate: todayDate)
            let month = myComponents.month
            switch month {
            case 1:
                return "Januar"
            case 2:
                return "Februar"
            case 3:
                return "Mars"
            case 4:
                return "April"
            case 5:
                return "Mai"
            case 6:
                return "Juni"
            case 7:
                return "Juli"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "Oktober"
            case 11:
                return "November"
            case 12:
                return "Desember"
            default:
                print("Error fetching months")
                return "Month"
            }
        } else {
            return nil
        }
    }
    
    func getTimeStamp() -> NSDate {
        let date = NSDate()
        return date
    }
    
    
    // ENUMERATIONS
    enum defaultKeysInst {
        static let boolKey = "notificationKey"
    }
}