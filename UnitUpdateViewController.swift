//
//  UnitUpdateCiewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 13.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UnitUpdateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Endre alkoholenheter"
        AppColors.setBackground(view: view)
    }
    
    @IBAction func changeBeer(_ sender: UIButton) {
        performSegue(withIdentifier: UnitViewController.updateUnitSegue, sender: 0)
    }
    
    @IBAction func changeWine(_ sender: UIButton) {
        performSegue(withIdentifier: UnitViewController.updateUnitSegue, sender: 1)
    }
    
    @IBAction func changeDrink(_ sender: UIButton) {
        performSegue(withIdentifier: UnitViewController.updateUnitSegue, sender: 2)
    }
    @IBAction func changeShot(_ sender: UIButton) {
        performSegue(withIdentifier: UnitViewController.updateUnitSegue, sender: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UnitViewController.updateUnitSegue {
            if let destination = segue.destination as? UnitViewController {
                if let unitType = sender as? Int {
                    destination.unitType = unitType
                }
            }
        }
    }
}
