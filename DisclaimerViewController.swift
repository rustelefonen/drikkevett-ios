//
//  DisclaimerViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 08.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
    
    static let storyboardId = "disclaimer"
    @IBOutlet weak var agreeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        agreeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToIntro)))
    }
    
    func navigateToIntro() {
        performSegue(withIdentifier: IntroPageViewController.segueId, sender: self)
    }
}
