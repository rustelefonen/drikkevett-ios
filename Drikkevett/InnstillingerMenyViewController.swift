//  InnstillingerMenyViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 07.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class InnstillingerMenyViewController: UIViewController {
    
    // Set Colors
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // COLORS AND FONTS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        self.navigationItem.title = "Innstillinger"
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if (!(parent?.isEqual(self.parentViewController) ?? false)) {
            print("Back Button Pressed!")
        }
    }
}
