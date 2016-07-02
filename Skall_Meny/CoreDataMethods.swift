//  CoreDataMethods.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 03.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import Foundation
import CoreData

class CoreDataMethods
{
    ////////////////////////////////////////////////////////////////////////
    //                      ATTRIBUTTER (0001)                            //
    ////////////////////////////////////////////////////////////////////////
    
    let moc = DataController().managedObjectContext
    
    // Å LEGGE INN BRAIN I DENNE FILA ØDELEGGER APPLIKASJONEN
    //let brain = SkallMenyBrain()
    
    ////////////////////////////////////////////////////////////////////////
    //                   GENERELLE METODER (0006)                         //
    ////////////////////////////////////////////////////////////////////////
    
    func clearCoreData(entity:String) {
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
        fetchRequest.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try moc.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    moc.deleteObject(result)
                }
                
                try moc.save()
                print("\(entity) cleared in database...")
            }
        } catch {
            fatalError("failed to clear core data")
        }
    }
    
    func entityIsEmpty(entity: String) -> Bool
    {
        
        let context = moc
        let request = NSFetchRequest(entityName: entity)
        var results : NSArray?
        
        do {
            results = try context.executeFetchRequest(request)
            // success ...
            if let res = results
            {
                if res.count == 0
                {
                    return true
                }
                else
                {
                    return false
                }
            }
            else
            {
                print("Error: fetch request returned nil")
                return true
            }
        } catch let error as NSError {
            // failure
            print("Error: \(error.debugDescription)")
            return true
        }
    }
    
    func fetchHistorikk() {
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for row in historikk {
                print("Dato: \(row.dato!)")
                print("DatoTwo: \(row.datoTwo!)")
                print("Antall Øl: \(row.antallOl!)")
                print("Antall Vin: \(row.antallVin!)")
                print("Antall Drink: \(row.antallDrink!)")
                print("Antall Shot: \(row.antallShot!)")
                print("Forbruk: \(row.forbruk)")
                print("Høyeste Promille: \(row.hoyestePromille)")
                print("Sesjons Nummer: \(row.sessionNumber)")
                print("End of Sesjon date: \(row.endOfSesDato)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func printLastValueAddedHistorikk() {
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for row in historikk {
                print("Dato: \(row.dato!)")
                print("DatoTwo: \(row.datoTwo!)")
                print("Antall Øl: \(row.antallOl!)")
                print("Antall Vin: \(row.antallVin!)")
                print("Antall Drink: \(row.antallDrink!)")
                print("Antall Shot: \(row.antallShot!)")
                print("Forbruk: \(row.forbruk)")
                print("Høyeste Promille: \(row.hoyestePromille)")
                print("Sesjons Nummer: \(row.sessionNumber)")
                print("End of Sesjon date: \(row.endOfSesDato)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func printGraphValues() {
        var graph = [GraphHistorikk]()
        let timeStampFetch = NSFetchRequest(entityName: "GraphHistorikk")
        do {
            graph = try moc.executeFetchRequest(timeStampFetch) as! [GraphHistorikk]
            for row in graph {
                print("\n\nPrinted Graph Values")
                print("\nTimeStampAdded: \(row.timeStampAdded!)")
                print("Promille at the time: \(row.currentPromille!)")
                print("SesjonNumber: \(row.sessionNumber!)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                        HOME VIEW (0006)                            //
    ////////////////////////////////////////////////////////////////////////
    
    //---------------------------   TOTAL    -----------------------------//
    
    func updateTotalForbruk(var totalForbruk: Double) -> Double{
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            
            for forbrukLoop in historikk {
                print("Forbruk: \(forbrukLoop.forbruk!)")
                let forbruk = forbrukLoop.forbruk! as Double
                totalForbruk += forbruk
                print("Total forbruk: \(totalForbruk)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalForbruk
    }
    
    func updateTotalHighestPromille(var totalHighPromille: Double) -> Double{
        var historikk = [Historikk]()
        
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                print("HoyPro enhet: \(highestPromille)")
                if(totalHighPromille < highestPromille){
                    totalHighPromille = highestPromille
                    print("Total Highest Promille: \(totalHighPromille)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalHighPromille
    }
    
    func updateTotalAverageHighestPromille(var totalAverageHighPromille: Double) -> Double{
        var historikk = [Historikk]()
        var sumHighPromille : Double = 0.0
        var countNumberOfHighPromilles : Double = 0.0
        
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                sumHighPromille += highestPromille
                countNumberOfHighPromilles += 1
            }
            totalAverageHighPromille = sumHighPromille / countNumberOfHighPromilles
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalAverageHighPromille
    }
    
    //---------------------------   FORRIGE MÅNED   ----------------------//
    
    func lastMonthTotalForbruk(var totalForbruk: Double) -> Double{
        var lastMonthArr : [Double] = [Double]()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            
            for forbrukLoop in historikk {
                print("Forbruk: \(forbrukLoop.forbruk!)")
                let forbruk = forbrukLoop.forbruk! as Double
                let dates = forbrukLoop.dato! as NSDate
                
                let checkMonth = checkDatesOneMonth(dates)
                if(checkMonth == true){
                    lastMonthArr.append(forbruk)
                }
            }
            for forbruks in lastMonthArr {
                totalForbruk += forbruks
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalForbruk
    }
    
    func lastMonthHighestPromille(var totalHighPromille: Double) -> Double{
        var lastMonthArr : [Double] = [Double]()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                let dates = hoyProLoop.dato! as NSDate
                
                let checkMonth = checkDatesOneMonth(dates)
                if(checkMonth == true){
                    lastMonthArr.append(highestPromille)
                }
            }
            for highest in lastMonthArr {
                if(totalHighPromille < highest){
                    totalHighPromille = highest
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalHighPromille
    }
    
    func lastMonthTotAvgHighProm(var totalAverageHighPromille: Double) -> Double{
        var historikk = [Historikk]()
        var sumHighPromille : Double = 0.0
        var countNumberOfHighPromilles : Double = 0.0
        var lastMonthArr : [Double] = [Double]()
        
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                let dates = hoyProLoop.dato! as NSDate
                
                let checkMonth = checkDatesOneMonth(dates)
                if(checkMonth == true){
                    lastMonthArr.append(highestPromille)
                }
            }
            for promilles in lastMonthArr {
                sumHighPromille += promilles
                countNumberOfHighPromilles += 1
            }
            totalAverageHighPromille = sumHighPromille / countNumberOfHighPromilles
            print("Last Month Avg: \(totalAverageHighPromille)")
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalAverageHighPromille
    }
    
    func checkDatesOneMonth(checkDate: NSDate) -> Bool{
        
        var isDateWithinMonth = false
        
        let calendar = NSCalendar.currentCalendar()
        // SJEKK DATOER INNEFOR 1 MÅNED
        let comps = NSDateComponents()
        // ANTALL DAGER BAK I TID DU SJEKKER ( SISTE 30 DAGER )
        comps.day = -30
        
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
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                      FIRST VIEW (0006)                             //
    ////////////////////////////////////////////////////////////////////////
    
    func seedHistoryValuesPlanParty(dato: NSDate, forbruk: Int, hoyestePromille: Double, antallOl: Int, antallVin: Int, antallDrink: Int, antallShot: Int, stringDato: String, endOfSesDate: NSDate, sessionNumber: Int, firstUnitStamp: NSDate, plannedNrOfUnits: Double) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Historikk", inManagedObjectContext: moc) as! Historikk
        
        entity.setValue(dato, forKey: "dato")
        entity.setValue(forbruk, forKey: "forbruk")
        entity.setValue(hoyestePromille, forKey: "hoyestePromille")
        entity.setValue(antallOl, forKey: "antallOl")
        entity.setValue(antallVin, forKey: "antallVin")
        entity.setValue(antallDrink, forKey: "antallDrink")
        entity.setValue(antallShot, forKey: "antallShot")
        entity.setValue(stringDato, forKey: "datoTwo")
        entity.setValue(endOfSesDate, forKey: "endOfSesDato")
        entity.setValue(sessionNumber, forKey: "sessionNumber")
        entity.setValue(firstUnitStamp, forKey: "firstUnitTimeStamp")
        entity.setValue(plannedNrOfUnits, forKey: "plannedNrUnits")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func seedHistoryValues(dato: NSDate, forbruk: Int, hoyestePromille: Double, antallOl: Int, antallVin: Int, antallDrink: Int, antallShot: Int, stringDato: String, endOfSesDate: NSDate, sessionNumber: Int, firstUnitStamp: NSDate) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Historikk", inManagedObjectContext: moc) as! Historikk
        
        entity.setValue(dato, forKey: "dato")
        entity.setValue(forbruk, forKey: "forbruk")
        entity.setValue(hoyestePromille, forKey: "hoyestePromille")
        entity.setValue(antallOl, forKey: "antallOl")
        entity.setValue(antallVin, forKey: "antallVin")
        entity.setValue(antallDrink, forKey: "antallDrink")
        entity.setValue(antallShot, forKey: "antallShot")
        entity.setValue(stringDato, forKey: "datoTwo")
        entity.setValue(endOfSesDate, forKey: "endOfSesDato")
        entity.setValue(sessionNumber, forKey: "sessionNumber")
        entity.setValue(firstUnitStamp, forKey: "firstUnitTimeStamp")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    
    
    func seedStartEndTimeStamp(startStamp: NSDate, endStamp: NSDate) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("StartEndTimeStamps", inManagedObjectContext: moc) as! StartEndTimeStamps
        
        entity.setValue(startStamp, forKey: "startStamp")
        entity.setValue(endStamp, forKey: "endStamp")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    // fetches termination timeStamp
    func fetchTerminationTimeStamp() -> NSDate {
        var endTimeStamps = [TerminatedTimeStamp]()
        var returnedTerminatedStamp = NSDate()
        let timeStampFetch = NSFetchRequest(entityName: "TerminatedTimeStamp")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "terminatedTimeStamp", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            endTimeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TerminatedTimeStamp]
            for terminTimeStamp in endTimeStamps {
                let terminatedUnit : NSDate = terminTimeStamp.terminatedTimeStamp! as NSDate
                returnedTerminatedStamp = terminatedUnit
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return returnedTerminatedStamp
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                      DAGEN DERPÅ (0006)                            //
    ////////////////////////////////////////////////////////////////////////
    
    func fetchPlanPartySessionNr() -> Int{
        var historikk = [Historikk]()
        var tempFetchedSesNr : Int = 0
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                tempFetchedSesNr = timeStampItem.sessionNumber! as Int
                print("Sesjon NR fetchPlanPartySessionNr: \(tempFetchedSesNr)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempFetchedSesNr
    }
    
    func seedTimeStamp(newTimeStamp: NSDate, unitAlcohol: String) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("TimeStamp2", inManagedObjectContext: moc) as! TimeStamp2
        
        entity.setValue(newTimeStamp, forKey: "timeStamp")
        entity.setValue(unitAlcohol, forKey: "unitAlkohol")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func seedGraphValues(timeStampAdded: NSDate, promPerMin: Double, sessionNumber: Int) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("GraphHistorikk", inManagedObjectContext: moc) as! GraphHistorikk

        entity.setValue(timeStampAdded, forKey: "timeStampAdded")
        entity.setValue(promPerMin, forKey: "currentPromille")
        entity.setValue(sessionNumber, forKey: "sessionNumber")
        
        do {
            try moc.save()
            print("Graph Values Seeded...")
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func fetchUnitCosts() -> [Int]{
        var timeStamps = [UserData]()
        
        var costsArray : [Int] = [Int]()
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for costs in timeStamps {
                let beerCost : Int = costs.costsBeer! as Int
                costsArray.append(beerCost)
                let wineCost : Int = costs.costsWine! as Int
                costsArray.append(wineCost)
                let drinkCost : Int = costs.costsDrink! as Int
                costsArray.append(drinkCost)
                let shotCost : Int = costs.costsShot! as Int
                costsArray.append(shotCost)
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return costsArray
    }
    
    func updateCoreDataHighPromille(updateHighestPromille: Double, addBeer: Int, addWine: Int, addDrink: Int, addShot: Int){
        var getCostsArray : [Int] = [Int]()
        getCostsArray = fetchUnitCosts()
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                
                // Høyeste Promille:
                if(updateHighestPromille > (highPromi.hoyestePromille! as Double)){
                    highPromi.hoyestePromille! = updateHighestPromille
                }
                
                // Endre Øl
                let beerCount = highPromi.antallOl! as Int
                let totalBeers = beerCount + addBeer
                highPromi.antallOl! = totalBeers
                
                // Endre Vin
                let wineCount = highPromi.antallVin! as Int
                let totalWine = wineCount + addWine
                highPromi.antallVin! = totalWine
                
                // Endre Drink
                let drinkCount = highPromi.antallDrink! as Int
                let totalDrink = drinkCount + addDrink
                highPromi.antallDrink! = totalDrink
                
                // Endre Shot
                let shotCount = highPromi.antallShot! as Int
                let totalShot = shotCount + addShot
                highPromi.antallShot! = totalShot
                
                // Endre Kostnad
                let fetchBeerCosts = getCostsArray[0]
                let fetchWineCosts = getCostsArray[1]
                let fetchDrinkCosts = getCostsArray[2]
                let fetchShotCosts = getCostsArray[3]
                
                let totalBeerCost = fetchBeerCosts * totalBeers
                let totalWineCost = fetchWineCosts * totalWine
                let totalDrinkCost = fetchDrinkCosts * totalDrink
                let totalShotCost = fetchShotCosts * totalShot
                let totalCosts = totalBeerCost + totalWineCost + totalDrinkCost + totalShotCost
                highPromi.forbruk! = totalCosts
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    // TEMP STORE COSTS, BEER, WINE, DRINK, SHOT
    
    func tempStoreUnits(typeOfUnit: String) -> Int{
        var unit = 0
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                
                if(typeOfUnit == "Beer"){
                    // Endre Øl
                    let beerCount = highPromi.antallOl! as Int
                    let totalBeers = beerCount + 1
                    unit = totalBeers
                }
                if(typeOfUnit == "Wine"){
                    // Endre Vin
                    let wineCount = highPromi.antallVin! as Int
                    let totalWine = wineCount + 1
                    unit = totalWine
                }
                if(typeOfUnit == "Drink"){
                    // Endre Drink
                    let drinkCount = highPromi.antallDrink! as Int
                    let totalDrink = drinkCount + 1
                    unit = totalDrink
                }
                if(typeOfUnit == "Shot"){
                    // Endre Shot
                    let shotCount = highPromi.antallShot! as Int
                    let totalShot = shotCount + 1
                    unit = totalShot
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return unit
    }
    
    func tempStoreCosts(numBeer: Int, numWine: Int, numDrink: Int, numShot: Int) -> Int{
        var tempStoredCosts = 0
        var getCostsArray : [Int] = [Int]()
        getCostsArray = fetchUnitCosts()
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                
                // Endre Kostnad
                let fetchBeerCosts = getCostsArray[0]
                let fetchWineCosts = getCostsArray[1]
                let fetchDrinkCosts = getCostsArray[2]
                let fetchShotCosts = getCostsArray[3]
                
                let totalBeerCost = fetchBeerCosts * numBeer
                let totalWineCost = fetchWineCosts * numWine
                let totalDrinkCost = fetchDrinkCosts * numDrink
                let totalShotCost = fetchShotCosts * numShot
                let totalCosts = totalBeerCost + totalWineCost + totalDrinkCost + totalShotCost
                tempStoredCosts = totalCosts
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempStoredCosts
    }
    
    
    
    
    func updateGraphHighestProm(updateHighestPromille: Double){
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                // Høyeste Promille:
                highPromi.hoyestePromille! = updateHighestPromille
                print("highPromi.hoyestePromille!: \(highPromi.hoyestePromille!) = updateHighestPromille + 3: \(updateHighestPromille)")
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func checkHistorikk() -> NSDate{
        var historikk = [Historikk]()
        
        var isLatestHistorikkFetched = NSDate()
        
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                isLatestHistorikkFetched = timeStampItem.dato!
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return isLatestHistorikkFetched
    }
    
    func setDagenDerpaSession() -> NSDate {
        var startEndStampArr = [StartEndTimeStamps]()
        var endDDStamp = NSDate()
        
        let timeStampFetch = NSFetchRequest(entityName: "StartEndTimeStamps")
        do {
            startEndStampArr = try moc.executeFetchRequest(timeStampFetch) as! [StartEndTimeStamps]
            for item in startEndStampArr {
                // START/END DAGEN-DERPÅ STAMPS
                let startDagenDerpaStamp = item.endStamp! as NSDate
                endDDStamp = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 12, toDate: startDagenDerpaStamp, options: NSCalendarOptions(rawValue: 0))!
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return endDDStamp
    }
    
    func getPlanPartySession() -> [NSDate]{
        var startEndStampArr = [StartEndTimeStamps]()
        var planPartyStamps : [NSDate] = [NSDate]()
        let timeStampFetch = NSFetchRequest(entityName: "StartEndTimeStamps")
        do {
            startEndStampArr = try moc.executeFetchRequest(timeStampFetch) as! [StartEndTimeStamps]
            for item in startEndStampArr {
                // START/END PLANLEGG KVELDEN STAMPS
                let start = item.startStamp! as NSDate
                planPartyStamps.append(start)
                let end = item.endStamp! as NSDate
                planPartyStamps.append(end)
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return planPartyStamps
    }
    
    func deleteLastItemAdded(lastAddedSesNr: Int) {
        var logItems = [Historikk]()
        
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "dato", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Historikk] {
                logItems = fetchResults
                for items in logItems {
                    let tempSesNr = items.sessionNumber
                    print("\n\n\n deleteLastItemAdded: \n")
                    print("Sesjonsnummer HOME: \(tempSesNr)")
                    
                    
                    /*
                     
                     NÅR JEG KOMMER HJEM FLYTT IFFEN OG DET UNDER INN I DEN ANDRE IFFEN!!!!!!!!
                     
                     */
                    //var index = 0
                    var tempIndex = 0
                    
                    if let index = logItems.indexOf(items) {
                        print("Testing if let index nr: \(index)")
                        
                        tempIndex = index
                        
                        //moc.deleteObject(logItems[index])
                    }
                    print("This is TEMPindex: \(tempIndex)")
                    
                    if(tempSesNr == lastAddedSesNr){
                        print("sesjons nr er like: \(tempSesNr!) == \(lastAddedSesNr)")
                        //let indexNr = logItems.indexOf(items)
                        //print("IndexNr before if: \(indexNr)")
                        //let indexNr = logItems.indexOf(items)
                        //print("Alle med index nr (\(items.sessionNumber as! Int)) har indexNr: \(indexNr)")
                        
                        print("temp Index inside if: \(tempIndex)")
                        print("logItemsTempIndex: \(logItems[tempIndex])")
                        
                        moc.deleteObject(logItems[tempIndex])
                        print("moc.deleteObject...")
                    }
                }
            }
            //printGraphValues()
            do {
                try moc.save()
            } catch {
                fatalError("failure to save timestamp: \(error)")
            }
        } catch {
            fatalError("HAHA; ITS CRASHED")
        }
    }
    
    func deleteLastGraphValue(lastAddedSesNr: Int) {
        var logItems = [GraphHistorikk]()
        
        let fetchRequest = NSFetchRequest(entityName: "GraphHistorikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "timeStampAdded", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [GraphHistorikk] {
                logItems = fetchResults
                for items in logItems {
                    let tempSesNr = items.sessionNumber
                    print("\n\n\n DELETE GRAPH VALUES: \n")
                    print("Sesjonsnummer HOME: \(tempSesNr)")
                    var tempIndex = 0
                    if let index = logItems.indexOf(items) {
                        print("Testing if let index nr: \(index)")
                        tempIndex = index
                    }
                    print("This is TEMPindex: \(tempIndex)")
                    
                    if(tempSesNr == lastAddedSesNr){
                        print("sesjons nr er like: \(tempSesNr!) == \(lastAddedSesNr)")
                        print("temp Index inside if: \(tempIndex)")
                        print("logItemsTempIndex: \(logItems[tempIndex])")
                        moc.deleteObject(logItems[tempIndex])
                        print("moc.deleteObject...")
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
    //              OPPDATER BRUKERINFO/COSTS OG MÅL (0006)               //
    ////////////////////////////////////////////////////////////////////////
    
    // UPDATE PERSONALIA
    func updateUserDataPersonalia(updateGender: Bool, updateAge: Int, updateWeight: Double, updateHeight: String) -> String{
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [UserData]
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Gender
                userDataEntity.gender! = updateGender
                
                // Endre Alder
                userDataEntity.age! = updateAge
                
                // Endre Vekt
                userDataEntity.weight! = updateWeight
                
                // Endre Høyde
                userDataEntity.height! = updateHeight
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return "UserData updated..."
    }
    
    // UPDATE COSTS
    func updateUserDataCosts(updateBeerCost: Int, updateWineCost: Int, updateDrinkCost: Int, updateShotCost: Int) -> String{
        //var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [UserData]
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Øl
                userDataEntity.costsBeer! = updateBeerCost
                
                // Endre Vin
                userDataEntity.costsWine! = updateWineCost
                
                // Endre Drink
                userDataEntity.costsDrink! = updateDrinkCost
                
                // Endre Shot
                userDataEntity.costsShot! = updateShotCost
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return "UserData updated..."
    }
    
    // UPDATE GOALS
    func updateUserDataGoals(updateGoalPromille: Double, updateGoalDate: NSDate) -> String{
        //let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [UserData]
            
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Mål Promille
                userDataEntity.goalPromille! = updateGoalPromille
                
                // Endre Mål Dato
                userDataEntity.goalDate! = updateGoalDate
                
                do {
                    try moc.save()
                } catch {
                    fatalError("failure to save timestamp: \(error)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return "UserData updated..."
    }
    
    // GET GOAL
    func fetchGoal() -> Double{
        var userData = [UserData]()
        var getGoalPromille = 0.0
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalPromille
    }
    
    // GET GOALDATE
    func fetchGoalDate() -> NSDate{
        var userData = [UserData]()
        var getGoalDate = NSDate()
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalDate = item.goalDate! as NSDate
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalDate
    }
    
    // GET FIRST UNIT ADDED TIMESTAMP
    func getFirstUnitAddedTimeStamp() -> NSDate{
        var firstUnAdded = NSDate()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for row in historikk {
                firstUnAdded = row.firstUnitTimeStamp! as NSDate
                print("Dato: \(row.firstUnitTimeStamp!)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return firstUnAdded
    }
    
    func fetchLastPlannedNumberOfUnits() -> Double{
        var historikk = [Historikk]()
        var tempFetchedUnits : Double = 0
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                tempFetchedUnits = timeStampItem.plannedNrUnits! as Double
                print("Planlagte drikkede enheter: \(tempFetchedUnits)")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempFetchedUnits
    }
    
    func hasGoalDateBeenOrIs(checkDate: NSDate) -> Bool{
        
        var hasGoalDateBeen = false
        
        let calendar = NSCalendar.currentCalendar()
        // SJEKK DATOER INNEFOR 1 MÅNED
        let comps = NSDateComponents()
        // ANTALL DAGER BAK I TID DU SJEKKER ( SISTE 30 DAGER )
        comps.day = 1
        
        let date2 = calendar.dateByAddingComponents(comps, toDate: NSDate(), options: NSCalendarOptions())
        //print("DATOE FOR 30 DAGER SIDEN: \(date2!)")
        if checkDate.compare(date2!) == NSComparisonResult.OrderedDescending
        {
            hasGoalDateBeen = true
            //print("DATOEN ER INNENFOR 1 MÅNED")
        } else if checkDate.compare(date2!) == NSComparisonResult.OrderedAscending
        {
            hasGoalDateBeen = false
            //print("DATOEN ER LENGER UNNA ENN 1 MÅNED")
        } else
        {
            hasGoalDateBeen = false
            //print("due in exactly a week (to the second, this will rarely happen in practice)")
        }
        return hasGoalDateBeen
    }
}