//
//  UnitUpdateNewViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 14.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UnitUpdateViewController: UIViewController {
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var percentSlider: UISlider!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSlider: UISlider!
    @IBOutlet weak var standardButton: UIView!
    @IBOutlet weak var tipsTextView: UITextView!
    
    var selectDrinkPageViewController:SelectDrinkPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        changeUnit()
        percentSlider.addTarget(self, action: #selector(percentDidFinish), for: .touchUpInside)
        amountSlider.addTarget(self, action: #selector(amountDidFinish), for: .touchUpInside)
        standardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setStandardPrices)))
    }
    
    @IBAction func percentDidChange(_ sender: UISlider) {
        let currentValue = Double(sender.value).roundTo(places: 1)
        percentLabel.text = String(currentValue) + "%"
        
    }
    @IBAction func amountDidChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        amountLabel.text = String(currentValue) + " cl"
    }
    
    func percentDidFinish() {
        let unitType = selectDrinkPageViewController?.currentIndex!() ?? 0
        savePercent(unitType: unitType)
    }
    
    func amountDidFinish() {
        let unitType = selectDrinkPageViewController?.currentIndex!() ?? 0
        saveAmount(unitType: unitType)
    }
    
    func savePercent(unitType:Int) {
        guard let unitPercentageChosen = Double(String(describing: percentLabel.text!.components(separatedBy: "%").first!)) else {return}
        let defaults = UserDefaults.standard
        defaults.set(unitPercentageChosen, forKey: ResourceList.percentageKeys[unitType])
        defaults.synchronize()
    }
    
    func saveAmount(unitType:Int) {
        guard let unitAmountChosen = Double(String(describing: amountLabel.text!.components(separatedBy: " ").first!)) else {return}
        let defaults = UserDefaults.standard
        defaults.set(unitAmountChosen, forKey: ResourceList.amountKeys[unitType])
        defaults.synchronize()
    }
    
    func changeUnit() {
        let unitType = selectDrinkPageViewController?.currentIndex!() ?? 0
        
        let defaults = UserDefaults.standard
        var savedPercentage = defaults.double(forKey: ResourceList.percentageKeys[unitType])
        var savedAmount = defaults.integer(forKey: ResourceList.amountKeys[unitType])
        
        if savedPercentage < 0.1 {savedPercentage = ResourceList.defaultPercentage[unitType]}
        if savedAmount < 1 {savedAmount = Int(ResourceList.defaultAmount[unitType])}
        
        percentLabel.text = String(savedPercentage) + "%"
        percentSlider.value = Float(savedPercentage)
        amountLabel.text = String(savedAmount) + " cl"
        amountSlider.value = Float(savedAmount)
        
        let tipsText = "Tips:\n1 l = 10 dl = 100 cl\n1 halvliter = 50cl"
        if unitType == 2 {
            tipsTextView.text = tipsText + "\nI drink regnes promillen kun ut i fra shottet som er brukt. Skriv derfor mengden og prosenandelen på shottet."
        }
        else {tipsTextView.text = tipsText}
    }
    
    func setStandardPrices() {
        let unitType = selectDrinkPageViewController?.currentIndex!() ?? 0
        
        percentLabel.text = String(ResourceList.defaultPercentage[unitType]) + "%"
        percentSlider.value = Float(ResourceList.defaultPercentage[unitType])
        amountLabel.text = String(ResourceList.defaultAmount[unitType]) + " cl"
        amountSlider.value = Float(ResourceList.defaultAmount[unitType])
        
        savePercent(unitType: unitType)
        saveAmount(unitType: unitType)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SelectDrinkPageViewController.changeUnitsSegue {
            let destination = segue.destination as? SelectDrinkPageViewController
            destination?.unitUpdateViewController = self
            selectDrinkPageViewController = destination
        }
    }
}
