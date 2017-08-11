//
//  PartyViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class PartyViewController: UIViewController {
    
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    @IBOutlet weak var endEveningView: UIView!
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    var drinkEpisodeViewController:DrinkEpisodeViewController?
    var userData:UserData?
    var updateTimer:Timer!
    
    static let partySegueId = "partySegueYo"
    
    let percentageKeys = ["BeerPercentage", "WinePercentage", "DrinkPercentage", "ShotPercentage"]
    let amountKeys = ["BeerAmount", "WineAmount", "DrinkAmount", "ShotAmount"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        userData = AppDelegate.getUserData()
        initPlannedUnits()
        initAddedUnits()
        endEveningView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEvening)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBac()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(updateTimer, forMode: RunLoopMode.commonModes)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        update()
        updateTimer.invalidate()
    }
    
    func handleEndEvening() {
        if !isWithinTheFirstFifteenMinutes() {
            displayEndEvening()
        }
        else {
            displayEndEveningFirstFifteen()
        }
    }
    
    func displayEndEveningFirstFifteen() {
        let refreshAlert = UIAlertController(title: "Avslutt kvelden", message: "Avslutter du kvelden innen 15 minutter vil ingen historikk lagres.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Avslutt kvelden", style: .destructive, handler: { (action: UIAlertAction!) in
            let startEndTimestampsDao = StartEndTimestampsDao()
            let startEndTimestamps = startEndTimestampsDao.getAll().first
            startEndTimestamps?.endStamp = Date()
            startEndTimestampsDao.save()
            self.drinkEpisodeViewController?.insertView()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func displayEndEvening() {
        let refreshAlert = UIAlertController(title: "Avslutt kvelden", message: "Er du sikker på at du vil avslutte kvelden?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Avslutt kvelden", style: .destructive, handler: { (action: UIAlertAction!) in
            self.endEvening()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func update() {
        updateBac()
        if getBac() <= 0.0 && getUnitCount() > 0 {
            print("ending evening")
            endEvening()
        }
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        let unitAddedDao = UnitAddedDao()
        _ = unitAddedDao.createNewUnitAdded(timeStamp: Date(), unitAlkohol: ResourceList.unitsEnglish[index])
        _ = unitAddedDao.save()
        
        modifyUnit(index: index, increment: true)
        updateBac()
        unitAddedAlertController(String(describing: ResourceList.units[index] + " drukket!"), message: "", delayTime: 0.8)
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: false)
    }
    
    func modifyUnit(index:Int, increment:Bool) {
        if index == 0 {
            guard let beerUnits = Int(String(describing: beerAmount.text!.components(separatedBy: "/").first!)) else {return}
            if increment && beerUnits < 20 {
                beerAmount.text = String(beerUnits + 1) + "/" + String(beerAmount.text!.components(separatedBy: "/").last!)
            }
            else if !increment && beerUnits > 0 {
                beerAmount.text = String(beerUnits - 1) + "/" + String(beerAmount.text!.components(separatedBy: "/").last!)
            }
        }
        else if index == 1 {
            guard let wineUnits = Int(String(describing: wineAmount.text!.components(separatedBy: "/").first!)) else {return}
            if increment && wineUnits < 20 {
                wineAmount.text = String(describing: wineUnits + 1) + "/" + String(wineAmount.text!.components(separatedBy: "/").last!)
            }
            else if !increment && wineUnits > 0 {
                wineAmount.text = String(describing: wineUnits - 1) + "/" + String(wineAmount.text!.components(separatedBy: "/").last!)
            }
        }
        else if index == 2 {
            guard let drinkUnits = Int(String(describing: drinkAmount.text!.components(separatedBy: "/").first!)) else {return}
            if increment && drinkUnits < 20 {
                drinkAmount.text = String(describing: drinkUnits + 1) + "/" + String(drinkAmount.text!.components(separatedBy: "/").last!)
            }
            else if !increment && drinkUnits > 0 {
                drinkAmount.text = String(describing: drinkUnits - 1) + "/" + String(drinkAmount.text!.components(separatedBy: "/").last!)
            }
        }
        else if index == 3 {
            guard let shotUnits = Int(String(describing: shotAmount.text!.components(separatedBy: "/").first!)) else {return}
            if increment && shotUnits < 20 {
                shotAmount.text = String(describing: shotUnits + 1) + "/" + String(shotAmount.text!.components(separatedBy: "/").last!)
            }
            else if !increment && shotUnits > 0 {
                shotAmount.text = String(describing: shotUnits - 1) + "/" + String(shotAmount.text!.components(separatedBy: "/").last!)
            }
        }
    }
    
    func initAddedUnits() {
        let unitsAdded = UnitAddedDao().getAll()
        
        var addedBeerUnits = 0
        var addedWineUnits = 0
        var addedDrinkUnits = 0
        var addedShotUnits = 0
        
        for unit in unitsAdded {
            if unit.unitAlkohol == ResourceList.unitsEnglish[0] {addedBeerUnits += 1}
            else if unit.unitAlkohol == ResourceList.unitsEnglish[1] {addedWineUnits += 1}
            else if unit.unitAlkohol == ResourceList.unitsEnglish[2] {addedDrinkUnits += 1}
            else if unit.unitAlkohol == ResourceList.unitsEnglish[3] {addedShotUnits += 1}
        }
        
        beerAmount.text = String(describing: addedBeerUnits) + String(beerAmount.text!.characters.dropFirst())
        wineAmount.text = String(describing: addedWineUnits) + String(wineAmount.text!.characters.dropFirst())
        drinkAmount.text = String(describing: addedDrinkUnits) + String(drinkAmount.text!.characters.dropFirst())
        shotAmount.text = String(describing: addedShotUnits) + String(shotAmount.text!.characters.dropFirst())
    }
    
    func initPlannedUnits() {
        let defaults = UserDefaults.standard
        beerAmount.text = String(beerAmount.text!.characters.dropLast()) + String(describing: defaults.integer(forKey: defaultKeys.beerKey))
        wineAmount.text = String(wineAmount.text!.characters.dropLast()) + String(describing: defaults.integer(forKey: defaultKeys.wineKey))
        drinkAmount.text = String(drinkAmount.text!.characters.dropLast()) + String(describing: defaults.integer(forKey: defaultKeys.drinkKey))
        shotAmount.text = String(shotAmount.text!.characters.dropLast()) + String(describing: defaults.integer(forKey: defaultKeys.shotKey))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.partySegueId {
            if segue.destination is SelectDrinkPageViewController {
                selectDrinkPageViewController = segue.destination as? SelectDrinkPageViewController
            }
        }
    }
    
    func updateBac() {
        guard let beerUnits = Double(String(describing: beerAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let wineUnits = Double(String(describing: wineAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let drinkUnits = Double(String(describing: drinkAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let shotUnits = Double(String(describing: shotAmount.text!.components(separatedBy: "/").first!)) else {return}
        let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
        
        guard let firstUnitAdded = getFirstUnitAdded() else {return}
        let hours = Double(Date().timeIntervalSince(firstUnitAdded)) / 3600.0
        
        guard let weight = userData?.weight as? Double else {return}
        guard let gender = userData?.gender as? Bool else {return}
        
        let currentBac = calculateBac(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits, hours: hours, weight: weight, gender: gender).roundTo(places: 2)
        
        bacLabel.text = String(describing: currentBac)
        bacLabel.textColor = getQuoteTextColorBy(bac: currentBac)
        quoteTextView.text = getQuoteTextBy(bac: currentBac)
        quoteTextView.textColor = getQuoteTextColorBy(bac: currentBac)
    }
    
    func getBac() -> Double {
        guard let beerUnits = Double(String(describing: beerAmount.text!.components(separatedBy: "/").first!)) else {return 0.0}
        guard let wineUnits = Double(String(describing: wineAmount.text!.components(separatedBy: "/").first!)) else {return 0.0}
        guard let drinkUnits = Double(String(describing: drinkAmount.text!.components(separatedBy: "/").first!)) else {return 0.0}
        guard let shotUnits = Double(String(describing: shotAmount.text!.components(separatedBy: "/").first!)) else {return 0.0}
        let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
        
        guard let firstUnitAdded = getFirstUnitAdded() else {return 0.0}
        let hours = Double(Date().timeIntervalSince(firstUnitAdded)) / 3600.0
        
        guard let weight = userData?.weight as? Double else {return 0.0}
        guard let gender = userData?.gender as? Bool else {return 0.0}
        
        let currentBac = calculateBac(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits, hours: hours, weight: weight, gender: gender).roundTo(places: 2)
        
        return currentBac
    }
    
    func getUnitCount() -> Int{
        guard let beerUnits = Int(String(describing: beerAmount.text!.components(separatedBy: "/").first!)) else {return 0}
        guard let wineUnits = Int(String(describing: wineAmount.text!.components(separatedBy: "/").first!)) else {return 0}
        guard let drinkUnits = Int(String(describing: drinkAmount.text!.components(separatedBy: "/").first!)) else {return 0}
        guard let shotUnits = Int(String(describing: shotAmount.text!.components(separatedBy: "/").first!)) else {return 0}
        
        return beerUnits + wineUnits + drinkUnits + shotUnits
    }
    
    func updateAmountLabel(label:UILabel, value:Int) {
        label.text = String(describing: value) + String(label.text!.characters.dropFirst())
    }
    
    func unitAddedAlertController(_ title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func endEvening() {
        guard let beerUnits = Int(String(describing: beerAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let wineUnits = Int(String(describing: wineAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let drinkUnits = Int(String(describing: drinkAmount.text!.components(separatedBy: "/").first!)) else {return}
        guard let shotUnits = Int(String(describing: shotAmount.text!.components(separatedBy: "/").first!)) else {return}
        
        if userData == nil {return}
        
        let totalCost = beerUnits * Int(userData!.costsBeer ?? 0) + wineUnits * Int(userData!.costsWine ?? 0) + drinkUnits * Int(userData!.costsDrink ?? 0) + shotUnits * Int(userData!.costsShot ?? 0)
        
        let endDate = Date()
        
        //Register session as ended
        let startEndTimestampsDao = StartEndTimestampsDao()
        let startEndTimestamps = startEndTimestampsDao.getAll().first
        startEndTimestamps?.endStamp = endDate
        startEndTimestampsDao.save()
        
        let startOfSessionStamp = getFirstUnitAdded()
        
        if startOfSessionStamp == nil {
            drinkEpisodeViewController?.insertView()
            return
        }
        
        //Register history
        let historyDao = HistoryDao()
        let history = historyDao.createNewHistory()
        
        history.dato = startEndTimestamps?.startStamp
        history.firstUnitTimeStamp = startOfSessionStamp
        history.forbruk = totalCost as NSNumber
        history.antallOl = beerUnits as NSNumber
        history.antallVin = wineUnits as NSNumber
        history.antallDrink = drinkUnits as NSNumber
        history.antallShot = shotUnits as NSNumber
        let dateUtil = DateUtil()
        history.datoTwo = dateUtil.getDayOfWeekAsString(startOfSessionStamp)! + dateUtil.getDateOfMonth(startOfSessionStamp)! + dateUtil.getMonthOfYear(startOfSessionStamp)!
        history.endOfSesDato = endDate
        
        let defaults = UserDefaults.standard
        history.sessionNumber = defaults.integer(forKey: defaultKeys.numberOfSessions) as NSNumber
        history.plannedNrUnits = (defaults.integer(forKey: defaultKeys.beerKey) + defaults.integer(forKey: defaultKeys.wineKey) + defaults.integer(forKey: defaultKeys.drinkKey) + defaults.integer(forKey: defaultKeys.shotKey)) as NSNumber
        
        //Register graph history
        let unitsAdded = UnitAddedDao().getAll()
        
        guard var tmpDate = startEndTimestamps?.startStamp else {return}
        guard let endStamp = startEndTimestamps?.endStamp else {return}
        var highestBac = 0.0
        
        
        while tmpDate < endStamp {
            let nextTmpDate = Calendar.current.date(byAdding: .minute, value: 15, to: tmpDate)!
            for unit in unitsAdded {
                
                var tmpBeerUnits = 0.0
                var tmpWineUnits = 0.0
                var tmpDrinkUnits = 0.0
                var tmpShotUnits = 0.0
                
                if (tmpDate...nextTmpDate).contains(unit.timeStamp!) {
                    if unit.unitAlkohol == ResourceList.unitsEnglish[0] {tmpBeerUnits += 1.0}
                    else if unit.unitAlkohol == ResourceList.unitsEnglish[1] {tmpWineUnits += 1.0}
                    else if unit.unitAlkohol == ResourceList.unitsEnglish[2] {tmpDrinkUnits += 1.0}
                    else if unit.unitAlkohol == ResourceList.unitsEnglish[3] {tmpShotUnits += 1.0}
                }
                
                let totalGrams = tmpBeerUnits * getUnitGrams(unitType: 0) + tmpWineUnits * getUnitGrams(unitType: 1) + tmpDrinkUnits * getUnitGrams(unitType: 2) + tmpShotUnits * getUnitGrams(unitType: 3)
                
                guard let weight = userData?.weight as? Double else {return}
                guard let gender = userData?.gender as? Bool else {return}
                let genderScore = gender ? 0.7 : 0.6
                
                let hours = Double(nextTmpDate.timeIntervalSince(startEndTimestamps!.startStamp!)) / 3600.0
                
                var currentBac = (totalGrams/(weight * genderScore) - (0.15 * hours)).roundTo(places: 2)
                if currentBac < 0.0 {currentBac = 0.0}
                
                if currentBac > highestBac {highestBac = currentBac}
                
                let graphHistoryDao = GraphHistoryDao()
                let graphHistory = graphHistoryDao.createNewGraphHistory()
                graphHistory.timeStampAdded = tmpDate
                graphHistory.currentPromille = currentBac as NSNumber
                graphHistory.sessionNumber = defaults.integer(forKey: defaultKeys.numberOfSessions) as NSNumber
                graphHistoryDao.save()
                
                tmpDate = nextTmpDate
            }
        }
        history.hoyestePromille = highestBac as NSNumber
        historyDao.save()
        
        drinkEpisodeViewController?.insertView()
        
    }
    
    func getFirstUnitAdded() -> Date? { //Denne er tung
        let unitsAdded = UnitAddedDao().getAll()
        var firstUnitAdded = unitsAdded.first?.timeStamp
        
        for unit in unitsAdded {
            if unit.timeStamp! < firstUnitAdded! {firstUnitAdded = unit.timeStamp}
        }
        return firstUnitAdded
    }
    
    func getUnitGrams(unitType:Int) -> Double{
        let defaults = UserDefaults.standard
        return defaults.double(forKey: amountKeys[unitType]) * defaults.double(forKey: percentageKeys[unitType]) / 10.0
    }
    
    func isWithinTheFirstFifteenMinutes() -> Bool {
        let startEndTimestampsDao = StartEndTimestampsDao()
        let startEndTimestamps = startEndTimestampsDao.getAll().first
        
        guard let sessionStart = startEndTimestamps?.startStamp else {return false}
        
        return Calendar.current.date(byAdding: .minute, value: 15, to: sessionStart)! > Date()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
 func endEvening() {
 guard let beerUnits = Int(String(describing: beerAmount.text!.characters.first!)) else {return}
 guard let wineUnits = Int(String(describing: wineAmount.text!.characters.first!)) else {return}
 guard let drinkUnits = Int(String(describing: drinkAmount.text!.characters.first!)) else {return}
 guard let shotUnits = Int(String(describing: shotAmount.text!.characters.first!)) else {return}
 
 if userData == nil {return}
 
 let totalCost = beerUnits * Int(userData!.costsBeer ?? 0) + wineUnits * Int(userData!.costsWine ?? 0) + drinkUnits * Int(userData!.costsDrink ?? 0) + shotUnits * Int(userData!.costsShot ?? 0)
 
 let startEndTimestampsDao = StartEndTimestampsDao()
 let startEndTimestamps = startEndTimestampsDao.getAll().first
 let startOfSessionStamp = startEndTimestamps?.startStamp
 startEndTimestampsDao.deleteAll()
 
 
 let defaults = UserDefaults.standard
 let dateFirstUnit = defaults.object(forKey: defaultKeys.storeFirstUnitAddedDate) as! Date
 
 
 let dateUtil = DateUtil()
 let fullDate = dateUtil.getDayOfWeekAsString(startOfSessionStamp)! + dateUtil.getDateOfMonth(startOfSessionStamp)! + dateUtil.getMonthOfYear(startOfSessionStamp)!
 
 let now = Date()
 
 let history = HistoryDao().createNewHistory()
 history.firstUnitTimeStamp = dateFirstUnit
 history.forbruk = totalCost as NSNumber
 history.hoyestePromille = 0.0 //HUMMMMMM
 history.antallOl = beerUnits as NSNumber
 history.antallVin = wineUnits as NSNumber
 history.antallDrink = drinkUnits as NSNumber
 history.antallShot = shotUnits as NSNumber
 history.datoTwo = fullDate
 history.endOfSesDato = now
 history.sessionNumber = defaults.integer(forKey: defaultKeys.numberOfSessions) as NSNumber
 history.plannedNrUnits = (defaults.integer(forKey: defaultKeys.beerKey) + defaults.integer(forKey: defaultKeys.wineKey) + defaults.integer(forKey: defaultKeys.drinkKey) + defaults.integer(forKey: defaultKeys.shotKey)) as NSNumber
 
 populateGraphValues(userData?.gender as! Bool, weight: userData?.weight as! Double, startPlanStamp: startOfSessionStamp!, endPlanStamp: now, sessionNumber: UserDefaults.standard.integer(forKey: defaultKeys.numberOfSessions))
 
 
 
 
 let _ = startEndTimestampsDao.createNewStartEndTimestamps(startStamp: startOfSessionStamp, endStamp: now)
 startEndTimestampsDao.save()
 
 //SETT TIL DA_RUNNING
 
 
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 func populateGraphValues(_ gender: Bool, weight: Double, startPlanStamp: Date, endPlanStamp: Date, sessionNumber: Int){
 var valueBetweenTerminated = 0.0
 var genderScore = 0.0
 var datePerMin = Date()
 var updateHighestPromhist = 0.0
 
 genderScore = gender ? 0.7 : 0.6
 
 var countIterasjons = 0
 
 var timeStamps = [TimeStamp2]()
 let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeStamp2")
 
 let sesPlanKveldIntervall = endPlanStamp.timeIntervalSince(startPlanStamp)
 
 while(valueBetweenTerminated < sesPlanKveldIntervall){
 do {
 timeStamps = try AppDelegate.getManagedObjectContext().fetch(timeStampFetch) as! [TimeStamp2]
 
 var beer = 0.0
 var wine = 0.0
 var drink = 0.0
 var shot = 0.0
 
 datePerMin = (Calendar.current as NSCalendar).date(byAdding: .minute, value: countIterasjons, to: startPlanStamp, options: NSCalendar.Options(rawValue: 0))!
 
 let mathematicalDateFromStart = datePerMin.timeIntervalSince(startPlanStamp)
 let convertMin = mathematicalDateFromStart / 60
 let convertHours = convertMin / 60 as Double
 for unitOfAlcohol in timeStamps {
 
 let timeStampTesting = unitOfAlcohol.timeStamp! as Date
 let unit = unitOfAlcohol.unitAlkohol! as String
 
 let intervallShiz = datePerMin.timeIntervalSince(timeStampTesting)
 let mathematicalDateFromStart = datePerMin.timeIntervalSince(startPlanStamp)
 
 if(intervallShiz > 0){
 if(unit == "Beer"){beer += 1}
 else if (unit == "Wine"){wine += 1}
 else if (unit == "Drink"){drink += 1}
 else if (unit == "Shot"){shot += 1}
 }
 }
 let totalGrams = (beer * universalBeerGrams) + (wine * universalWineGrams) + (drink * universalDrinkGrams) + (shot * universalShotGrams)
 
 var sum = calculatePromille(gender, weight: weight, grams: totalGrams, timer: convertHours)
 
 if(sum > updateHighestPromhist){
 updateHighestPromhist = sum
 
 let historyDao = HistoryDao()
 let history = historyDao.getAll().last
 history?.hoyestePromille = updateHighestPromhist as NSNumber
 }
 let tempSum = roundToPlaces(number: sum, 2)
 if(sum <= 0){sum = 0}
 
 let graphHistoryDao = GraphHistoryDao()
 let graphHistory = graphHistoryDao.createNewGraphHistory()
 graphHistory.timeStampAdded = datePerMin
 graphHistory.currentPromille = tempSum as NSNumber
 graphHistory.sessionNumber = sessionNumber as NSNumber
 graphHistoryDao.save()
 
 valueBetweenTerminated += 900
 countIterasjons += 15
 sum = 0
 } catch {
 fatalError("bad things happened \(error)")
 }
 }
 }
 
 func firstFifteen(_ timeFif: Double, weightFif: Double, genderFif: Double, unitAlco: String) -> Double{
 var checkPromille = 0.0
 var grams = 0.0
 
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
 
 if(unitAlco == "Beer"){grams = universalBeerGrams}
 else if(unitAlco == "Wine"){grams = universalWineGrams}
 else if(unitAlco == "Drink"){grams = universalDrinkGrams}
 else if(unitAlco == "Shot"){grams = universalShotGrams}
 
 if(timeFif <= 0.085){
 checkPromille += 0
 print("Mindre enn 4 minutter...")
 }
 // FRA 4-15 MIN
 else if(timeFif > 0.085 && timeFif <= 0.25){
 print("Fra 4 minutter til 15 minutter...")
 // 1 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: minute, minMin: 0.00, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 50.00)
 // 2 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: twoMinute, minMin: minute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 23.5)
 // 3 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: threeMinute, minMin: twoMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 11.5)
 // 4 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: fourMinute, minMin: threeMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 6.8)
 // 5 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: fiveMinute, minMin: fourMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 4.8)
 // 6 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: sixMinute, minMin: fiveMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 3.5)
 // 7 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: sevenMinute, minMin: sixMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 2.55)
 // 8 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: eightMinute, minMin: sevenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 2.0)
 // 9 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: nineMinute, minMin: eightMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 1.5)
 // 10 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: tenMinute, minMin: nineMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 1.15)
 // 11 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: ellevenMinute, minMin: tenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.85)
 // 12 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: twelveMinute, minMin: ellevenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.53)
 // 13 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: thirteenMinute, minMin: twelveMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.33)
 // 14 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: fourteenMinute, minMin: thirteenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.28)
 // 15 MIN
 checkPromille += checkPromilleFifteen(timeFif, maxMin: fifteenMinute, minMin: fourteenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.20)
 }
 else if(timeFif > 0.25){
 print("Større enn et kvarter...")
 // 15 MIN OG OPPOVER
 checkPromille += checkPromilleLargerFifteen(timeFif, minMin: fifteenMinute, weight: weightFif, gender: genderFif, grams: grams, promilleDown: 0.15)
 }
 print("firstFifteen checkPromille: \(checkPromille)")
 
 return checkPromille
 }
 
 func checkPromilleFifteen(_ fromMinHour: Double, maxMin: Double, minMin: Double, weight: Double, gender: Double, grams: Double, promilleDown: Double) -> Double {
 var regneUtPromille = 0.0
 
 if (fromMinHour > minMin && fromMinHour <= maxMin) {
 regneUtPromille = grams/(weight * gender) - (promilleDown * fromMinHour)
 
 if (regneUtPromille < 0.0) {regneUtPromille = 0.0}
 }
 return regneUtPromille
 }
 
 func checkPromilleLargerFifteen(_ fromMinHour: Double, minMin: Double, weight: Double, gender: Double, grams: Double, promilleDown: Double) -> Double {
 
 var regneUtPromille = 0.0
 
 if (fromMinHour > minMin) {
 regneUtPromille = grams/(weight * gender) - (promilleDown * fromMinHour)
 if (regneUtPromille < 0.0) {regneUtPromille = 0.0}
 }
 return regneUtPromille
 }
 
 func calculatePromille(_ gender: Bool, weight: Double, grams: Double, timer: Double) -> Double{
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
 
 func roundToPlaces(number:Double, _ places:Int) -> Double {
 let divisor = pow(10.0, Double(places))
 return round(number * divisor) / divisor
 }
 */
}
