//  VeiledningInnholdViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 09.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class VeiledningInnholdViewController: UIViewController {

    let setAppColors = AppColors()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    var textViewString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        self.imageView.image = UIImage(named: self.imageFile)
        self.titleLabel.text = self.titleText
        self.textView.text = self.textViewString
        if(self.titleLabel.text == "Utregning"){
            self.textView.textAlignment = .left
        }
        
    }
    
    func setDesign(){
        // COLORS AND FONTS
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        self.titleLabel.font = setAppColors.titleFont(28)
        self.titleLabel.textColor = setAppColors.textHeadlinesColors()
        self.textView.font = setAppColors.textViewFont(15)
        self.textView.textColor = setAppColors.textViewsColors()
        self.textView.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
