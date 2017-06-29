//  CoreDataMethods.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 03.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import Foundation
import CoreData

class CoreDataMethods
{
    let moc = AppDelegate.getManagedObjectContext()
    
    // Å LEGGE INN BRAIN I DENNE FILA ØDELEGGER APPLIKASJONEN --> let brain = SkallMenyBrain()
    
    /*
     FETCH
     */
    
    func fetchUserData() -> User{
        var userData = [UserData]()
        var user : User!
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            for item in userData {
                let tempUser = User(gender: item.gender! as Bool, weight: item.weight! as Double, beerCost: item.costsBeer! as Int, wineCost: item.costsWine! as Int, drinkCost: item.costsDrink! as Int, shotCost: item.costsShot! as Int)
                user = tempUser
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return user
    }
    
    func fetchTerminationTimeStamp() -> Date {
        var endTimeStamps = [TerminatedTimeStamp]()
        var returnedTerminatedStamp = Date()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TerminatedTimeStamp")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "terminatedTimeStamp", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            endTimeStamps = try moc.fetch(timeStampFetch) as! [TerminatedTimeStamp]
            for terminTimeStamp in endTimeStamps {
                let terminatedUnit : Date = terminTimeStamp.terminatedTimeStamp! as Date
                returnedTerminatedStamp = terminatedUnit
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return returnedTerminatedStamp
    }
    
    func fetchPlanPartySessionNr() -> Int{
        var historikk = [Historikk]()
        var tempFetchedSesNr : Int = 0
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                tempFetchedSesNr = timeStampItem.sessionNumber! as Int
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempFetchedSesNr
    }
    
    func fetchGoal() -> Double{
        var userData = [UserData]()
        var getGoalPromille = 0.0
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalPromille
    }
    
    func fetchGoalDate() -> Date{
        var userData = [UserData]()
        var getGoalDate = Date()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalDate = item.goalDate! as Date
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalDate
    }
    
    func getFirstUnitAddedTimeStamp() -> Date{
        var firstUnAdded = Date()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for row in historikk {
                firstUnAdded = row.firstUnitTimeStamp! as Date
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return firstUnAdded
    }
    
    func fetchLastPlannedNumberOfUnits() -> Double{
        var historikk = [Historikk]()
        var tempFetchedUnits : Double = 0
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                tempFetchedUnits = timeStampItem.plannedNrUnits! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempFetchedUnits
    }
    
    func fetchUnitCosts() -> [Int]{
        var timeStamps = [UserData]()
        
        var costsArray : [Int] = [Int]()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            timeStamps = try moc.fetch(timeStampFetch) as! [UserData]
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
    
    func getPlanPartySession() -> [Date]{
        var startEndStampArr = [StartEndTimeStamps]()
        var planPartyStamps : [Date] = [Date]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StartEndTimeStamps")
        do {
            startEndStampArr = try moc.fetch(timeStampFetch) as! [StartEndTimeStamps]
            for item in startEndStampArr {
                // START/END PLANLEGG KVELDEN STAMPS
                let start = item.startStamp! as Date
                planPartyStamps.append(start)
                let end = item.endStamp! as Date
                planPartyStamps.append(end)
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return planPartyStamps
    }
    
    /*
     UPDATE
     */
    
    func updateCoreDataHighPromille(_ updateHighestPromille: Double, addBeer: Int, addWine: Int, addDrink: Int, addShot: Int){
        var getCostsArray : [Int] = [Int]()
        getCostsArray = fetchUnitCosts()
        //let error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            let fetchResults = try moc.fetch(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                
                // Høyeste Promille:
                if(updateHighestPromille > (highPromi.hoyestePromille! as Double)){
                    highPromi.hoyestePromille! = NSNumber(value: updateHighestPromille)
                }
                
                // Endre Øl
                let beerCount = highPromi.antallOl! as Int
                let totalBeers = beerCount + addBeer
                highPromi.antallOl! = NSNumber(value: totalBeers)
                
                // Endre Vin
                let wineCount = highPromi.antallVin! as Int
                let totalWine = wineCount + addWine
                highPromi.antallVin! = NSNumber(value: totalWine)
                
                // Endre Drink
                let drinkCount = highPromi.antallDrink! as Int
                let totalDrink = drinkCount + addDrink
                highPromi.antallDrink! = NSNumber(value: totalDrink)
                
                // Endre Shot
                let shotCount = highPromi.antallShot! as Int
                let totalShot = shotCount + addShot
                highPromi.antallShot! = NSNumber(value: totalShot)
                
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
                highPromi.forbruk! = NSNumber(value: totalCosts)
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
    
    func updateTotalForbruk(_ totalForbruk: Double) -> Double{
        var totalForbruk = totalForbruk
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            
            for forbrukLoop in historikk {
                let forbruk = forbrukLoop.forbruk! as Double
                totalForbruk += forbruk
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalForbruk
    }
    
    func updateTotalHighestPromille(_ totalHighPromille: Double) -> Double{
        var totalHighPromille = totalHighPromille
        var historikk = [Historikk]()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                if(totalHighPromille < highestPromille){
                    totalHighPromille = highestPromille
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalHighPromille
    }
    
    func updateTotalAverageHighestPromille(_ totalAverageHighPromille: Double) -> Double{
        var totalAverageHighPromille = totalAverageHighPromille
        var historikk = [Historikk]()
        var sumHighPromille : Double = 0.0
        var countNumberOfHighPromilles : Double = 0.0
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            
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
    
    func lastMonthTotalForbruk(_ totalForbruk: Double) -> Double{
        var totalForbruk = totalForbruk
        var lastMonthArr : [Double] = [Double]()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            
            for forbrukLoop in historikk {
                let forbruk = forbrukLoop.forbruk! as Double
                let dates = forbrukLoop.dato! as Date
                
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
    
    func lastMonthHighestPromille(_ totalHighPromille: Double) -> Double{
        var totalHighPromille = totalHighPromille
        var lastMonthArr : [Double] = [Double]()
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                let dates = hoyProLoop.dato! as Date
                
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
    
    func lastMonthTotAvgHighProm(_ totalAverageHighPromille: Double) -> Double{
        var totalAverageHighPromille = totalAverageHighPromille
        var historikk = [Historikk]()
        var sumHighPromille : Double = 0.0
        var countNumberOfHighPromilles : Double = 0.0
        var lastMonthArr : [Double] = [Double]()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            
            for hoyProLoop in historikk {
                let highestPromille = hoyProLoop.hoyestePromille! as Double
                let dates = hoyProLoop.dato! as Date
                
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
        } catch {
            fatalError("bad things happened \(error)")
        }
        return totalAverageHighPromille
    }
    
    func checkDatesOneMonth(_ checkDate: Date) -> Bool{
        
        var isDateWithinMonth = false
        
        let calendar = Calendar.current
        // SJEKK DATOER INNEFOR 1 MÅNED
        var comps = DateComponents()
        // ANTALL DAGER BAK I TID DU SJEKKER ( SISTE 30 DAGER )
        comps.day = -30
        
        let date2 = (calendar as NSCalendar).date(byAdding: comps, to: Date(), options: NSCalendar.Options())
        //print("DATOE FOR 30 DAGER SIDEN: \(date2!)")
        if checkDate.compare(date2!) == ComparisonResult.orderedDescending
        {
            isDateWithinMonth = true
            //print("DATOEN ER INNENFOR 1 MÅNED")
        } else if checkDate.compare(date2!) == ComparisonResult.orderedAscending
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
    
    func updateUserDataPersonalia(_ updateGender: Bool, updateAge: Int, updateWeight: Double, updateHeight: String) -> String{
        //let error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let fetchResults = try moc.fetch(fetchRequest) as? [UserData]
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Gender
                userDataEntity.gender! = updateGender as NSNumber
                
                // Endre Alder
                userDataEntity.age! = NSNumber(value: updateAge)
                
                // Endre Vekt
                userDataEntity.weight! = NSNumber(value: updateWeight)
                
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
    
    func updateUserDataCosts(_ updateBeerCost: Int, updateWineCost: Int, updateDrinkCost: Int, updateShotCost: Int) -> String{
        //var error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let fetchResults = try moc.fetch(fetchRequest) as? [UserData]
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Øl
                userDataEntity.costsBeer! = NSNumber(value: updateBeerCost)
                
                // Endre Vin
                userDataEntity.costsWine! = NSNumber(value: updateWineCost)
                
                // Endre Drink
                userDataEntity.costsDrink! = NSNumber(value: updateDrinkCost)
                
                // Endre Shot
                userDataEntity.costsShot! = NSNumber(value: updateShotCost)
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
    
    func updateUserDataGoals(_ updateGoalPromille: Double, updateGoalDate: Date) -> String{
        //let error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let fetchResults = try moc.fetch(fetchRequest) as? [UserData]
            
            if let highPromilleStuff = fetchResults {
                let userDataEntity = highPromilleStuff[(fetchResults?.count)! - 1]
                // Endre Mål Promille
                userDataEntity.goalPromille! = NSNumber(value: updateGoalPromille)
                
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
    
    func updateGraphHighestProm(_ updateHighestPromille: Double){
        //let error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            let fetchResults = try moc.fetch(fetchRequest) as? [Historikk]
            if let highPromilleStuff = fetchResults {
                let highPromi = highPromilleStuff[(fetchResults?.count)! - 1]
                // Høyeste Promille:
                highPromi.hoyestePromille! = NSNumber(value: updateHighestPromille)
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
    
    /*
     DELETE
     */
    
    func clearCoreData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: moc)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try moc.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    moc.delete(result)
                }
                try moc.save()            }
        } catch {
            fatalError("failed to clear core data")
        }
    }
    
    func deleteLastItemAdded(_ lastAddedSesNr: Int) {
        var logItems = [Historikk]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "dato", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.fetch(fetchRequest) as? [Historikk] {
                logItems = fetchResults
                for items in logItems {
                    let tempSesNr = items.sessionNumber
                    var tempIndex = 0
                    
                    if let index = logItems.index(of: items) {
                        tempIndex = index
                    }
                    if(tempSesNr == NSNumber(value: lastAddedSesNr)){
                        moc.delete(logItems[tempIndex])
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
    
    func deleteLastGraphValue(_ lastAddedSesNr: Int) {
        var logItems = [GraphHistorikk]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GraphHistorikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "timeStampAdded", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.fetch(fetchRequest) as? [GraphHistorikk] {
                logItems = fetchResults
                for items in logItems {
                    let tempSesNr = items.sessionNumber
                    var tempIndex = 0
                    if let index = logItems.index(of: items) {
                        tempIndex = index
                    }
                    if(tempSesNr == NSNumber(value: lastAddedSesNr)){
                        moc.delete(logItems[tempIndex])
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
    
    func deleteCellGraphHistory(_ histSessionNr: Int) {
        var graphItems = [GraphHistorikk]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GraphHistorikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "timeStampAdded", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try moc.fetch(fetchRequest) as? [GraphHistorikk] {
                graphItems = fetchResults
                for items in graphItems {
                    let tempSesNr = items.sessionNumber
                    var tempIndex = 0
                    if let index = graphItems.index(of: items) {
                        tempIndex = index
                    }
                    if(tempSesNr == NSNumber(value: histSessionNr)){
                        moc.delete(graphItems[tempIndex])
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
    
    func deleteLastUnitAdded(_ unit:String){
        var timeStamp = [TimeStamp2]()
        var tempNr = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeStamp2")
        do {
            if let fetchResults = try moc.fetch(fetchRequest) as? [TimeStamp2] {
                timeStamp = fetchResults
                for units in timeStamp {
                    if(units.unitAlkohol == unit){
                        if let index = timeStamp.index(of: units) {
                            if(index > tempNr){
                                tempNr = index
                            }
                        }
                    }
                }
                moc.delete(timeStamp[tempNr])
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
    
    /*
     ADD ( SEED )
     */
    
    func seedHistoryValuesPlanParty(_ dato: Date, forbruk: Int, hoyestePromille: Double, antallOl: Int, antallVin: Int, antallDrink: Int, antallShot: Int, stringDato: String, endOfSesDate: Date, sessionNumber: Int, firstUnitStamp: Date, plannedNrOfUnits: Double) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Historikk", into: moc) as! Historikk
        
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
    
    func seedHistoryValues(_ dato: Date, forbruk: Int, hoyestePromille: Double, antallOl: Int, antallVin: Int, antallDrink: Int, antallShot: Int, stringDato: String, endOfSesDate: Date, sessionNumber: Int, firstUnitStamp: Date) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Historikk", into: moc) as! Historikk
        
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
    
    func seedStartEndTimeStamp(_ startStamp: Date, endStamp: Date) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StartEndTimeStamps", into: moc) as! StartEndTimeStamps
        
        entity.setValue(startStamp, forKey: "startStamp")
        entity.setValue(endStamp, forKey: "endStamp")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func seedTimeStamp(_ newTimeStamp: Date, unitAlcohol: String) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "TimeStamp2", into: moc) as! TimeStamp2
        
        entity.setValue(newTimeStamp, forKey: "timeStamp")
        entity.setValue(unitAlcohol, forKey: "unitAlkohol")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func seedGraphValues(_ timeStampAdded: Date, promPerMin: Double, sessionNumber: Int) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "GraphHistorikk", into: moc) as! GraphHistorikk
        
        entity.setValue(timeStampAdded, forKey: "timeStampAdded")
        entity.setValue(promPerMin, forKey: "currentPromille")
        entity.setValue(sessionNumber, forKey: "sessionNumber")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    /*
     OTHER
     */
    
    func entityIsEmpty(_ entity: String) -> Bool {
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        var results: NSArray?
        
        do {
            results = try moc.fetch(request) as NSArray?
            if let res = results {
                return res.count == 0
            } else {
                print("Error: fetch request returned nil")
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.debugDescription)")
            return true
        }
    }
    
    func checkHistorikk() -> Date{
        var historikk = [Historikk]()
        
        var isLatestHistorikkFetched = Date()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                isLatestHistorikkFetched = timeStampItem.dato! as Date
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return isLatestHistorikkFetched
    }
}
