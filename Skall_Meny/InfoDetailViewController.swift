//
//  InfoDetailViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 19.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {
    
    let setAppColors = AppColors()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var detailImage = UIImage()
    var titleOnInf = ""
    var longText = ""
    
    @IBOutlet weak var showWebSiteBtnOutlet: UIButton!
    @IBOutlet weak var callUsBtnOutlet: UIButton!
    @IBOutlet weak var showWebSiteImageView: UIImageView!
    @IBOutlet weak var callUsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        self.textView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.textView.textColor = setAppColors.textViewsColors()
        self.textView.font = setAppColors.textViewsFonts()
        
        self.navigationItem.title = "\(titleOnInf)"
        self.textView.text = "\(longText)"
        self.imageView.image = self.detailImage
        
        if(titleOnInf == "Kontakt oss"){
            showWebSiteBtnOutlet.enabled = true
            showWebSiteBtnOutlet.hidden = false
            callUsBtnOutlet.enabled = true
            callUsBtnOutlet.hidden = false
            showWebSiteImageView.hidden = false
            callUsImageView.hidden = false
            
        } else {
            showWebSiteBtnOutlet.enabled = false
            showWebSiteBtnOutlet.hidden = true
            callUsBtnOutlet.enabled = false
            callUsBtnOutlet.hidden = true
            showWebSiteImageView.hidden = true
            callUsImageView.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func visitWebPageBtn(sender: AnyObject) {
        
    }
    
    @IBAction func callUsBtn(sender: AnyObject) {
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
}
