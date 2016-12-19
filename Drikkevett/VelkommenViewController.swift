//
//  VelkommenViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 21.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class VelkommenViewController: UIViewController {
    
    let setAppColors = AppColors()
    
    let whatThaFuckIsHappning = CoreDataMethods()
    
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    
    // OUTLET BUTTONS
    @IBOutlet weak var getStartedBtnOutlet: UIButton!
    @IBOutlet weak var guidanceBtnOutlet: UIButton!
    
    // IMAGE
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var getStartedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAppAlreadyLaunchedOnce()
        setColorsAndFonts()
        setConstraints()
    }
    
    func setColorsAndFonts(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.welcomeTextLabel.text = "Velkommen!"
        self.welcomeTextLabel.font = setAppColors.welcomeTextHeadlinesFonts(35)
        self.welcomeTextLabel.textColor = setAppColors.textHeadlinesColors()
        self.explanationTextView.font = setAppColors.textViewFont(16)
        self.explanationTextView.textColor = setAppColors.textViewsColors()
        self.guidanceBtnOutlet.setTitle("Ønsker du veiledning? Klikk her!", for: UIControlState())
        self.guidanceBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        self.getStartedBtnOutlet.setTitle("Sett i gang", for: UIControlState())
        self.getStartedBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        
        // PIC
        self.headPicImageView.layer.cornerRadius = 55
        self.headPicImageView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timeToMoveOn() {
        self.performSegue(withIdentifier: "regCompletedSegue", sender: self) // tar deg til appen når du har logget inn
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            // HVIS REGISTRATION ER FULLFØRT:
            if(checkIfRegistrationWasCompleted() == true){
                welcomeImageView.isHidden = false
                //imageShit.hidden = false
                let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(VelkommenViewController.timeToMoveOn), userInfo: nil, repeats: false)
            }
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    func checkIfRegistrationWasCompleted() -> Bool{
        let defaults = UserDefaults.standard
        // SESJON START
        if let bool : Bool = defaults.bool(forKey: "isFirstRegistrationCompleted") {
            print("\(bool)")
            return bool
        }
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.headPicImageView.transform = self.view.transform.translatedBy(x: 0.0, y: 145.0)
            textsConst(0.0, yValue: 40.0)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.headPicImageView.transform = self.view.transform.translatedBy(x: 0.0, y: 110.0)
            textsConst(0.0, yValue: 30.0)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            
        }
    }
    
    func textsConst(_ xValue: CGFloat, yValue: CGFloat){
        // TEXT VIEW AND TITLE
        self.welcomeTextLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.explanationTextView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        
        // BUTTONS
        self.getStartedBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.getStartedImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
    }
    
}
