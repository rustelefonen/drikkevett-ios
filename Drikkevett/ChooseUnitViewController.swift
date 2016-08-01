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
    
    var setAppColors = AppColors()
    
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
}
