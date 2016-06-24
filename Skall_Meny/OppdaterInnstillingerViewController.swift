//  OppdaterInnstillingerViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 14.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class OppdaterInnstillingerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    // Kommunikasjon med database/Core Data
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // set Colors
    let setAppColors = AppColors()
    
    // SCROLLVIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    // TITLE FOR TEXTFIELDS
    @IBOutlet weak var kjonnLabel: UILabel!
    @IBOutlet weak var alderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    // HEADER
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var chooseGenderTextField: UITextField!
    @IBOutlet weak var nicknameImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var ageImageview: UIImageView!
    @IBOutlet weak var weightImageView: UIImageView!
    
    // UNDERSCORES
    @IBOutlet weak var nickenameUnderscore: UILabel!
    @IBOutlet weak var genderUnderscore: UILabel!
    @IBOutlet weak var ageUnderscore: UILabel!
    @IBOutlet weak var weightUnderscore: UILabel!
    
    // Buttons
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var saveBtnImageView: UIImageView!
    
    //
    
    // Update Value variables
    var updateGender : Bool = true
    var updateAge : Int! = 0
    var updateHeight : String! = ""
    var updateWeight : Double! = 0.0
    var updateGenderString : String! = ""
    
    // Temp VARIABELS
    // Update Value variables
    var tempUpdateGender : Bool = true
    var tempUpdateAge : Int! = 0
    var tempUpdateHeight : String! = ""
    var tempUpdateWeight : Double! = 0.0
    
    var gender = ""
    
    // sett verdier i picker view
    var pickerData = ["Mann", "Kvinne"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        setColorsAndFontsUpdateUserInfo()
        fetchUserData()
        ageTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        self.scrollView.delegate = self
        
        pickViewGenderTextField()
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        checkMaxLength(heightTextField, maxLength: 10)
        setConstraints()
    }
    
    func pickViewGenderTextField(){
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGrayColor()
        chooseGenderTextField.inputView = pickerView
    }
    
    func setColorsAndFontsUpdateUserInfo(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        //ageTextField.textColor = setAppColors.textUnderHeadlinesColors()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXT FIELDS
        ageTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        ageTextField.textColor = setAppColors.textUnderHeadlinesColors()
        ageTextField.attributedPlaceholder = NSAttributedString(string:"alder",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        heightTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        heightTextField.textColor = setAppColors.textUnderHeadlinesColors()
        heightTextField.attributedPlaceholder = NSAttributedString(string:"kallenavn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        weightTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        weightTextField.textColor = setAppColors.textUnderHeadlinesColors()
        weightTextField.attributedPlaceholder = NSAttributedString(string:"vekt",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.chooseGenderTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.chooseGenderTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"kjønn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        
        // LABELS
        alderLabel.textColor = setAppColors.textUnderHeadlinesColors()
        alderLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        kjonnLabel.textColor = setAppColors.textUnderHeadlinesColors()
        kjonnLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        weightLabel.textColor = setAppColors.textUnderHeadlinesColors()
        weightLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        heightLabel.textColor = setAppColors.textUnderHeadlinesColors()
        heightLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(30)
        
        // TITLE
        self.titleLabel.text = "Brukerinformasjon"
        
        // BUTTON
        self.saveBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        
        
        setButtonsRounded(setAppColors.roundedCorners())
    }
    
    func setButtonsRounded(turnOffOn: Bool){
        if(turnOffOn == true){
            // START END KVELDEN
            saveBtnOutlet.layer.cornerRadius = 25;
            saveBtnOutlet.layer.borderWidth = 0.5;
            saveBtnOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        //Parsing String values from UITextField to Integers:
        updateWeight = Double(weightTextField.text!)
        updateAge = Int(ageTextField.text!)
        updateHeight = String(heightTextField.text!)
        print("\(updateHeight)")
        updateGenderString = String(chooseGenderTextField.text!)
        
        if(updateAge == nil){
            updateAge = tempUpdateAge
        }
        if(updateWeight == nil){
            updateWeight = tempUpdateWeight
        }
        if(updateHeight == nil || updateHeight == ""){
            updateHeight = tempUpdateHeight
        }
        if (updateGenderString == nil || updateGenderString == ""){
            updateGender = tempUpdateGender
        }
        brainCoreData.updateUserDataPersonalia(updateGender, updateAge: updateAge, updateWeight: updateWeight, updateHeight: updateHeight)
        if(updateGender == true){
            gender = "Mann"
        } else {
            gender = "Kvinne"
        }
        updateTextFields()
        savedAlertController("Lagret", message: "", delayTime: 1.3)
    }
    
    func updateTextFields(){
        self.ageTextField.attributedPlaceholder = NSAttributedString(string:"\(updateAge)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.ageTextField.text = ""
        
        self.heightTextField.attributedPlaceholder = NSAttributedString(string:"\(updateHeight)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.heightTextField.text = ""
        
        self.weightTextField.attributedPlaceholder = NSAttributedString(string:"\(updateWeight)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.weightTextField.text = ""
        
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"\(gender)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.chooseGenderTextField.text = ""
    }
    
    func infoIsStoredPopUp(titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.blackColor()
        alertContentView.layer.cornerRadius = 10
        //alertController.view.tintColor = UIColor.whiteColor()
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
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
                tempUpdateGender = item.gender! as Bool
                tempUpdateAge = item.age! as Int
                tempUpdateHeight = item.height! as String
                print("tempUpdateHeight: \(tempUpdateHeight)")
                tempUpdateWeight = item.weight! as Double
                
                if(tempUpdateGender == true){
                    gender = "Mann"
                }
                if(tempUpdateGender == false){
                    gender = "Kvinne"
                }
                self.ageTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateAge)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.heightTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateHeight)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.weightTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateWeight)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"\(gender)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    // PICKER METHODS
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //globalGender = pickerData[row]
        print("Kjønn: \(pickerData[row])")
        if(pickerData[row] == "Mann"){
            self.chooseGenderTextField.text = "Mann"
            updateGender = true
        }
        if(pickerData[row] == "Kvinne"){
            self.chooseGenderTextField.text = "Kvinne"
            updateGender = false
        }
        //label.text = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 0.01)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.Center
            pickerLabel?.textColor = UIColor.whiteColor()
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!;
    }
    
    func Alert(View: UIViewController, Title: String, TitleColor: UIColor, Message: String, MessageColor: UIColor, BackgroundColor: UIColor, BorderColor: UIColor, ButtonColor: UIColor) {
        
        let TitleString = NSAttributedString(string: Title, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : TitleColor])
        let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
        
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .Alert)
        
        alertController.setValue(TitleString, forKey: "attributedTitle")
        alertController.setValue(MessageString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // GJØR WHATEVS OK SHIT
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = BackgroundColor
        alertContentView.layer.cornerRadius = 10
        alertContentView.alpha = 1
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = BorderColor.CGColor
        
        
        //alertContentView.tintColor = UIColor.whiteColor()
        alertController.view.tintColor = ButtonColor
        
        View.presentViewController(alertController, animated: true) {
            // ...
        }
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
        
        // iphone 4 - forskjellige for hver enkelt textfield
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 110 // 117
        
        // iPhone 6
        let moveTextFieldSix : CGFloat = 86
        
        // iphone 6+
        let moveTextFieldSixPlus : CGFloat = 10
        
        if(textField == heightTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 65), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
            }
        }
        if(textField == chooseGenderTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 128), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
            }
        }
        if(textField == ageTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 128), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
            }
        }

        if(textField == weightTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 128), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
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
        ageTextField.inputAccessoryView = keyboardToolbar
        heightTextField.inputAccessoryView = keyboardToolbar
        weightTextField.inputAccessoryView = keyboardToolbar
        chooseGenderTextField.inputAccessoryView = keyboardToolbar
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        
        if (textField.text?.characters.count > maxLength) {
            textField.deleteBackward()
        }
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
            
        // Allow only upper- and lower-case vowels in this field,
        // and limit its contents to a maximum of 6 characters.
        case heightTextField:
            return prospectiveText.characters.count <= 15
            
        case weightTextField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 3
            
        // Allow only values that evaluate to proper numeric values in this field,
        // and limit its contents to a maximum of 7 characters.
        case ageTextField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 2
            
        // Do not put constraints on any other text field in this view
        // that uses this class as its delegate.
        default:
            return true
        }
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        heightTextField.delegate = self
        heightTextField.keyboardType = UIKeyboardType.ASCIICapable
        
        weightTextField.delegate = self
        weightTextField.keyboardType = UIKeyboardType.NumberPad
        
        ageTextField.delegate = self
        ageTextField.keyboardType = UIKeyboardType.NumberPad
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            /* ----- TRANSFORMERS -----*/
            // HEADER
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -130.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -154)
            self.subtitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -178)
            
            // NICKNAME TEXTFIELD
            let nicknameYValue : CGFloat = -200.0
            self.heightLabel.transform = CGAffineTransformTranslate(self.view.transform, 40.0, nicknameYValue)
            self.heightTextField.transform = CGAffineTransformTranslate(self.view.transform, 30.0, nicknameYValue)
            self.nicknameImageView.transform = CGAffineTransformTranslate(self.view.transform, -40.0, nicknameYValue)
            self.nickenameUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, nicknameYValue)
            
            // GENDER TEXTFIELD
            let genderYValue : CGFloat = -215.0
            self.kjonnLabel.transform = CGAffineTransformTranslate(self.view.transform, 40.0, genderYValue)
            self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, 30.0, genderYValue)
            self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, -40.0, genderYValue)
            self.genderUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, genderYValue)
            
            // AGE TEXTFIELD
            let ageYValue : CGFloat = -230.0
            self.alderLabel.transform = CGAffineTransformTranslate(self.view.transform, 40.0, ageYValue)
            self.ageTextField.transform = CGAffineTransformTranslate(self.view.transform, 30.0, ageYValue)
            self.ageImageview.transform = CGAffineTransformTranslate(self.view.transform, -40.0, ageYValue)
            self.ageUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, ageYValue)
            
            // WEIGHT TEXTFIELD
            let weightYValue : CGFloat = -245.0
            self.weightLabel.transform = CGAffineTransformTranslate(self.view.transform, 40.0, weightYValue)
            self.weightTextField.transform = CGAffineTransformTranslate(self.view.transform, 30.0, weightYValue)
            self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, -40.0, weightYValue)
            self.weightUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, weightYValue)
            
            // BUTTON
            self.setButtonConst(0.0, yAxisTextFields: -280.0)
            
            /* ----- FONTS -----*/
            // HEADER
            self.titleLabel.font = setAppColors.textHeadlinesFonts(20)
            self.subtitleLabel.font = setAppColors.textUnderHeadlinesFonts(11)
            
            // UNDERSCORE
            self.nickenameUnderscore.font = setAppColors.textHeadlinesFonts(12)
            self.genderUnderscore.font = setAppColors.textHeadlinesFonts(12)
            self.ageUnderscore.font = setAppColors.textHeadlinesFonts(12)
            self.weightUnderscore.font = setAppColors.textHeadlinesFonts(12)
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            /* ----- TRANSFORMERS -----*/
            // HEADER
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -120.0)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -140)
            self.subtitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -155)
            
            let titleXvalue : CGFloat = 30.0
            let textFieldXValue : CGFloat = 20.0
            let imageXValue : CGFloat = -30.0
            
            // NICKNAME TEXTFIELD
            let nicknameYValue : CGFloat = -150.0
            self.heightLabel.transform = CGAffineTransformTranslate(self.view.transform, titleXvalue, nicknameYValue)
            self.heightTextField.transform = CGAffineTransformTranslate(self.view.transform, textFieldXValue, nicknameYValue)
            self.nicknameImageView.transform = CGAffineTransformTranslate(self.view.transform, imageXValue, nicknameYValue)
            self.nickenameUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, nicknameYValue)
            
            // GENDER TEXTFIELD
            let genderYValue : CGFloat = -165.0
            self.kjonnLabel.transform = CGAffineTransformTranslate(self.view.transform, titleXvalue, genderYValue)
            self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, textFieldXValue, genderYValue)
            self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, imageXValue, genderYValue)
            self.genderUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, genderYValue)
            
            // AGE TEXTFIELD
            let ageYValue : CGFloat = -180.0
            self.alderLabel.transform = CGAffineTransformTranslate(self.view.transform, titleXvalue, ageYValue)
            self.ageTextField.transform = CGAffineTransformTranslate(self.view.transform, textFieldXValue, ageYValue)
            self.ageImageview.transform = CGAffineTransformTranslate(self.view.transform, imageXValue, ageYValue)
            self.ageUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, ageYValue)
            
            // WEIGHT TEXTFIELD
            let weightYValue : CGFloat = -195.0
            self.weightLabel.transform = CGAffineTransformTranslate(self.view.transform, titleXvalue, weightYValue)
            self.weightTextField.transform = CGAffineTransformTranslate(self.view.transform, textFieldXValue, weightYValue)
            self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, imageXValue, weightYValue)
            self.weightUnderscore.transform = CGAffineTransformTranslate(self.view.transform, 0.0, weightYValue)
            
            // BUTTON
            self.setButtonConst(0.0, yAxisTextFields: -195.0)
            
            /* ----- FONTS -----*/
            // UNDERSCORE
            self.nickenameUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.genderUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.ageUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.weightUnderscore.font = setAppColors.textHeadlinesFonts(13)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            setAllConst(0.0, yAxisTextFields: -120.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            setAllConst(0.0, yAxisTextFields: -120.0)
        }
    }
    
    func setTextFieldPlaces(xValue: CGFloat, yAxisTextFields: CGFloat){
        // TITLE UNITS
        self.heightLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.kjonnLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.alderLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.weightLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // TEXTFIELDS
        self.heightTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.ageTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.weightTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT IMAGES
        self.nicknameImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.ageImageview.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        // UNIT UNDERSCORES
        self.nickenameUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.genderUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.ageUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.weightUnderscore.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
    }
    
    func setButtonConst(xValue: CGFloat, yAxisTextFields: CGFloat){
        self.saveBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.saveBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
    }
    
    func setAllConst(xValue: CGFloat, yAxisTextFields: CGFloat){
        self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        self.subtitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yAxisTextFields)
        
        setTextFieldPlaces(xValue, yAxisTextFields: yAxisTextFields)
        setButtonConst(xValue, yAxisTextFields: yAxisTextFields)
    }
}

import Foundation

extension String {
    
    func containsCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) != nil
    }
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
    
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) == nil
    }
    
    func isNumeric() -> Bool
    {
        let scanner = NSScanner(string: self)
        scanner.locale = NSLocale.currentLocale()
        
        return scanner.scanDecimal(nil) && scanner.atEnd
    }
    
    
    
}
