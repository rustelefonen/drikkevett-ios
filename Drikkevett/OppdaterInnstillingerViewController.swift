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
            style: UIBarButtonItemStyle.plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        checkMaxLength(heightTextField, maxLength: 10)
        setConstraints()
    }
    
    func pickViewGenderTextField(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        chooseGenderTextField.inputView = pickerView
    }
    
    func setColorsAndFontsUpdateUserInfo(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        //ageTextField.textColor = setAppColors.textUnderHeadlinesColors()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXT FIELDS
        ageTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        ageTextField.textColor = setAppColors.textUnderHeadlinesColors()
        ageTextField.attributedPlaceholder = NSAttributedString(string:"alder", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        heightTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        heightTextField.textColor = setAppColors.textUnderHeadlinesColors()
        heightTextField.attributedPlaceholder = NSAttributedString(string:"kallenavn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        weightTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        weightTextField.textColor = setAppColors.textUnderHeadlinesColors()
        weightTextField.attributedPlaceholder = NSAttributedString(string:"vekt",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.chooseGenderTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.chooseGenderTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"kjønn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        
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
    
    func setButtonsRounded(_ turnOffOn: Bool){
        if(turnOffOn == true){
            // START END KVELDEN
            saveBtnOutlet.layer.cornerRadius = 25;
            saveBtnOutlet.layer.borderWidth = 0.5;
            saveBtnOutlet.layer.borderColor = UIColor.white.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
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
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.ageTextField.text = ""
        
        self.heightTextField.attributedPlaceholder = NSAttributedString(string:"\(updateHeight)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.heightTextField.text = ""
        
        self.weightTextField.attributedPlaceholder = NSAttributedString(string:"\(updateWeight)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.weightTextField.text = ""
        
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"\(gender)",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.chooseGenderTextField.text = ""
    }
    
    func infoIsStoredPopUp(_ titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.black
        alertContentView.layer.cornerRadius = 10
        //alertController.view.tintColor = UIColor.whiteColor()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func fetchUserData() {
        var userData = [UserData]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            
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
                self.ageTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateAge!)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.heightTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateHeight!)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.weightTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateWeight!)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"\(gender)",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    // PICKER METHODS
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 0.01)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView!) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.white
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!;
    }
    
    func Alert(_ View: UIViewController, Title: String, TitleColor: UIColor, Message: String, MessageColor: UIColor, BackgroundColor: UIColor, BorderColor: UIColor, ButtonColor: UIColor) {
        
        let TitleString = NSAttributedString(string: Title, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName : TitleColor])
        let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName : MessageColor])
        
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        
        alertController.setValue(TitleString, forKey: "attributedTitle")
        alertController.setValue(MessageString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // GJØR WHATEVS OK SHIT
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = BackgroundColor
        alertContentView.layer.cornerRadius = 10
        alertContentView.alpha = 1
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = BorderColor.cgColor
        
        
        //alertContentView.tintColor = UIColor.whiteColor()
        alertController.view.tintColor = ButtonColor
        
        View.present(alertController, animated: true) {
            // ...
        }
    }
    
    // Alert om at du har lagret ting.
    func savedAlertController(_ title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        
        // iphone 4 - forskjellige for hver enkelt textfield
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 110 // 117
        
        // iPhone 6
        let moveTextFieldSix : CGFloat = 86
        
        // iphone 6+
        let moveTextFieldSixPlus : CGFloat = 10
        
        if(textField == heightTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 65), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
        }
        if(textField == chooseGenderTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 128), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
        }
        if(textField == ageTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 128), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
        }

        if(textField == weightTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 128), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
        }
        addDoneButton()
        //else kan brukes for å håndtere andre textfields som ikke må dyttes like høyt opp!
    }
    
    //Funksjonen under sørger for å re-posisjonere tekstfeltet etter en har skrevet noe.
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        keyboardToolbar.alpha = 0.9
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //flexBarButton.tintColor = UIColor.whiteColor()
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.white
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        ageTextField.inputAccessoryView = keyboardToolbar
        heightTextField.inputAccessoryView = keyboardToolbar
        weightTextField.inputAccessoryView = keyboardToolbar
        chooseGenderTextField.inputAccessoryView = keyboardToolbar
    }
    
    func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        
        if (textField.text?.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    // MAXIMIZE TEXTFIELDS 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            
        // Allow only upper- and lower-case vowels in this field,
        // and limit its contents to a maximum of 6 characters.
        case heightTextField:
            return prospectiveText.characters.count <= 15
            
        case weightTextField:
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 3
            
        // Allow only values that evaluate to proper numeric values in this field,
        // and limit its contents to a maximum of 7 characters.
        case ageTextField:
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
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
        heightTextField.keyboardType = UIKeyboardType.asciiCapable
        
        weightTextField.delegate = self
        weightTextField.keyboardType = UIKeyboardType.numberPad
        
        ageTextField.delegate = self
        ageTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            /* ----- TRANSFORMERS -----*/
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -130.0)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -154)
            self.subtitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -178)
            
            // NICKNAME TEXTFIELD
            let nicknameYValue : CGFloat = -200.0
            self.heightLabel.transform = self.view.transform.translatedBy(x: 40.0, y: nicknameYValue)
            self.heightTextField.transform = self.view.transform.translatedBy(x: 30.0, y: nicknameYValue)
            self.nicknameImageView.transform = self.view.transform.translatedBy(x: -40.0, y: nicknameYValue)
            self.nickenameUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: nicknameYValue)
            
            // GENDER TEXTFIELD
            let genderYValue : CGFloat = -215.0
            self.kjonnLabel.transform = self.view.transform.translatedBy(x: 40.0, y: genderYValue)
            self.chooseGenderTextField.transform = self.view.transform.translatedBy(x: 30.0, y: genderYValue)
            self.genderImageView.transform = self.view.transform.translatedBy(x: -40.0, y: genderYValue)
            self.genderUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: genderYValue)
            
            // AGE TEXTFIELD
            let ageYValue : CGFloat = -230.0
            self.alderLabel.transform = self.view.transform.translatedBy(x: 40.0, y: ageYValue)
            self.ageTextField.transform = self.view.transform.translatedBy(x: 30.0, y: ageYValue)
            self.ageImageview.transform = self.view.transform.translatedBy(x: -40.0, y: ageYValue)
            self.ageUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: ageYValue)
            
            // WEIGHT TEXTFIELD
            let weightYValue : CGFloat = -245.0
            self.weightLabel.transform = self.view.transform.translatedBy(x: 40.0, y: weightYValue)
            self.weightTextField.transform = self.view.transform.translatedBy(x: 30.0, y: weightYValue)
            self.weightImageView.transform = self.view.transform.translatedBy(x: -40.0, y: weightYValue)
            self.weightUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: weightYValue)
            
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
            
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            /* ----- TRANSFORMERS -----*/
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -120.0)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -140)
            self.subtitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -155)
            
            let titleXvalue : CGFloat = 30.0
            let textFieldXValue : CGFloat = 20.0
            let imageXValue : CGFloat = -30.0
            
            // NICKNAME TEXTFIELD
            let nicknameYValue : CGFloat = -150.0
            self.heightLabel.transform = self.view.transform.translatedBy(x: titleXvalue, y: nicknameYValue)
            self.heightTextField.transform = self.view.transform.translatedBy(x: textFieldXValue, y: nicknameYValue)
            self.nicknameImageView.transform = self.view.transform.translatedBy(x: imageXValue, y: nicknameYValue)
            self.nickenameUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: nicknameYValue)
            
            // GENDER TEXTFIELD
            let genderYValue : CGFloat = -165.0
            self.kjonnLabel.transform = self.view.transform.translatedBy(x: titleXvalue, y: genderYValue)
            self.chooseGenderTextField.transform = self.view.transform.translatedBy(x: textFieldXValue, y: genderYValue)
            self.genderImageView.transform = self.view.transform.translatedBy(x: imageXValue, y: genderYValue)
            self.genderUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: genderYValue)
            
            // AGE TEXTFIELD
            let ageYValue : CGFloat = -180.0
            self.alderLabel.transform = self.view.transform.translatedBy(x: titleXvalue, y: ageYValue)
            self.ageTextField.transform = self.view.transform.translatedBy(x: textFieldXValue, y: ageYValue)
            self.ageImageview.transform = self.view.transform.translatedBy(x: imageXValue, y: ageYValue)
            self.ageUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: ageYValue)
            
            // WEIGHT TEXTFIELD
            let weightYValue : CGFloat = -195.0
            self.weightLabel.transform = self.view.transform.translatedBy(x: titleXvalue, y: weightYValue)
            self.weightTextField.transform = self.view.transform.translatedBy(x: textFieldXValue, y: weightYValue)
            self.weightImageView.transform = self.view.transform.translatedBy(x: imageXValue, y: weightYValue)
            self.weightUnderscore.transform = self.view.transform.translatedBy(x: 0.0, y: weightYValue)
            
            // BUTTON
            self.setButtonConst(0.0, yAxisTextFields: -195.0)
            
            /* ----- FONTS -----*/
            // UNDERSCORE
            self.nickenameUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.genderUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.ageUnderscore.font = setAppColors.textHeadlinesFonts(13)
            self.weightUnderscore.font = setAppColors.textHeadlinesFonts(13)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            setAllConst(0.0, yAxisTextFields: -120.0)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            setAllConst(0.0, yAxisTextFields: -120.0)
        }
    }
    
    func setTextFieldPlaces(_ xValue: CGFloat, yAxisTextFields: CGFloat){
        // TITLE UNITS
        self.heightLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.kjonnLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.alderLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.weightLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // TEXTFIELDS
        self.heightTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.chooseGenderTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.ageTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.weightTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // UNIT IMAGES
        self.nicknameImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.genderImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.ageImageview.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.weightImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // UNIT UNDERSCORES
        self.nickenameUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.genderUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.ageUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.weightUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
    }
    
    func setButtonConst(_ xValue: CGFloat, yAxisTextFields: CGFloat){
        self.saveBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.saveBtnImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
    }
    
    func setAllConst(_ xValue: CGFloat, yAxisTextFields: CGFloat){
        self.headerImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.titleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.subtitleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        setTextFieldPlaces(xValue, yAxisTextFields: yAxisTextFields)
        setButtonConst(xValue, yAxisTextFields: yAxisTextFields)
    }
}

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension String {
    
    func containsCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }
    
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    
    func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }
    
    func isNumeric() -> Bool
    {
        let scanner = Scanner(string: self)
        scanner.locale = Locale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    
    
}
