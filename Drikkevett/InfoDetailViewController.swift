//
//  InfoDetailViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 19.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {
    
    static let segueId = "detailSegue"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var info:Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        let setAppColors = AppColors()
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        self.textView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.textView.textColor = setAppColors.textViewsColors()
        self.textView.font = setAppColors.textViewsFonts()
        
        self.navigationItem.title = info?.title
        self.textView.text = info?.text
        self.imageView.image = UIImage(named: (info?.image)!)
    }
}
