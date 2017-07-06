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
    
    var unitType:Int?
    
    let titles = ["Øl", "Vin", "Drink", "Shot"]
    let images = ["LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        
        if unitType == nil {return}
        title = titles[unitType!]
        unitImage.image = UIImage(named: images[unitType!])
    }
    
    @IBAction func unitPercentChanged(_ sender: UISlider) {
        let currentValue = Double(sender.value).roundTo(places: 1)
        unitPercent.text = String(currentValue) + "%"
    }
    
    @IBAction func unitAmountChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        unitAmount.text = String(currentValue) + " cl"
    }
    
}
