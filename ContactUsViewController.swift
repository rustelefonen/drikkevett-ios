//
//  ContactUsViewController.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 02.08.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var imgOpenWebPage: UIImageView!
    @IBOutlet weak var btnOpenWebPage: UIButton!
    @IBOutlet weak var imgCallUs: UIImageView!
    @IBOutlet weak var btnCallUs: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headPicture: UIImageView!
    
    let rustelefonenPhoneNumber = "08588"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    @IBAction func btnCallUs(_ sender: AnyObject) {
        if let url = URL(string: "tel://\(rustelefonenPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {UIApplication.shared.open(url)}
            else {UIApplication.shared.openURL(url)}
        }
    }
}
