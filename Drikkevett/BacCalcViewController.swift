//
//  BacCalcViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 23.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class BacCalcViewController: UIViewController {
    
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var bacQuoteLabel: UILabel!
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    @IBOutlet weak var bacHours: UILabel!
    @IBOutlet weak var bacSlider: UISlider!
    
    let universalBeerGrams = 23.0
    let universalWineGrams = 16.0
    let universalDrinkGrams = 16.0
    let universalShotGrams = 16.0
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
    }
    
    @IBAction func bacSliderChanged(_ sender: UISlider) {
        updateSliderText(currentValue: Int(sender.value))
        updateBac()
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: false)
        updateBac()
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: true)
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
        if currentValue == 1 {bacHours.text = "Promillen om \(currentValue) Time"}
        else {bacHours.text = "Promillen om \(currentValue) Timer"}
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
        let totalGrams = (beerUnits * universalBeerGrams) + (wineUnits * universalWineGrams) + (drinkUnits * universalDrinkGrams) + (shotUnits * universalShotGrams)
        
        let hours = Double(bacSlider.value)
        
        let userDataDao = UserDataDao()
        guard let weight = userDataDao.fetchUserData()?.weight as? Double else {return}
        guard let gender = userDataDao.fetchUserData()?.gender as? Bool else {return}
        let genderScore = gender ? 0.7 : 0.6
        
        let currentBac = (totalGrams/(weight * genderScore) - (0.15 * hours)).roundTo(places: 2)
        if currentBac < 0.0 {bacLabel.text = String(describing: 0.0)}
        else {bacLabel.text = String(describing: currentBac)}
    }
}
