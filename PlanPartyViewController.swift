//
//  PlanPartyViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class PlanPartyViewController: UIViewController {
    
    @IBOutlet weak var bacQuoteLabel: UILabel!
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    @IBOutlet weak var expectedBac: UILabel!
    @IBOutlet weak var expectedCost: UILabel!
    @IBOutlet weak var startEveningView: UIView!
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    var drinkEpisodeViewController:DrinkEpisodeViewController?
    
    var hasBeenWarned = false
    var hasBeenWhoWarned = false
    let maxBac = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        startEveningView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startEvening)))
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        
        let estimatedBac = estimateBac(unitType: index)
        if shouldDisplayWhoWarning() {displayWhoMaxBacDialog(index: index)}
        else if estimatedBac > 3.0 {displayMaxBacDialog()}
        else if estimatedBacIsHigherThanGoalBac(index: index) && !hasBeenWarned {displayUserMaxBacDialog(index: index)}
        else {modifyUnit(index: index, increment: true)}
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: false)
    }
    
    func startEvening() {
        guard let beerUnits = Int(beerAmount.text!) else {return}
        guard let wineUnits = Int(wineAmount.text!) else {return}
        guard let drinkUnits = Int(drinkAmount.text!) else {return}
        guard let shotUnits = Int(shotAmount.text!) else {return}
        
        let unitsCount = beerUnits + wineUnits + drinkUnits + shotUnits
        if unitsCount <= 0 {return}
        
        UnitAddedDao().deleteAll()
        
        let startEndTimestampsDao = StartEndTimestampsDao()
        startEndTimestampsDao.deleteAll()
        
        let startOfSessionStamp = Date()
        let setEndOfSessionStamp = Calendar.current.date(byAdding: .hour, value: 12, to: startOfSessionStamp)
        
        let _ = startEndTimestampsDao.createNewStartEndTimestamps(startStamp: startOfSessionStamp, endStamp: setEndOfSessionStamp)
        startEndTimestampsDao.save()
        
        let defaults = UserDefaults.standard
        
        var numberOfSessionPlanParty = defaults.integer(forKey: defaultKeys.numberOfSessions)
        numberOfSessionPlanParty += 1
        
        defaults.set(beerUnits, forKey: defaultKeys.beerKey)
        defaults.set(wineUnits, forKey: defaultKeys.wineKey)
        defaults.set(drinkUnits, forKey: defaultKeys.drinkKey)
        defaults.set(shotUnits, forKey: defaultKeys.shotKey)
        defaults.set(unitsCount, forKey: defaultKeys.totalNrOfUnits)
        defaults.set(numberOfSessionPlanParty, forKey: defaultKeys.numberOfSessions)
        defaults.set(unitsCount, forKey: defaultKeys.keyForPlannedCounter)
        defaults.synchronize()
        
        drinkEpisodeViewController?.insertView()
        
        unitAddedAlertController("Kvelden er startet", message: "Ha det gøy og drikk med måte!", delayTime: 3.0)
        
        //Segue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.planPartySegueId {
            if segue.destination is SelectDrinkPageViewController {
                selectDrinkPageViewController = segue.destination as? SelectDrinkPageViewController
            }
        }
    }
    
    func modifyUnit(index:Int, increment:Bool) {
        if index == 0 {
            guard let beerUnits = Int(beerAmount.text!) else {return}
            if increment && beerUnits < 20 {beerAmount.text = String(describing: beerUnits + 1)}
            else if !increment && beerUnits > 0 {beerAmount.text = String(describing: beerUnits - 1)}
        }
        else if index == 1 {
            guard let wineUnits = Int(wineAmount.text!) else {return}
            if increment && wineUnits < 20 {wineAmount.text = String(describing: wineUnits + 1)}
            else if !increment && wineUnits > 0 {wineAmount.text = String(describing: wineUnits - 1)}
        }
        else if index == 2 {
            guard let drinkUnits = Int(drinkAmount.text!) else {return}
            if increment && drinkUnits < 20 {drinkAmount.text = String(describing: drinkUnits + 1)}
            else if !increment && drinkUnits > 0 {drinkAmount.text = String(describing: drinkUnits - 1)}
        }
        else if index == 3 {
            guard let shotUnits = Int(shotAmount.text!) else {return}
            if increment && shotUnits < 20 {shotAmount.text = String(describing: shotUnits + 1)}
            else if !increment && shotUnits > 0 {shotAmount.text = String(describing: shotUnits - 1)}
        }
        updateExpectedBac()
        updateExpectedCost()
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
    
    func resetUnits() {
        beerAmount.text = "0"
        wineAmount.text = "0"
        drinkAmount.text = "0"
        shotAmount.text = "0"
        expectedBac.text = "0.0"
        expectedCost.text = "0,-"
    }
    
    func updateExpectedBac() {
        guard let beerUnits = Double(beerAmount.text!) else {return}
        guard let wineUnits = Double(wineAmount.text!) else {return}
        guard let drinkUnits = Double(drinkAmount.text!) else {return}
        guard let shotUnits = Double(shotAmount.text!) else {return}
        
        let totalGrams = beerUnits * getUnitGrams(unitType: 0) + wineUnits * getUnitGrams(unitType: 1) + drinkUnits * getUnitGrams(unitType: 2) + shotUnits * getUnitGrams(unitType: 3)
        
        guard let userData = AppDelegate.getUserData() else {return}
        
        guard let weight = userData.weight as? Double else {return}
        guard let gender = userData.gender as? Bool else {return}
        let genderScore = gender ? 0.7 : 0.6
        
        let currentBac = (totalGrams/(weight * genderScore)).roundTo(places: 2)
        if currentBac < 0.0 {expectedBac.text = String(describing: 0.0)}
        else {expectedBac.text = String(describing: currentBac)}
    }
    
    func updateExpectedCost() {
        guard let beerUnits = Int(beerAmount.text!) else {return}
        guard let wineUnits = Int(wineAmount.text!) else {return}
        guard let drinkUnits = Int(drinkAmount.text!) else {return}
        guard let shotUnits = Int(shotAmount.text!) else {return}
        
        guard let userData = AppDelegate.getUserData() else {return}
        
        let totalCost =
            beerUnits * Int(userData.costsBeer ?? 0) +
            wineUnits * Int(userData.costsWine ?? 0) +
            drinkUnits * Int(userData.costsDrink ?? 0) +
            shotUnits * Int(userData.costsShot ?? 0)
        
        expectedCost.text = String(totalCost) + ",-"
    }
    
    func getUnitGrams(unitType:Int) -> Double{
        let defaults = UserDefaults.standard
        
        let savedPercentage = defaults.double(forKey: ResourceList.percentageKeys[unitType]) > 0.0 ? defaults.double(forKey: ResourceList.percentageKeys[unitType]) : ResourceList.defaultPercentage[unitType]
        let savedAmount = defaults.double(forKey: ResourceList.amountKeys[unitType]) > 0.0 ? defaults.double(forKey: ResourceList.amountKeys[unitType]) : ResourceList.defaultAmount[unitType]
        
        return savedAmount * savedPercentage / 10.0
    }
    
    func estimateBac(unitType:Int) -> Double{
        guard let beerUnits = Double(beerAmount.text!) else {return 0.0}
        guard let wineUnits = Double(wineAmount.text!) else {return 0.0}
        guard let drinkUnits = Double(drinkAmount.text!) else {return 0.0}
        guard let shotUnits = Double(shotAmount.text!) else {return 0.0}
        
        var amounts = [beerUnits, wineUnits, drinkUnits, shotUnits]
        amounts[unitType] += 1.0
        
        let totalGrams =
            amounts[0] * getUnitGrams(unitType: 0) +
            amounts[1] * getUnitGrams(unitType: 1) +
            amounts[2] * getUnitGrams(unitType: 2) +
            amounts[3] * getUnitGrams(unitType: 3)
        
        guard let userData = AppDelegate.getUserData() else {return 0.0}
        
        guard let weight = userData.weight as? Double else {return 0.0}
        guard let gender = userData.gender as? Bool else {return 0.0}
        let genderScore = gender ? 0.7 : 0.6
        
        let currentBac = (totalGrams/(weight * genderScore)).roundTo(places: 2)
        if currentBac > 0.0 {return currentBac}
        return 0.0
    }
    
    func estimatedBacIsHigherThanGoalBac(index:Int) -> Bool{
        let maxBac = AppDelegate.getUserData()?.goalPromille ?? 0.0
        let estimatedBac = estimateBac(unitType: index)
        
        return estimatedBac > Double(maxBac)
    }
    
    func displayMaxBacDialog() {
        let refreshAlert = UIAlertController(title: "For høy promille!", message: "Du kan død!", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func displayUserMaxBacDialog(index:Int) {
        let refreshAlert = UIAlertController(title: "Høy promille!", message: "Hvis du legger til denne enheten vil du overstige din makspromille.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Legg til", style: .destructive, handler: { (action: UIAlertAction!) in
            self.hasBeenWarned = !self.hasBeenWarned
            self.modifyUnit(index: index, increment: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getUnitCountForCurrentWeek() -> Int {
        let historyDao = HistoryDao()
        var currentWeekUnitCount = 0
        
        let histories = historyDao.getAll()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        for history in histories {
            guard let historyDate = history.dato else {continue}
            
            if historyDate > sevenDaysAgo {
                currentWeekUnitCount += history.antallOl as! Int
                currentWeekUnitCount += history.antallVin as! Int
                currentWeekUnitCount += history.antallDrink as! Int
                currentWeekUnitCount += history.antallShot as! Int
            }
        }
        return currentWeekUnitCount
    }
    
    func getUnitCount() ->Int {
        guard let beerUnits = Int(beerAmount.text!) else {return 0}
        guard let wineUnits = Int(wineAmount.text!) else {return 0}
        guard let drinkUnits = Int(drinkAmount.text!) else {return 0}
        guard let shotUnits = Int(shotAmount.text!) else {return 0}
        
        return beerUnits + wineUnits + drinkUnits + shotUnits
    }
    
    func displayWhoMaxBacDialog(index:Int) {
        let refreshAlert = UIAlertController(title: "Mange enheter!", message: "Hvis du legger til denne enheten vil du overstige WHO sin anbefaling om maks 14 enheter per uke. Er du sikker?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Legg til", style: .destructive, handler: { (action: UIAlertAction!) in
            self.hasBeenWhoWarned = !self.hasBeenWhoWarned
            self.modifyUnit(index: index, increment: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func shouldDisplayWhoWarning() -> Bool {
        let defaults = UserDefaults.standard
        let shoudBeWhoWarnedSavedValue = defaults.object(forKey: ResourceList.weekUnitWarningKey) != nil ? defaults.bool(forKey: ResourceList.weekUnitWarningKey) : ResourceList.weekUnitWarningDefault
        
        if shoudBeWhoWarnedSavedValue {return true}
        
        return (getUnitCountForCurrentWeek() + getUnitCount() + 1) > ResourceList.whoMaxUnitCount && !hasBeenWhoWarned
    }
}
