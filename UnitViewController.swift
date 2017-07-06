//
//  UnitViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 05.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController {
    
    static let segueId = "modifyDrink"
    
    @IBOutlet weak var unitTitle: UILabel!
    @IBOutlet weak var unitImage: UIImageView!
    @IBOutlet weak var unitPercent: UILabel!
    @IBOutlet weak var unitPercentSlider: UISlider!
    @IBOutlet weak var unitAmount: UILabel!
    @IBOutlet weak var unitAmountSlider: UISlider!
    @IBOutlet weak var standardButton: UIView!
    
    var unitType:Int?
    
    let titles = ["Øl", "Vin", "Drink", "Shot"]
    let images = ["LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS"]
    let percentageKeys = ["BeerPercentage", "WinePercentage", "DrinkPercentage", "ShotPercentage"]
    let defaultPercentage = [4.5, 12.0, 20.5, 40.0]
    let amountKeys = ["BeerAmount", "WineAmount", "DrinkAmount", "ShotAmount"]
    let defaultAmount = [50, 20, 20, 4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        initUnit()
        standardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setStandardValues)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let unitPercentageChosen = Double(String(describing: unitPercent.text!.components(separatedBy: "%").first!)) else {return}
        guard let unitAmountChosen = Double(String(describing: unitAmount.text!.components(separatedBy: " ").first!)) else {return}
        
        if unitType == nil {return}
        let defaults = UserDefaults.standard
        defaults.set(unitPercentageChosen, forKey: percentageKeys[unitType!])
        defaults.set(unitAmountChosen, forKey: amountKeys[unitType!])
        defaults.synchronize()
    }
    
    @IBAction func unitPercentChanged(_ sender: UISlider) {
        let currentValue = Double(sender.value).roundTo(places: 1)
        unitPercent.text = String(currentValue) + "%"
    }
    
    @IBAction func unitAmountChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        unitAmount.text = String(currentValue) + " cl"
    }
    
    func initUnit() {
        if unitType == nil {return}
        title = titles[unitType!]
        unitImage.image = UIImage(named: images[unitType!])
        
        let defaults = UserDefaults.standard
        var savedPercentage = defaults.double(forKey: percentageKeys[unitType!])
        var savedAmount = defaults.integer(forKey: amountKeys[unitType!])
        
        if savedPercentage < 0.1 {savedPercentage = defaultPercentage[unitType!]}
        if savedAmount < 1 {savedAmount = defaultAmount[unitType!]}
        
        unitPercent.text = String(savedPercentage) + "%"
        unitPercentSlider.value = Float(savedPercentage)
        unitAmount.text = String(savedAmount) + " cl"
        unitAmountSlider.value = Float(savedAmount)
    }
    
    func setStandardValues() {
        if unitType == nil {return}
        
        unitPercent.text = String(defaultPercentage[unitType!]) + "%"
        unitPercentSlider.value = Float(defaultPercentage[unitType!])
        unitAmount.text = String(defaultAmount[unitType!]) + " cl"
        unitAmountSlider.value = Float(defaultAmount[unitType!])
    }
}
