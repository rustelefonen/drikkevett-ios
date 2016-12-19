//  ContentViewController.swift
//  UIPageViewController
//
//  Created by PJ Vea on 3/27/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.

import UIKit

class InnholdViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var pageIndex = Int()
    var imageFile = String()
    var titleString = String()
    var textString = String()
    
    // set colors
    let setAppColors = AppColors()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setDesign()
        setConstraints()
        self.imageView.image = UIImage(named: self.imageFile)
        self.titleLabel.text = "\(titleString)"
        self.textView.text = "\(textString)"
    }
    
    func setDesign(){
        // COLORS AND FONTS
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        self.titleLabel.font = setAppColors.titleFont(25)
        self.titleLabel.textColor = setAppColors.textHeadlinesColors()
        self.textView.font = setAppColors.textViewFont(16)
        self.textView.textColor = setAppColors.textViewsColors()
        self.textView.backgroundColor = UIColor.clear
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.textView.font = setAppColors.textViewFont(12)
            self.textView.transform = self.view.transform.translatedBy(x: 0.0, y: -20.0)

        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -30.0)
            self.textView.font = setAppColors.textViewFont(14)
            self.textView.transform = self.view.transform.translatedBy(x: 0.0, y: -40.0)
            self.imageView.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: 26.0)
            self.titleLabel.font = setAppColors.titleFont(25)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
