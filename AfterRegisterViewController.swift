//
//  AfterRegisterViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 05.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class AfterRegisterViewController: UIViewController {
    
    static let segueId = "registerSegue"
    
    @IBOutlet weak var beerUnits: UILabel!
    @IBOutlet weak var wineUnits: UILabel!
    @IBOutlet weak var drinkUnits: UILabel!
    @IBOutlet weak var shotUnits: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var history:Historikk?
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        setUnitsFromHistory()
    }
    
    func setDatePicker() {
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .countDownTimer
        datePicker.datePickerMode = .dateAndTime
        
        datePicker.minimumDate = history?.dato
        datePicker.maximumDate = history?.endOfSesDato
        if let startOfSession = history!.dato {
            datePicker.date = startOfSession
        }
    }
    
    func setUnitsFromHistory() {
        beerUnits.text = String(describing: history!.antallOl!)
        wineUnits.text = String(describing: history!.antallVin!)
        drinkUnits.text = String(describing: history!.antallDrink!)
        shotUnits.text = String(describing: history!.antallShot!)
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        let historyDao = HistoryDao()
        let histories = historyDao.getAll()
        
        if let currentHistory = incrementUnit(index: index, histories: histories) {
            
            /*
            guard let userData = AppDelegate.getUserData() else {return}
            
            let totalCost =
                Int(currentHistory.antallOl ?? 0) * Int(userData.costsBeer ?? 0) +
                Int(currentHistory.antallVin ?? 0) * Int(userData.costsWine ?? 0) +
                Int(currentHistory.antallDrink ?? 0) * Int(userData.costsDrink ?? 0) +
                Int(currentHistory.antallShot ?? 0) * Int(userData.costsShot ?? 0)
            
            currentHistory.forbruk = totalCost as NSNumber
            
            //Register graph history
            
            let unitAddedDao = UnitAddedDao()
            
            let grr = unitAddedDao.createNewUnitAdded()
            
            
            let unitsAdded = unitAddedDao.getAll()

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
            
            drinkEpisodeViewController?.insertView()*/
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        historyDao.save()
        
        setUnitsFromHistory()
        
        //HER MÅ ALT ANNET OPPDATERS OG
        
        unitAddedAlertController(String(describing: ResourceList.units[index] + " drukket!"), message: "", delayTime: 0.8)
    }
    
    func incrementUnit(index:Int, histories:[Historikk]) -> Historikk?{
        for fetchedHistory in histories {
            if fetchedHistory.sessionNumber == history?.sessionNumber {
                if index == 0 {
                    let incremented:NSNumber? = NSNumber(integerLiteral:Int(fetchedHistory.antallOl!) + 1)
                    fetchedHistory.antallOl = incremented
                    return fetchedHistory
                }
                else if index == 1 {
                    let incremented:NSNumber? = NSNumber(integerLiteral:Int(fetchedHistory.antallVin!) + 1)
                    fetchedHistory.antallVin = incremented
                    return fetchedHistory
                }
                else if index == 2 {
                    let incremented:NSNumber? = NSNumber(integerLiteral:Int(fetchedHistory.antallDrink!) + 1)
                    fetchedHistory.antallDrink = incremented
                    return fetchedHistory
                }
                else if index == 3 {
                    let incremented:NSNumber? = NSNumber(integerLiteral:Int(fetchedHistory.antallShot!) + 1)
                    fetchedHistory.antallShot = incremented
                    return fetchedHistory
                }
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.afterRegisterSegueId {
            if let destination = segue.destination as? SelectDrinkPageViewController {
                selectDrinkPageViewController = destination
            }
        }
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
    
}
