//  KostnaderViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 01.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class KostnaderViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var costsBeerLabel: UITextField!
    @IBOutlet weak var costsWineTextField: UITextField!
    @IBOutlet weak var costsDrinkTextField: UITextField!
    @IBOutlet weak var costsShotTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var beerTitleLabel: UILabel!
    @IBOutlet weak var wineTitleLabel: UILabel!
    @IBOutlet weak var drinkTitleLabel: UILabel!
    @IBOutlet weak var shotTitleLabel: UILabel!
    
    // TEXTVIEW
    @IBOutlet weak var textView: UITextView!
    
    // STANDARD OUTLET BTN
    @IBOutlet weak var standardPrizesBtnOutlet: UIButton!
    @IBOutlet weak var standardBtnImageView: UIImageView!
    
    // NEXT BTN
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var nextBtnImageView: UIImageView!
    
    // SCROLL VIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    // TITLE IMAGE
    @IBOutlet weak var titleImageView: UIImageView!
    
    // UNIT IMAGES
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    // UNDERSCORES
    @IBOutlet weak var beerUnderscore: UILabel!
    @IBOutlet weak var wineUnderscor: UILabel!
    @IBOutlet weak var drinkUnderscore: UILabel!
    @IBOutlet weak var shotUnderscore: UILabel!
    
    // Kommunikasjon med database/core data
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // set Colors
    var setAppColors = AppColors()
    
    // PARSE VALUES -
    var beerCostsInfo : Int! = 0
    var wineCostsInfo : Int! = 0
    var drinkCostsInfo : Int! = 0
    var shotCostsInfo : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsEnterCosts()
        setConstraints()
    }
    
    func setColorsAndFontsEnterCosts(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TITLE OG SUBTITLE
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(34)
        subTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(18)
        
        // LABELS
        beerTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        beerTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        wineTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        wineTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        drinkTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        drinkTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        wineTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        wineTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        
        // TEXTFIELDS ( SKREVET FEIL BEER SKAL VÆRE TEXTFIELD IKKE LABEL )
        costsBeerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        costsBeerLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        costsBeerLabel.attributedPlaceholder = NSAttributedString(string:"oppgi ølpris",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        costsWineTextField.textColor = setAppColors.textUnderHeadlinesColors()
        costsWineTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        costsWineTextField.attributedPlaceholder = NSAttributedString(string:"oppgi vinpris",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        costsDrinkTextField.textColor = setAppColors.textUnderHeadlinesColors()
        costsDrinkTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        costsDrinkTextField.attributedPlaceholder = NSAttributedString(string:"oppgi drinkpris",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        costsShotTextField.textColor = setAppColors.textUnderHeadlinesColors()
        costsShotTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        costsShotTextField.attributedPlaceholder = NSAttributedString(string:"oppgi shotpris",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        standardPrizesBtnOutlet.setTitle("Standard", forState: UIControlState.Normal)
        
        // BUTTONS
        self.standardPrizesBtnOutlet.titleLabel?.textAlignment = NSTextAlignment.Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        //Parsing String values from UITextField to Integers:
        beerCostsInfo = Int(costsBeerLabel.text!)
        wineCostsInfo = Int(costsWineTextField.text!)
        drinkCostsInfo = Int(costsDrinkTextField.text!)
        shotCostsInfo = Int(costsShotTextField.text!)
        
        //Handling wrong inputs in UITextFields:
        if(beerCostsInfo == nil || wineCostsInfo == nil || drinkCostsInfo == nil || shotCostsInfo == nil){
            beerCostsInfo = 0; wineCostsInfo = 0; drinkCostsInfo = 0; shotCostsInfo = 0;
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        }
        if(beerCostsInfo >= 10000 || beerCostsInfo <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for øl?")
        }
        if(wineCostsInfo >= 10000 || wineCostsInfo <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for vin?")
        }
        if(drinkCostsInfo >= 10000 || drinkCostsInfo <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for drink?")
        }
        if(shotCostsInfo >= 10000 || shotCostsInfo <= 0){
            errorMessage(errorMsg: "Så mye betaler du ikke for shot?")
        }
        //Printing input values in console:
        else if let beerString:String! = String(beerCostsInfo!), wineString:String = String(wineCostsInfo), drinkString:String = String(drinkCostsInfo), shotString:String = String(shotCostsInfo){
            
            let message = "Øl: \(beerCostsInfo) kr\nVin: \(wineCostsInfo) kr\nDrink: \(drinkCostsInfo) kr\nShot: \(shotCostsInfo) kr"
            confirmMessage("Kostnader", errorMsg: message, cancelMsg:"Avbryt", confirmMsg: "Bekreft")
        }
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmMessage(titleMsg:String = "Bekreft", errorMsg:String = "Informasjon", cancelMsg:String = "Avbryt", confirmMsg: String = "Bekreft" ){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancelMsg, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
            print("Handle cancel logic here")
        }))
        
        alertController.addAction(UIAlertAction(title:confirmMsg, style: UIAlertActionStyle.Default, handler:  { action in
            self.brainCoreData.updateUserDataCosts(self.beerCostsInfo, updateWineCost: self.wineCostsInfo, updateDrinkCost: self.drinkCostsInfo, updateShotCost: self.shotCostsInfo)

            self.performSegueWithIdentifier("kostnadTilMalSegue"
            , sender: self) }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func useDefaultCosts(sender: AnyObject) {
        self.costsBeerLabel.text = "31"
        self.costsWineTextField.text = "59"
        self.costsDrinkTextField.text = "110"
        self.costsShotTextField.text = "97"
    }
    
    // SCROLL VIEW
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        // hvor høyt tekstfieldet skal flyttes
        
        // iphone 4
        let moveTextFieldIphoneFour : CGFloat = 190
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 140
        
        // iPhone 6
        let moveTextField : CGFloat = 120
        
        // iphone 6+
        let moveTextFieldIphoneSixPlus : CGFloat = 70
        
        if(textField == costsBeerLabel){
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
        if(textField == costsWineTextField){
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
        if(textField == costsDrinkTextField){
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
        if(textField == costsShotTextField){
            
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
        costsBeerLabel.inputAccessoryView = keyboardToolbar
        costsWineTextField.inputAccessoryView = keyboardToolbar
        costsDrinkTextField.inputAccessoryView = keyboardToolbar
        costsShotTextField.inputAccessoryView = keyboardToolbar
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
                prospectiveText.characters.count <= 4
        default:
            return true
        }
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.titleImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -125.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -130.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -150.0)
            self.textView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -160.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -200.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -230.0)
            self.nextBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -230.0)
            self.standardBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -230.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -230.0)
            
            setTextSizes(9, title: 30, subtitle: 17)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.titleImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -130.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -140.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -160.0)
            self.textView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -165.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -180.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -180.0)
            self.nextBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, -50.0, -180.0)
            self.standardBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -180.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -20.0, -180.0)
            
            setTextSizes(10, title: 27, subtitle: 17)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            setConstValues(0.0, yValue: -100.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.titleImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.textView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -60.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
            self.nextBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
            self.standardBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
            self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 20.0, -60.0)
        }
    }
    
    func setConstValues(xValue: CGFloat, yValue: CGFloat){
        
        // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
        self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.titleImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.textView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        
        setTextFieldPlaces(xValue, yAxisTextFields: yValue)
        
        // STANDARD AND NEXT ( IMG AND BTNS )
        self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.nextBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.standardBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.standardPrizesBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
    }
    
    func setTextSizes(textViewFontSize: CGFloat, title: CGFloat, subtitle: CGFloat){
        // TITLE AND SUBTITLE
        self.titleLabel.font = setAppColors.textHeadlinesFonts(title)
        self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(subtitle)
        
        // TEXT VIEW FONT
        self.textView.font = setAppColors.setTextQuoteFont(textViewFontSize)
    }
    
    func setTextFieldPlaces(xValue: CGFloat, yAxisTextFields: CGFloat){
        // TITLE UNITS
        self.beerTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        
        // TEXTFIELDS
        self.costsBeerLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.costsWineTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.costsDrinkTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.costsShotTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT IMAGES
        self.beerImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT UNDERSCORES
        self.beerUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.wineUnderscor.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.drinkUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.shotUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
    }
 }
