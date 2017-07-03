//
//  PartyViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class PartyViewController: UIViewController {
    
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    
    let universalBeerGrams = 23.0
    let universalWineGrams = 16.0
    let universalDrinkGrams = 16.0
    let universalShotGrams = 16.0
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    var firstUnitAdded:Date?
    var userData:UserData?
    
    static let partySegueId = "partySegueYo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        userData = AppDelegate.getUserData()
        initPlannedUnits()
    }
    
    @IBAction func addUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: true)
    }
    
    @IBAction func removeUnit(_ sender: UIButton) {
        let index = selectDrinkPageViewController?.currentIndex!() ?? 0
        modifyUnit(index: index, increment: false)
    }
    
    func modifyUnit(index:Int, increment:Bool) {
        if index == 0 {
            guard let beerUnits = Int(String(describing: beerAmount.text!.characters.first!)) else {return}
            if increment && beerUnits < 20 {
                beerAmount.text = String(describing: beerUnits + 1) + String(beerAmount.text!.characters.dropFirst())
            }
            else if !increment && beerUnits > 0 {
                beerAmount.text = String(describing: beerUnits - 1) + String(beerAmount.text!.characters.dropFirst())
            }
        }
        else if index == 1 {
            guard let wineUnits = Int(String(describing: wineAmount.text!.characters.first!)) else {return}
            if increment && wineUnits < 20 {
                wineAmount.text = String(describing: wineUnits + 1) + String(wineAmount.text!.characters.dropFirst())
            }
            else if !increment && wineUnits > 0 {
                wineAmount.text = String(describing: wineUnits - 1) + String(wineAmount.text!.characters.dropFirst())
            }
        }
        else if index == 2 {
            guard let drinkUnits = Int(String(describing: drinkAmount.text!.characters.first!)) else {return}
            if increment && drinkUnits < 20 {
                drinkAmount.text = String(describing: drinkUnits + 1) + String(drinkAmount.text!.characters.dropFirst())
            }
            else if !increment && drinkUnits > 0 {
                drinkAmount.text = String(describing: drinkUnits - 1) + String(drinkAmount.text!.characters.dropFirst())
            }
        }
        else if index == 3 {
            guard let shotUnits = Int(String(describing: shotAmount.text!.characters.first!)) else {return}
            if increment && shotUnits < 20 {
                shotAmount.text = String(describing: shotUnits + 1) + String(shotAmount.text!.characters.dropFirst())
            }
            else if !increment && shotUnits > 0 {
                shotAmount.text = String(describing: shotUnits - 1) + String(shotAmount.text!.characters.dropFirst())
            }
        }
        updateBac()
    }
    
    func initPlannedUnits() {
        let defaults = UserDefaults.standard
        beerAmount.text = "0/" + String(describing: defaults.integer(forKey: defaultKeys.beerKey))
        wineAmount.text = "0/" + String(describing: defaults.integer(forKey: defaultKeys.wineKey))
        drinkAmount.text = "0/" + String(describing: defaults.integer(forKey: defaultKeys.drinkKey))
        shotAmount.text = "0/" + String(describing: defaults.integer(forKey: defaultKeys.shotKey))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.partySegueId {
            if segue.destination is SelectDrinkPageViewController {
                selectDrinkPageViewController = segue.destination as? SelectDrinkPageViewController
            }
        }
    }
    
    func updateBac() {
        guard let beerUnits = Double(String(describing: beerAmount.text!.characters.first!)) else {return}
        guard let wineUnits = Double(String(describing: wineAmount.text!.characters.first!)) else {return}
        guard let drinkUnits = Double(String(describing: drinkAmount.text!.characters.first!)) else {return}
        guard let shotUnits = Double(String(describing: shotAmount.text!.characters.first!)) else {return}
        let totalGrams = (beerUnits * universalBeerGrams) + (wineUnits * universalWineGrams) + (drinkUnits * universalDrinkGrams) + (shotUnits * universalShotGrams)
        
        let hours = Double(Date().timeIntervalSince(firstUnitAdded!)) / 3600.0
        
        guard let weight = userData?.weight as? Double else {return}
        guard let gender = userData?.gender as? Bool else {return}
        let genderScore = gender ? 0.7 : 0.6
        
        let currentBac = (totalGrams/(weight * genderScore) - (0.15 * hours)).roundTo(places: 2)
        if currentBac < 0.0 {bacLabel.text = String(describing: 0.0)}
        else {bacLabel.text = String(describing: currentBac)}
    }
}
