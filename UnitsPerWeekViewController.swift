//
//  UnitsPerWeekViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 05.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UnitsPerWeekViewController: UIViewController {
    
    @IBOutlet weak var shouldWarnLabel: UILabel!
    @IBOutlet weak var shouldWarnSwitch: UISwitch!
    
    let warningOnText = "Varsel er skrudd på"
    let warningOffText = "Varsel er skrudd av"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedWarningValue = getSavedWarningValue()
        shouldWarnSwitch.isOn = savedWarningValue
        if savedWarningValue {shouldWarnLabel.text = warningOnText}
        else {shouldWarnLabel.text = warningOffText}
        
        AppColors.setBackground(view: view)
    }
    
    @IBAction func shouldWarn(_ sender: UISwitch) {
        if sender.isOn {shouldWarnLabel.text = warningOnText}
        else {shouldWarnLabel.text = warningOffText}
        setShouldWarnValue(shouldWarn: sender.isOn)
    }
    
    @IBAction func readMore(_ sender: UIButton) {
        performSegue(withIdentifier: InfoDetailViewController.readMoreSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == InfoDetailViewController.readMoreSegue {
            if let destination = segue.destination as? InfoDetailViewController {
                let info = Info()
                info.title = ResourceList.exerciseTitles[4]
                info.image = ResourceList.exerciseImages[4]
                info.text = ResourceList.exerciseTexts[4]
                destination.info = info
            }
        }
    }
    
    func getSavedWarningValue() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: ResourceList.weekUnitWarningKey) == nil {
            return ResourceList.weekUnitWarningDefault
        }
        else {return defaults.bool(forKey: ResourceList.weekUnitWarningKey)}
    }
    
    func setShouldWarnValue(shouldWarn:Bool) {
        let defaults = UserDefaults.standard
        defaults.set(shouldWarn, forKey: ResourceList.weekUnitWarningKey)
        defaults.synchronize()
    }
}
