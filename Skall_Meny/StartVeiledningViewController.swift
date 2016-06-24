//  StartVeiledningViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 07.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class StartVeiledningViewController: UIViewController {
    
    // set Colors
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // COLORS AND FONTS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        
        let pageControll = UIPageControl.appearance()
        pageControll.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
