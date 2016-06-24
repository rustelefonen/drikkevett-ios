//  HomeViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 28.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import CoreData
import UIKit

class HomeViewController: UIViewController {
    
    // Talk with core data
    let moc = DataController().managedObjectContext
    var brainCoreData = CoreDataMethods()
    
    // Set colors
    var setAppColors = AppColors()
    
    var logItems = [Historikk]()
    var datesGraph = [GraphHistorikk]()
    
    // Outlets
    @IBOutlet weak var containerViewOUt: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var instBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var getGoalPromille = 0.0
    var getGoalDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nHomeView Loaded...")
        scrollView.contentSize.height = 934
        
        setColorsHomeView()
        
        print("Er måldato nådd: \(isGoalDateReached())")
        if(isGoalDateReached() == true){ // skal være TRUE
            self.performSegueWithIdentifier("goalDateSegue", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\nHomeView Appeared...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setColorsHomeView(){
        // BACKGROUND
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        // BLUR
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // HEADER AND BAR BUTTON NAME:
        self.navigationItem.title = "Hjem"
        self.tabBarItem.title = "Hjem"
    }
    
    func isGoalDateReached() -> Bool{
        var hasGoalDateBeen = false
        let currentDate = NSDate()
        
        if currentDate.compare(brainCoreData.fetchGoalDate()) == NSComparisonResult.OrderedDescending {
            print("Datoen har vært...")
            print("Current Date: \(currentDate), Goal Date: \(brainCoreData.fetchGoalDate())")
            hasGoalDateBeen = true
            
        } else {
            print("Datoen kommer!")
            print("Current Date: \(currentDate), Goal Date: \(brainCoreData.fetchGoalDate())")
            hasGoalDateBeen = false
        }
        return hasGoalDateBeen
    }
}