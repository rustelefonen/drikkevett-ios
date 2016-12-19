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
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    @IBAction func btnCallUs(_ sender: AnyObject) {
        callNumber("08588") // 08588 rustelefonen sitt nr
    }
    
    fileprivate func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    func setColors(){
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.headPicture.isHidden = true
            self.textView.transform = self.view.transform.translatedBy(x: 0.0, y: -150.0)
            self.imgCallUs.transform = self.view.transform.translatedBy(x: 20.0, y: 0.0)
            self.btnCallUs.transform = self.view.transform.translatedBy(x: 20.0, y: 0.0)
            self.imgOpenWebPage.transform = self.view.transform.translatedBy(x: -20.0, y: 0.0)
            self.btnOpenWebPage.transform = self.view.transform.translatedBy(x: -20.0, y: 0.0)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.headPicture.transform = self.view.transform.translatedBy(x: 0.0, y: -50.0)
            self.textView.transform = self.view.transform.translatedBy(x: 0.0, y: -50.0)
            
            self.imgCallUs.transform = self.view.transform.translatedBy(x: 20.0, y: 0.0)
            self.btnCallUs.transform = self.view.transform.translatedBy(x: 20.0, y: 0.0)
            self.imgOpenWebPage.transform = self.view.transform.translatedBy(x: -20.0, y: 0.0)
            self.btnOpenWebPage.transform = self.view.transform.translatedBy(x: -20.0, y: 0.0)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6 ( OK )
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+ ( OK )
        }
    }
}
