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
        view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        unitImageView.image = UIImage(named: imageFile)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.pageIndex == 0){
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
}
