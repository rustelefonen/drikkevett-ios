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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColors()
        setConstraints()
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    @IBAction func btnCallUs(sender: AnyObject) {
        callNumber("08588") // 08588 rustelefonen sitt nr
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    func setColors(){
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.headPicture.hidden = true
            self.textView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -150.0)
            self.imgCallUs.transform = CGAffineTransformTranslate(self.view.transform, 20.0, 0.0)
            self.btnCallUs.transform = CGAffineTransformTranslate(self.view.transform, 20.0, 0.0)
            self.imgOpenWebPage.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.btnOpenWebPage.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.headPicture.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -50.0)
            self.textView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -50.0)
            
            self.imgCallUs.transform = CGAffineTransformTranslate(self.view.transform, 20.0, 0.0)
            self.btnCallUs.transform = CGAffineTransformTranslate(self.view.transform, 20.0, 0.0)
            self.imgOpenWebPage.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.btnOpenWebPage.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6 ( OK )
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+ ( OK )
        }
    }
}
