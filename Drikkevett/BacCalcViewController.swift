//
//  BacCalcViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 23.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class BacCalcViewController: UIViewController {
    
    let percentageKeys = ["BeerPercentage", "WinePercentage", "DrinkPercentage", "ShotPercentage"]
    let amountKeys = ["BeerAmount", "WineAmount", "DrinkAmount", "ShotAmount"]
    
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var bacQuoteLabel: UILabel!
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    @IBOutlet weak var bacHours: UILabel!
    @IBOutlet weak var bacSlider: UISlider!
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    
    let maxBac = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
    }
    
    @IBAction func bacSliderChanged(_ sender: UISlider) {
        updateSliderText(currentValue: Int(sender.value))
        updateBac()
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        
        print(calculateAlcoholEnergyAmount(unitType: index))
        
        if estimateBac(unitType: index) > maxBac {displayMaxBacDialog()}
        else {
            modifyUnit(index: index, increment: true)
            updateBac()
        }
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: false)
        updateBac()
    }
    
    @IBAction func removeAllUnits(_ sender: UIBarButtonItem) {
        beerAmount.text = "0"
        wineAmount.text = "0"
        drinkAmount.text = "0"
        shotAmount.text = "0"
        bacSlider.value = 1
        updateSliderText(currentValue: 1)
        updateBac()
    }
    
    func updateSliderText(currentValue:Int) {
        if currentValue == 1 {bacHours.text = "Promillen om \(currentValue) time"}
        else {bacHours.text = "Promillen om \(currentValue) timer"}
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
        updateBac()
        updateQuote()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.segueId {
            if segue.destination is SelectDrinkPageViewController {
                selectDrinkPageViewController = segue.destination as? SelectDrinkPageViewController
            }
        }
    }
    
    func updateBac() {
        guard let beerUnits = Double(beerAmount.text!) else {return}
        guard let wineUnits = Double(wineAmount.text!) else {return}
        guard let drinkUnits = Double(drinkAmount.text!) else {return}
        guard let shotUnits = Double(shotAmount.text!) else {return}
        let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
        
        let hours = Double(bacSlider.value)
        
        let userDataDao = UserDataDao()
        guard let weight = userDataDao.fetchUserData()?.weight as? Double else {return}
        guard let gender = userDataDao.fetchUserData()?.gender as? Bool else {return}
        let genderScore = gender ? 0.7 : 0.6
        
        let currentBac = (totalGrams/(weight * genderScore) - (0.15 * hours)).roundTo(places: 2)
        if currentBac < 0.0 {bacLabel.text = String(describing: 0.0)}
        else {bacLabel.text = String(describing: currentBac)}
    }
    
    func updateQuote() {
        guard let currentBac = Double(bacLabel.text!) else {return}
        bacQuoteLabel.text = getQuoteTextBy(bac: currentBac)
        let currentColor = getQuoteTextColorBy(bac: currentBac)
        
        bacQuoteLabel.textColor = currentColor
        bacLabel.textColor = currentColor
    }
    
    func getQuoteTextBy(bac:Double) -> String {
        if bac < 0.4 {return "Kos deg!"}
        else if bac < 0.8 {return "Lykkepromille"}
        else if bac < 1.0 {return "Du blir mer kritikkløs og risikovillig"}
        else if bac < 1.2 {return "Balansen blir dårligere"}
        else if bac < 1.4 {return "Talen snøvlete og \nkontroll på bevegelser forverres"}
        else if bac < 1.8 {return "Man blir trøtt, sløv og \nkan bli kvalm"}
        else if bac < 3.0 {return "Hukommelsen sliter! "}
        return "Svært høy promille! \nMan kan bli bevistløs!"
    }
    
    func getQuoteTextColorBy(bac:Double) -> UIColor {
        if bac < 0.4 {return UIColor.white}
        else if bac < 0.8 {return UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)}
        else if bac < 1.2 {return UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)}
        else if bac < 1.8 {return UIColor.orange}
        else if bac < 3.0 {return UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)}
        return UIColor.red
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
        
        let totalGrams = amounts[0] * getUnitGrams(unitType: 0) +
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
    
    func displayMaxBacDialog() {
        let refreshAlert = UIAlertController(title: "For høy promille!", message: "Du kan død!", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func calculateAlcoholEnergyAmount(unitType:Int) -> Double{
        guard let beerUnits = Double(beerAmount.text!) else {return 0.0}
        guard let wineUnits = Double(wineAmount.text!) else {return 0.0}
        guard let drinkUnits = Double(drinkAmount.text!) else {return 0.0}
        guard let shotUnits = Double(shotAmount.text!) else {return 0.0}
        let totalGrams = (beerUnits * getUnitGrams(unitType: 0)) + (wineUnits * getUnitGrams(unitType: 1)) + (drinkUnits * getUnitGrams(unitType: 2)) + (shotUnits * getUnitGrams(unitType: 3))
        
        return totalGrams * 7.0
    }
}
