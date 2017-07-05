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
    
    let universalBeerGrams = 23.0
    let universalWineGrams = 16.0
    let universalDrinkGrams = 16.0
    let universalShotGrams = 16.0
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    var drinkEpisodeViewController:DrinkEpisodeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        startEveningView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startEvening)))
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: true)
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
        
        let totalGrams = beerUnits * universalBeerGrams +
            wineUnits * universalWineGrams +
            drinkUnits * universalDrinkGrams +
            shotUnits * universalShotGrams
        
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
        
        let totalCost = beerUnits * Int(userData.costsBeer ?? 0) +
            wineUnits * Int(userData.costsWine ?? 0) +
            drinkUnits * Int(userData.costsDrink ?? 0) +
            shotUnits * Int(userData.costsShot ?? 0)
        
        expectedCost.text = String(totalCost) + ",-"
    }
}