//  InnstillingerMenyViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 07.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class InnstillingerMenyViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewForChange: UIView!
    @IBOutlet weak var backgroundViewForShow: UIView!
    @IBOutlet weak var goalBackgroundView: UIView!
    @IBOutlet weak var guidanceViewBackground: UIView!
    @IBOutlet weak var notificationBakground: UIView!
    
    @IBOutlet weak var userBtnOutlet: UIButton!
    @IBOutlet weak var costsBtnOutlet: UIButton!
    @IBOutlet weak var goalBtnOutlet: UIButton!
    @IBOutlet weak var instructionBtnOutlet: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // ARROWS: 
    @IBOutlet weak var userArrow: UIImageView!
    @IBOutlet weak var costArrow: UIImageView!
    @IBOutlet weak var goalArrow: UIImageView!
    @IBOutlet weak var guidanceArrow: UIImageView!
    @IBOutlet weak var alertArrow: UIImageView!
    
    // SWITCHES
    @IBOutlet weak var turnOffNotificationsSwitchOutlet: UISwitch!
    @IBOutlet weak var secondSwitchOutlet: UISwitch!
    var notificIsOn = false
    
    // Set Colors
    let setAppColors = AppColors()
    
    // get brain
    let brain = SkallMenyBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // COLORS AND FONTS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        self.navigationItem.title = "Innstillinger"
        
        self.backgroundViewForChange.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.backgroundViewForShow.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.goalBackgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.guidanceViewBackground.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.notificationBakground.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.userBtnOutlet.setTitle("", forState: UIControlState.Normal)
        self.userBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        self.costsBtnOutlet.setTitle("", forState: UIControlState.Normal)
        self.goalBtnOutlet.setTitle("", forState: UIControlState.Normal)
        self.instructionBtnOutlet.setTitle("", forState: UIControlState.Normal)
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        setConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        
        notificIsOn = getNotificationValue()
        print("Is notificationsOn: \(notificIsOn)")
        if(notificIsOn == true){
            turnOffNotificationsSwitchOutlet.on = automaticallyAdjustsScrollViewInsets
        } else {
            turnOffNotificationsSwitchOutlet.on = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if (!(parent?.isEqual(self.parentViewController) ?? false)) {
            print("Back Button Pressed!")
        }
    }
    
    // CHANGE COLOR WHEN TAPPING
    
    // BRUKERINFORMASJON
    @IBAction func userBtnPressedColor(sender: AnyObject) {
        // TOUCH UP INSIDE
        self.userBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    @IBAction func userBtnReleasedColor(sender: AnyObject) {
        // TOUCH DOWN
        self.userBtnOutlet.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
    }
    
    @IBAction func userBtnReleasedWhileSwipingColor(sender: AnyObject) {
        // TOUCH DRAG OUTSIDE
        self.userBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    // KOSTNADER
    @IBAction func costsBtnPressedColor(sender: AnyObject) {
        self.costsBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    @IBAction func costsBtnReleased(sender: AnyObject) {
        // TOUCH DOWN
        self.costsBtnOutlet.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
    }
    
    @IBAction func costsBtnRelasedWhenDragged(sender: AnyObject) {
        self.costsBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    // MÅLSETNINGER
    @IBAction func goalPressedColor(sender: AnyObject) {
        self.goalBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    @IBAction func goalReleasedColor(sender: AnyObject) {
        self.goalBtnOutlet.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
    }
    
    @IBAction func goalDragOutsideReleasedColor(sender: AnyObject) {
        self.goalBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    // VEILEDNING
    
    @IBAction func guidancePressedColor(sender: AnyObject) {
        self.instructionBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    @IBAction func guidanceReleasedColor(sender: AnyObject) {
        self.instructionBtnOutlet.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
    }
    
    @IBAction func guidanceDraggedColor(sender: AnyObject) {
        self.instructionBtnOutlet.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            setScrollViewSize(540)
            setArrowYValue(-80)
            setSwitchYValue(-50)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            setScrollViewSize(520)
            setArrowYValue(-60)
            setSwitchYValue(-50)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            setScrollViewSize(400)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            setScrollViewSize(400)
            setArrowYValue(25)
            setSwitchYValue(20)
        }
    }
    
    func setArrowYValue(yValue: CGFloat){
        // ARROWS
        self.userArrow.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
        self.costArrow.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
        self.goalArrow.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
        self.guidanceArrow.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
        self.alertArrow.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
    }
    
    func setSwitchYValue(yValue: CGFloat){
        // SWITCHES
        self.turnOffNotificationsSwitchOutlet.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
        self.secondSwitchOutlet.transform = CGAffineTransformTranslate(self.view.transform, yValue, 0.0)
    }
    
    func setScrollViewSize(height: CGFloat){
        scrollView.contentSize.height = height
    }
    
    // SWITCH
    @IBAction func switchNotifications(sender: AnyObject) {
        if(turnOffNotificationsSwitchOutlet.on){
            notificIsOn = true
            print("Toggle: \(notificIsOn)")
            storedBoolNotificValue()
        } else {
            notificIsOn = false
            print("toggle: \(notificIsOn)")
            storedBoolNotificValue()
        }
    }
    
    enum defaultKeysInst {
        static let boolKey = "notificationKey"
    }
    
    func storedBoolNotificValue(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let _ = defaults.setBool(notificIsOn, forKey: defaultKeysInst.boolKey)
        defaults.synchronize()
    }
    
    func getNotificationValue() -> Bool {
        var tempBool : Bool = false
        let defaults = NSUserDefaults.standardUserDefaults()
        if let boleanNotific : Bool = defaults.boolForKey(defaultKeysInst.boolKey) {
            tempBool = boleanNotific
            
        }
        return tempBool
    }
}
