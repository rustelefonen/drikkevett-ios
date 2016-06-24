//  OppdaterKostnaderViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 01.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class OppdaterKostnaderViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    // HEADER
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerSubtitle: UILabel!
    
    // TEXT FIELD TITLES
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var wineLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var shotLabel: UILabel!
    
    // HEADER TITLE
    @IBOutlet weak var titleLabel: UILabel!
    
    // TEXTFIELDS
    @IBOutlet weak var beerTextField: UITextField!
    @IBOutlet weak var wineTextField: UITextField!
    @IBOutlet weak var drinkTextField: UITextField!
    @IBOutlet weak var shotTextField: UITextField!
    
    // TEXT FIELD IMAGES
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    // UNDERSCORES
    @IBOutlet weak var beerUnderscore: UILabel!
    @IBOutlet weak var wineUnderscore: UILabel!
    @IBOutlet weak var drinkUnderscore: UILabel!
    @IBOutlet weak var shotUnderscore: UILabel!
    
    // BUTTONS
    @IBOutlet weak var standardPrizesBtnOutlet: UIButton!
    @IBOutlet weak var saveCostsBtnOutlet: UIButton!
    
    // BUTTON IMAGES
    @IBOutlet weak var standardImageView: UIImageView!
    @IBOutlet weak var saveImageView: UIImageView!
    
    // Kommunikasjon med database/Core Data
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // set Colors
    let setAppColors = AppColors()
    
    // PARSE VALUES -
    var updateBeerCost : Int! = 0
    var updateWineCost : Int! = 0
    var updateDrinkCost : Int! = 0
    var updateShotCost : Int! = 0
    
    // TEMP VALUES 
    var tempUpdateBeerCost = 0
    var tempUpdateWineCost = 0
    var tempUpdateDrinkCost = 0
    var tempUpdateShotCost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsUpdateCosts()
        fetchUserData()
        self.scrollView.delegate = self
        //scrollView.contentSize.height = 800
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    func setColorsAndFontsUpdateCosts(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXT FIELDS
        beerTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        beerTextField.textColor = setAppColors.textUnderHeadlinesColors()
        beerTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på øl",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        wineTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        wineTextField.textColor = setAppColors.textUnderHeadlinesColors()
        wineTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på vin",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        drinkTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        drinkTextField.textColor = setAppColors.textUnderHeadlinesColors()
        drinkTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på drink",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        shotTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        shotTextField.textColor = setAppColors.textUnderHeadlinesColors()
        shotTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på shot",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        // LABELS
        beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        beerLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
        wineLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        drinkLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        shotLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(30)
        
        // BUTTONS
        self.saveCostsBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        self.standardPrizesBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        self.standardPrizesBtnOutlet.titleLabel?.textAlignment = NSTextAlignment.Center
        //self.standardPrizesBtnOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func updateButton(sender: AnyObject) {
        //Parsing String values from UITextField to Integers:
        updateBeerCost = Int(beerTextField.text!)
        updateWineCost = Int(wineTextField.text!)
        updateDrinkCost = Int(drinkTextField.text!)
        updateShotCost = Int(shotTextField.text!)
        
        //Handling wrong inputs in UITextFields:
        // ØL
        if(updateBeerCost == nil){
            updateBeerCost = tempUpdateBeerCost
        }
        // VIN
        if(updateWineCost == nil){
            updateWineCost = tempUpdateWineCost
        }
        // DRINK
        if(updateDrinkCost == nil){
            updateDrinkCost = tempUpdateDrinkCost
        }
        // SHOT
        if(updateShotCost == nil){
            updateShotCost = tempUpdateShotCost
        }
        // ØL
        if(updateBeerCost >= 150 || updateBeerCost <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for øl?")
        }
        
        // VIN
        if(updateWineCost >= 150 || updateWineCost <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for vin?")
        }
        
        // DRINK
        if(updateDrinkCost >= 150 || updateDrinkCost <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for drink?")
        }

        // SHOT
        if(updateShotCost >= 150 || updateShotCost <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for shot?")
        }
        
        //Printing input values in console:
        else if let beerString:String! = String(updateBeerCost!), wineString:String = String(updateWineCost), drinkString:String = String(updateDrinkCost), shotString:String = String(updateShotCost){
            
            brainCoreData.updateUserDataCosts(updateBeerCost, updateWineCost: updateWineCost, updateDrinkCost: updateDrinkCost, updateShotCost: updateShotCost)
            fetchUserData()
            
            savedAlertController("Lagret", message: "", delayTime: 1.3)
        }
    }
    
    // SETT STANDARD VALUES:
    @IBAction func setStandardPrizesBtn(sender: AnyObject) {
        self.beerTextField.text = "31"
        self.wineTextField.text = "59"
        self.drinkTextField.text = "110"
        self.shotTextField.text = "97"
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            
            for item in userData {
                tempUpdateBeerCost = item.costsBeer! as Int
                self.beerTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateBeerCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.beerTextField.text = ""
                tempUpdateWineCost = item.costsWine! as Int
                self.wineTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateWineCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.wineTextField.text = ""
                tempUpdateDrinkCost = item.costsDrink! as Int
                self.drinkTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateDrinkCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.drinkTextField.text = ""
                tempUpdateShotCost = item.costsShot! as Int
                self.shotTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateShotCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.shotTextField.text = ""
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.scrollView.endEditing(true)
    }
    
    // Alert om at du har lagret ting.
    func savedAlertController(title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        self.presentViewController(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        // iphone 4
        let moveTextFieldIphoneFour : CGFloat = 136
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 75 // 120
        
        // iPhone 6
        let moveTextField : CGFloat = 38
        
        // iphone 6+
        let moveTextFieldIphoneSixPlus : CGFloat = 20
        
        if(textField == beerTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 90), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == wineTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == drinkTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == shotTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        addDoneButton()
        //else kan brukes for å håndtere andre textfields som ikke må dyttes like høyt opp!
    }
    //Funksjonen under sørger for at tastaturet forsvinner når en trykker return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Funksjonen under sørger for å re-posisjonere tekstfeltet etter en har skrevet noe.
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        keyboardToolbar.alpha = 0.9
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        //flexBarButton.tintColor = UIColor.whiteColor()
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: view, action: #selector(UIView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.whiteColor()
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        beerTextField.inputAccessoryView = keyboardToolbar
        wineTextField.inputAccessoryView = keyboardToolbar
        drinkTextField.inputAccessoryView = keyboardToolbar
        shotTextField.inputAccessoryView = keyboardToolbar
    }
    
    // MAXIMIZE TEXTFIELDS
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case textField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 5
        default:
            return true
        }
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -130.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -150.0)
            self.headerSubtitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -170.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -200.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -250.0)
            self.saveImageView.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -250.0)
            self.standardImageView.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -250.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -250.0)
            
            setTextSizes(20, subtitle: 11)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -130.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -140.0)
            self.headerSubtitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -155.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -170.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -175.0)
            self.saveImageView.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -175.0)
            self.standardImageView.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -175.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -175.0)
            
            //setTextSizes(10, title: 27, subtitle: 17)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            setAllConstValues(0.0, yValue: -100.0)
            
            self.standardImageView.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -100.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -100.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.headerSubtitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -60.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
            self.saveImageView.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
            self.standardImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
        }
    }
    
    func setAllConstValues(xValue: CGFloat, yValue: CGFloat){
        
        // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
        self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.headerSubtitle.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        
        setTextFieldPlaces(xValue, yAxisTextFields: yValue)
        
        // STANDARD AND NEXT ( IMG AND BTNS )
        self.saveCostsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.saveImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.standardImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
    }
    
    func setTextFieldPlaces(xValue: CGFloat, yAxisTextFields: CGFloat){
        // TITLE UNITS
        self.beerLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // TEXTFIELDS
        self.beerTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT IMAGES
        self.beerImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT UNDERSCORES
        self.beerUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
    }
    
    func setTextSizes(title: CGFloat, subtitle: CGFloat){
        // TITLE AND SUBTITLE
        self.titleLabel.font = setAppColors.textHeadlinesFonts(title)
        self.headerSubtitle.font = setAppColors.textUnderHeadlinesFonts(subtitle)
    }
}
