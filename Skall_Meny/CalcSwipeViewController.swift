//  CalcSwipeViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 08.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class CalcSwipeViewController: UIViewController {
    
    var pageIndex: Int!
    var unitTitle: String!
    var sendText: String!
    var imageFile: String!
    
    @IBOutlet weak var unitImageView: UIImageView!
    
    let secViewCon = SecondViewController()
    
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        self.unitImageView.image = UIImage(named: self.imageFile)
        //self.unitImageView.image = UIImage(named: self.imageFile)
        
        
        //DETTE GJØR INGEN TING? (font-greiene)
        
        
        var font = UIFont()
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            //unitImageView = UIImageView(frame: CGRectMake(100, 150, 150, 150)); // set as you want
            
            // iPhone 4
            //var img : CGSize = 20
            ///unitImageView.frame.size = 20
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            font = UIFont(name: "HelveticaNeue-Light", size: 30)!
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            font = UIFont(name: "HelveticaNeue-Light", size: 40)!
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         print("WHAT PAGE ARE WE ON: \(self.pageIndex)")
        
        if(self.pageIndex == 0){
            //unitLabel.backgroundColor = UIColor(patternImage: UIImage(named: "VIN_IKON")!)
            secViewCon.fetchBeerFromSwipe = "Beer"
            secViewCon.fetchUnitType = "Beer"
            secViewCon.storeUnitValues()
        }
        if(self.pageIndex == 1){
            secViewCon.fetchWineFromSwipe = "Wine"
            secViewCon.fetchUnitType = "Wine"
            secViewCon.storeUnitValues()
        }
        if(self.pageIndex == 2){
            secViewCon.fetchDrinkFromSwipe = "Drink"
            secViewCon.fetchUnitType = "Drink"
            secViewCon.storeUnitValues()
        }
        if(self.pageIndex == 3){
            secViewCon.fetchShotFromSwipe = "Shot"
            secViewCon.fetchUnitType = "Shot"
            secViewCon.storeUnitValues()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
