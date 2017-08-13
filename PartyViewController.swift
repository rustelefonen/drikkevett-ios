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
    
    var hasBeenWarned = false
    
    var history:History?
    
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
        /*if !isWithinTheFirstFifteenMinutes() {displayEndEvening()}
        else {displayEndEveningFirstFifteen()}*/
        
        endEvening()
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
        
        let unitDao = UnitDao()
        let unit = unitDao.createNewUnit()
        unit.timeStamp = Date()
        
        switch index {
        case 0:
            unit.unitType = "Beer"
        case 1:
            unit.unitType = "Wine"
        case 2:
            unit.unitType = "Drink"
        default:
            unit.unitType = "Shot"
        }
        
        history?.addToUnits(unit)
        unitDao.save()
        
        modifyUnit(index: index, increment: true)
        updateBac()
        unitAddedAlertController(String(describing: ResourceList.units[index] + " drukket!"), message: "", delayTime: 0.8)
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let unitDao = UnitDao()
        let unit = getLastAddedUnit()
        
        var index = 0
        if unit?.unitType == "Beer" {index = 0}
        else if unit?.unitType == "Wine" {index = 1}
        else if unit?.unitType == "Drink" {index = 2}
        else if unit?.unitType == "Shot" {index = 3}
        
        if let currentHistory = history {
            if let units = history?.units {
                let mutable = NSMutableSet(set: units)
                mutable.remove(unit)
                history?.units = mutable
            }
            
        }
        unitDao.delete(unit!)
        
        unitDao.save()
        modifyUnit(index: index, increment: false)
    }
    
    func getLastAddedUnit() -> Unit?{
        guard let currentHistory = history else {return nil}
        
        var lastAddedUnit:Unit?
        
        if let currentHistory = history {
            let units = currentHistory.units?.allObjects as! [Unit]
            
            lastAddedUnit = units.first
            
            for unit in units {
                if unit.timeStamp! > (lastAddedUnit!.timeStamp)! {
                    lastAddedUnit = unit
                }
            }
        }
        return lastAddedUnit
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
        var addedBeerUnits = 0
        var addedWineUnits = 0
        var addedDrinkUnits = 0
        var addedShotUnits = 0
        
        if let currentHistory = history {
            if let units = currentHistory.units {
                for unit in units.allObjects as! [Unit] {
                    if unit.unitType == "Beer" {
                        addedBeerUnits += 1
                    } else if unit.unitType == "Wine" {
                        addedWineUnits += 1
                    } else if unit.unitType == "Drink" {
                        addedDrinkUnits += 1
                    } else if unit.unitType == "Shot" {
                        addedShotUnits += 1
                    }
                }
            }
        }
        beerAmount.text = String(describing: addedBeerUnits) + String(beerAmount.text!.characters.dropFirst())
        wineAmount.text = String(describing: addedWineUnits) + String(wineAmount.text!.characters.dropFirst())
        drinkAmount.text = String(describing: addedDrinkUnits) + String(drinkAmount.text!.characters.dropFirst())
        shotAmount.text = String(describing: addedShotUnits) + String(shotAmount.text!.characters.dropFirst())
        
    }
    
    func initPlannedUnits() {
        if let currentHistory = history {
            beerAmount.text = String(beerAmount.text!.characters.dropLast()) + String(describing: currentHistory.plannedBeerCount ?? 0)
            wineAmount.text = String(wineAmount.text!.characters.dropLast()) + String(describing: currentHistory.plannedWineCount ?? 0)
            drinkAmount.text = String(drinkAmount.text!.characters.dropLast()) + String(describing: currentHistory.plannedDrinkCount ?? 0)
            shotAmount.text = String(shotAmount.text!.characters.dropLast()) + String(describing: currentHistory.plannedShotCount ?? 0)
        }
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
        guard let userData = AppDelegate.getUserData() else {return}
        
        let newHistoryDao = NewHistoryDao()
        history?.endDate = Date()
        history?.gender = userData.gender
        history?.weight = userData.weight
        history?.beerCost = userData.costsBeer
        history?.wineCost = userData.costsWine
        history?.drinkCost = userData.costsDrink
        history?.shotCost = userData.costsShot
        
        history?.beerGrams = getUnitGrams(unitType: 0) as NSNumber
        history?.wineGrams = getUnitGrams(unitType: 1) as NSNumber
        history?.drinkGrams = getUnitGrams(unitType: 2) as NSNumber
        history?.shotGrams = getUnitGrams(unitType: 3) as NSNumber
        newHistoryDao.save()
        
        
        drinkEpisodeViewController?.insertView()
    }
    
    func getFirstUnitAdded() -> Date? { //Denne er tung
        var firstUnitAdded:Date?
        if let currentHistory = history {
            if let units = currentHistory.units {
                if let currentUnits = units.allObjects as? [Unit] {
                    firstUnitAdded = currentUnits.first?.timeStamp
                    if firstUnitAdded != nil {
                        for unit in currentUnits {
                            if let timeStamp = unit.timeStamp {
                                if firstUnitAdded! < timeStamp {
                                    firstUnitAdded = timeStamp
                                }
                            }
                        }

                    }
                }
            }
        }
        return firstUnitAdded
    }
    
    func isWithinTheFirstFifteenMinutes() -> Bool {
        let startEndTimestampsDao = StartEndTimestampsDao()
        let startEndTimestamps = startEndTimestampsDao.getAll().first
        
        guard let sessionStart = startEndTimestamps?.startStamp else {return false}
        
        return Calendar.current.date(byAdding: .minute, value: 15, to: sessionStart)! > Date()
    }
    
    func displayUserMaxBacDialog(index:Int) {
        let refreshAlert = UIAlertController(title: "Husk ditt eget mål!", message: "Hvis du drikker denne enheten vil du overstige din selvbestemte makspromille.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Legg til", style: .destructive, handler: { (action: UIAlertAction!) in
            self.hasBeenWarned = !self.hasBeenWarned
            self.modifyUnit(index: index, increment: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func estimatedBacIsHigherThanGoalBac(index:Int) -> Bool{
        let maxBac = AppDelegate.getUserData()?.goalPromille ?? 0.0
        let estimatedBac = estimateBac(unitType: index)
        
        return estimatedBac > Double(maxBac)
    }
    
    func estimateBac(unitType:Int) -> Double{
        guard let beerUnits = Double(beerAmount.text!) else {return 0.0}
        guard let wineUnits = Double(wineAmount.text!) else {return 0.0}
        guard let drinkUnits = Double(drinkAmount.text!) else {return 0.0}
        guard let shotUnits = Double(shotAmount.text!) else {return 0.0}
        
        guard let userData = AppDelegate.getUserData() else {return 0.0}
        
        guard let weight = userData.weight as? Double else {return 0.0}
        guard let gender = userData.gender as? Bool else {return 0.0}
        
        var amounts = [beerUnits, wineUnits, drinkUnits, shotUnits]
        amounts[unitType] += 1.0
        
        return calculateBac(beerUnits: amounts[0], wineUnits: amounts[1], drinkUnits: amounts[2], shotUnits: amounts[3], hours: 0, weight: weight, gender: gender)
    }
}
