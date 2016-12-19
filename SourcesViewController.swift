//
//  SourcesViewController.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 02.08.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController {

    @IBOutlet weak var iconsTitle: UILabel!
    @IBOutlet weak var iconsTextView: UITextView!
    @IBOutlet weak var librariesTitle: UILabel!
    @IBOutlet weak var librariesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    func setColors(){
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.iconsTitle.font = setAppColors.titleFont(22)
        self.librariesTitle.font = setAppColors.titleFont(22)
        self.iconsTitle.textColor = setAppColors.textHeadlinesColors()
        self.librariesTitle.textColor = setAppColors.textHeadlinesColors()
        
        self.iconsTextView.font = setAppColors.textViewFont(16)
        self.librariesTextView.font = setAppColors.textViewFont(16)
        self.iconsTextView.textColor = setAppColors.textViewsColors()
        self.librariesTextView.textColor = setAppColors.textViewsColors()
    }
}
