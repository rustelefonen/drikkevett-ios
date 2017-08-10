//
//  InformationUpdateViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 09.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InformationUpdateViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var maxBac: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bacImage: UIImageView!
    @IBOutlet weak var bacText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var maxBacPickerData = ["0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4"]
    let pickerData = ["Mann", "Kvinne"]
    var activeField: UITextField?
    
    let maxBacTag = 555
    let genderTag = 666
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        
        nickname.delegate = self
        nickname.keyboardType = UIKeyboardType.asciiCapable
        
        gender.inputView = initGenderPicker()
        
        weight.delegate = self
        weight.keyboardType = UIKeyboardType.numberPad
        
        setGoalPickerView()
        
        addDoneButton()
        
        initValues()
        
        updateBacText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeField?.delegate = self
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func initValues() {
        guard let userData = AppDelegate.getUserData() else {return}
        
        nickname.text = userData.height!
        maxBac.text = String(describing: userData.goalPromille!)
        gender.text = pickerData[Bool(userData.gender!) ? 0 : 1]
        weight.text = String(describing: userData.weight!)
    }
    
    func setGoalPickerView(){       //DENNE ER RAR? SETTES ETTER AT INPUTVIEW ER SATT
        let pickGoalProm = UIPickerView()
        maxBac.inputView = pickGoalProm
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        let setAppColors = AppColors()
        pickGoalProm.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGray
        
        pickGoalProm.tag = maxBacTag
    }
    
    func initGenderPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        pickerView.tag = genderTag
        return pickerView
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
        
        nickname.inputAccessoryView = keyboardToolbar
        gender.inputAccessoryView = keyboardToolbar
        weight.inputAccessoryView = keyboardToolbar
        maxBac.inputAccessoryView = keyboardToolbar
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if hasNoUnsavedChanges() {navigateToPreviousViewController()}
        else {
            let refreshAlert = UIAlertController(title: "Du har ulagrede endringer", message: "Er du sikker på at du vil gå tilbake uten å lagre?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ja", style: .destructive, handler: { (action: UIAlertAction!) in
                self.navigateToPreviousViewController()
            }))
            refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func hasNoUnsavedChanges() -> Bool {
        guard let nicknameText = nickname.text else {return false}
        guard let maxBacNumber = Double(maxBac.text!) else {return false}
        let genderBool = gender.text == pickerData[0]
        guard let weightNumber = Double(weight.text!) else {return false}
        
        guard let userData = AppDelegate.getUserData() else {return false}
        
        return nicknameText == userData.height! &&
            maxBacNumber == Double(userData.goalPromille!) &&
            genderBool == Bool(userData.gender!) &&
            weightNumber == Double(userData.weight!)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let nicknameText = nickname.text else {return}
        guard let maxBacNumber = Double(maxBac.text!) else {
            displayInvalidInput(type: "promille", message: "Promillen må være mellom 0.1 og 1.4.")
            return
        }
        if gender.text == nil {
            displayInvalidInput(type: "kjønn", message: "Kjønn må være enten mannn eller kvinne.")
            return
        }
        
        let genderBool = gender.text == pickerData[0]
        guard let weightNumber = Double(weight.text!) else {return}
        
        if nicknameText.characters.count <= 0 || nicknameText.characters.count > 15 {
            displayInvalidInput(type: "kallenavn", message: "Kallenavnet må være mellom ett og 15 tegn.")
            return
        }
        if maxBacNumber < 0.1 || maxBacNumber > 1.4 {
            displayInvalidInput(type: "promille", message: "Promillen må være mellom 0.1 og 1.4.")
            return
        }
        if weightNumber < 20.0 || weightNumber >= 300.0 {
            displayInvalidInput(type: "vekt", message: "Vekten må være mellom 20 og 299.9kg.")
            return
        }
        
        let userDataDao = UserDataDao()
        guard let userData = userDataDao.fetchUserData() else {return}
        
        userData.height = nicknameText
        userData.goalPromille = maxBacNumber as NSNumber
        userData.gender = genderBool as NSNumber
        userData.weight = weightNumber as NSNumber
        
        userDataDao.save()
        AppDelegate.initUserData()
        navigateToPreviousViewController()
    }
    
    func displayInvalidInput(type:String, message:String) {
        let refreshAlert = UIAlertController(title: "Ugyldig verdi for " + type, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func navigateToPreviousViewController() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == genderTag {gender.text = pickerData[row]}
        else if pickerView.tag == maxBacTag {maxBac.text = maxBacPickerData[row]}
        updateBacText()
    }
    
    func updateBacText() {
        guard let bacChosen = Double(maxBac.text!) else {return}
        
        bacText.textColor = getQuoteTextColorBy(bac: bacChosen)
        bacText.text = getQuoteRegisterTextBy(bac: bacChosen)
        bacImage.image = getUIImageRegisterBy(bac: bacChosen)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 0.01)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == genderTag ? pickerData.count : maxBacPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.white
        }
        
        pickerLabel?.text = pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
        
        return pickerLabel!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nicknameLength = 15
        let weightLength = 3
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == nickname {return prospectiveText.characters.count <= nicknameLength}
        else if textField == weight {
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= weightLength
        }
        return true
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        addDoneButton()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}
