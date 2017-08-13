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
    
    var history:History?
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
        
        datePicker.minimumDate = getDateOfFirstUnitAdded(units: history?.units?.allObjects as! [Unit])
        datePicker.maximumDate = history?.endDate
        if let startOfSession = history!.beginDate {
            datePicker.date = startOfSession
        }
    }
    
    func getDateOfFirstUnitAdded(units:[Unit]) -> Date?{
        return units.sorted(by: { $0.timeStamp! < $1.timeStamp! }).first?.timeStamp
    }
    
    func setUnitsFromHistory() {
        var beerCount = 0
        var wineCount = 0
        var drinkCount = 0
        var shotCount = 0
        
        if let units = history?.units {
            for unit in units.allObjects as! [Unit] {
                if unit.unitType == "Beer" {
                    beerCount += 1
                } else if unit.unitType == "Wine" {
                    wineCount += 1
                } else if unit.unitType == "Drink" {
                    drinkCount += 1
                } else if unit.unitType == "Shot" {
                    shotCount += 1
                }
            }
        }
        
        beerUnits.text = String(describing: beerCount)
        wineUnits.text = String(describing: wineCount)
        drinkUnits.text = String(describing: drinkCount)
        shotUnits.text = String(describing: shotCount)
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
        
        setUnitsFromHistory()
        
        unitAddedAlertController(String(describing: ResourceList.units[index] + " lagt til!"), message: "", delayTime: 0.8)
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
