//  HomeViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 28.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var containerViewOUt: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var instBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 934
        setColorsHomeView()
        if(isGoalDateReached()) { self.performSegueWithIdentifier("goalDateSegue", sender: self) }
    }
    
    func setColorsHomeView(){
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    func isGoalDateReached() -> Bool {
        let brainCoreData = CoreDataMethods()
        return NSDate().compare(brainCoreData.fetchGoalDate()) == NSComparisonResult.OrderedDescending
    }
}