//
//  UpdateUserSettingsViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 22.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UpdateUserSettingsViewController : UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var saveButton: UIView!
    
    let pickerData = ["Mann", "Kvinne"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        nicknameInput.delegate = self
        nicknameInput.keyboardType = UIKeyboardType.asciiCapable
        
        genderInput.inputView = initGenderPicker()
        
        ageInput.delegate = self
        ageInput.keyboardType = UIKeyboardType.numberPad
        
        weightInput.delegate = self
        weightInput.keyboardType = UIKeyboardType.numberPad
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.save)))
        
        initUserValues()
    }
    
    func initUserValues() {
        let userData = UserDataDao().fetchUserData()
        if userData == nil {return}
        
        nicknameInput.text = userData?.height
        
        if let gender = userData?.gender as? Int {genderInput.text = gender == 0 ? pickerData[1] : pickerData[0]}
        if userData!.age != nil {ageInput.text = String(describing: userData!.age!)}
        if userData!.weight != nil {weightInput.text! = String(describing: userData!.weight!)}
    }
    
    func initGenderPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        return pickerView
    }
    
    func save() {
        let nickName = nicknameInput.text
        let gender = genderInput.text == pickerData[0]
        let age = Int(ageInput.text!)
        let weight = Double(weightInput.text!)
        
        if (nickName == nil || nickName == "" || age == nil || weight == nil) {
            errorMessage(errorMsg: "Alle felter må fylles ut!")
            return
        }
        
        if (age! >= 120) {
            errorMessage(errorMsg: "Du valgte for ung alder")
            return
        }
        else if (age! < 18) {
            errorMessage(errorMsg: "Du er for gammel!")
            return
        }
        
        if (weight! >= 300.0) {
            errorMessage(errorMsg: "Du valgte for tung vekt")
            return
        }
        else if (weight! < 20.0) {
            errorMessage(errorMsg: "Du valgte for lett vekt")
            return
        }
        let userDataDao = UserDataDao()
        let user = userDataDao.fetchUserData()
        user?.height = nickName
        user?.gender = gender as NSNumber?
        user?.age = age as NSNumber?
        user?.weight = weight as NSNumber?
        userDataDao.save()
        AppDelegate.initUserData()
        
        savedAlertController("Lagret", message: "", delayTime: 1.3)
    }
    
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
    
    func errorMessage(_ titleMsg:String = "Beklager,", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "OK"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        
        nicknameInput.inputAccessoryView = keyboardToolbar
        genderInput.inputAccessoryView = keyboardToolbar
        ageInput.inputAccessoryView = keyboardToolbar
        weightInput.inputAccessoryView = keyboardToolbar
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderInput.text = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 0.01)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.white
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {addDoneButton()}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nicknameLength = 15
        let weightLength = 3
        let ageLength = 2
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == nicknameInput {return prospectiveText.characters.count <= nicknameLength}
        else if textField == ageInput {
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= ageLength
        }
        else if textField == weightInput {
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= weightLength
        }
        return true
    }
}
