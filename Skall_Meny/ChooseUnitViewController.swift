//  ChooseUnitViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 04.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class ChooseUnitViewController: UIViewController {

    @IBOutlet weak var imageViewUnits: UIImageView!
    
    var pageIndex: Int!
    var titleButton: String!
    var imageFile: String!
    
    var firstViewCon = FirstViewController()
    
    //var dataViewDelegate: DataViewDelegate?
    
    var setAppColors = AppColors()
    
    var bullshit = "Faenskap"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        self.imageViewUnits.image = UIImage(named: self.imageFile)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("WHAT PAGE ARE WE ON: \(self.pageIndex)")
        if(self.pageIndex == 0){
            firstViewCon.fetchUnitTypeFromSwipe = "Beer"
            firstViewCon.storeFetchValueType()
        }
        if(self.pageIndex == 1){
            firstViewCon.fetchUnitTypeFromSwipe = "Wine"
            firstViewCon.storeFetchValueType()
        }
        if(self.pageIndex == 2){
            firstViewCon.fetchUnitTypeFromSwipe = "Drink"
            firstViewCon.storeFetchValueType()
        }
        if(self.pageIndex == 3){
            firstViewCon.fetchUnitTypeFromSwipe = "Shot"
            firstViewCon.storeFetchValueType()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    @IBAction func goRightBtn(sender: AnyObject) {
        switch pageIndex {
        case 0...3:
            let middleCont = MiddleUnitViewController()
            middleCont.forward(pageIndex)
        default: break
            
        }
    }*/
    
    
    /*@IBAction func addUnitBtn(sender: AnyObject) {
        firstViewCon.getDefaultBool()
        firstViewCon.getDefaultCheckSessionBool()
        let titleValueString = chooseUnitbutton.currentTitle!
        
        print("CHANGE BUTTONS: \(firstViewCon.changeButtons)")
        
        if (titleValueString == "Øl") {
            if(firstViewCon.changeButtons == true) {
                firstViewCon.counter++
                if(firstViewCon.counter <= 30){
                    firstViewCon.numberOfBeerCount++
                }
                firstViewCon.storeBoolValue()
            } else {
                if(firstViewCon.numberOfBeerCount <= 0){
                    firstViewCon.numberOfBeerCount = 0
                    firstViewCon.storeBoolValue()
                } else {
                    firstViewCon.unitAlcohol = "Beer"
                    firstViewCon.seedTimeStamp()
                    firstViewCon.numberOfBeerCount--
                    firstViewCon.historyCountBeer++
                    firstViewCon.storeBoolValue()
                }
            }
        }
        if (titleValueString == "Vin") {
            if(firstViewCon.changeButtons == true) {
                firstViewCon.counter++
                if(firstViewCon.counter <= 30){
                    firstViewCon.numberOfWineCount++
                }
                firstViewCon.storeBoolValue()
            } else {
                if(firstViewCon.numberOfWineCount <= 0){
                    firstViewCon.numberOfWineCount = 0
                    firstViewCon.storeBoolValue()
                } else {
                    firstViewCon.unitAlcohol = "Wine"
                    firstViewCon.seedTimeStamp()
                    firstViewCon.numberOfWineCount--
                    firstViewCon.historyCountWine++
                    firstViewCon.storeBoolValue()
                }
            }
        }
        if (titleValueString == "Drink") {
            if(firstViewCon.changeButtons == true) {
                firstViewCon.counter++
                if(firstViewCon.counter <= 30){
                    firstViewCon.numberOfDrinkCount++
                }
                firstViewCon.storeBoolValue()
            } else {
                if(firstViewCon.numberOfDrinkCount <= 0){
                    firstViewCon.numberOfDrinkCount = 0
                    firstViewCon.storeBoolValue()
                } else {
                    firstViewCon.unitAlcohol = "Drink"
                    firstViewCon.seedTimeStamp()
                    firstViewCon.numberOfDrinkCount--
                    firstViewCon.historyCountDrink++
                    firstViewCon.storeBoolValue()
                }
            }
        }
        if (titleValueString == "Shot") {
            if(firstViewCon.changeButtons == true) {
                firstViewCon.counter++
                if(firstViewCon.counter <= 30){
                    firstViewCon.numberOfShotCount++
                }
                firstViewCon.storeBoolValue()
            } else {
                if(firstViewCon.numberOfShotCount <= 0){
                    firstViewCon.numberOfShotCount = 0
                    firstViewCon.storeBoolValue()
                } else {
                    firstViewCon.unitAlcohol = "Shot"
                    firstViewCon.seedTimeStamp()
                    firstViewCon.numberOfShotCount--
                    firstViewCon.historyCountShot++
                    firstViewCon.storeBoolValue()
                }
            }
        }
        
        // ADVAR BRUKER OM AT PROMILLEN BLIR HØY MED DETTE ANTALLET
        // HVIS MAN HAR LAGT TIL FOR MANGE ENHETER:
        if(firstViewCon.counter == 15){
            unitsAddedPopUp("Høyt Antall", msg: "Er du sikker på dette?", buttonTitle: "OK")
        }
        if(firstViewCon.counter >= 30){
            unitsAddedPopUp("Ikke tillatt", msg: "Drikkevett tillater ikke flere enheter\nEndre eller start kvelden", buttonTitle: "OK")
        }
    }
    
    func unitsAddedPopUp(titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
            print("TUILL")
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }*/
    
    /*func forward(index:Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }*/
}
