//
//  UpdateMaxBacViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 23.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UpdateMaxBacViewController:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let pickerData = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0"]
    
    @IBOutlet weak var bacImage: UIImageView!
    @IBOutlet weak var bacText: UITextView!
    @IBOutlet weak var maxBacInput: UITextField!
    @IBOutlet weak var saveButton: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField:UITextField?
    var userData:UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        userData = AppDelegate.getUserData()
        
        activeField?.delegate = self
        registerForKeyboardNotifications()
        
        initMaxBacPicker()
        
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.save)))
        initUserValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func initUserValues() {
        if userData != nil && userData!.goalPromille != nil {
            maxBacInput.text = String(describing: userData!.goalPromille!)
        }
    }
    
    func save() {
        let maxBac = Double(maxBacInput.text!)
        
        if maxBac == nil {errorMessage(errorMsg: "Alle felter må fylles ut!")}
        
        if maxBac! <= 0.0 || maxBac! > 2.0 {errorMessage(errorMsg: "Makspromillen må være mellom 0.1 og 2.0!")}
        
        let userDataDao = UserDataDao()
        let userData = userDataDao.fetchUserData()
        userData?.goalPromille = maxBac! as NSNumber
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
    
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initMaxBacPicker() {
        let pickGoalProm = UIPickerView()
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        pickGoalProm.setValue(AppColors().datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGray
        maxBacInput.inputView = pickGoalProm
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let happyImage = UIImage(named: "Happy-100")
        let sadImage = UIImage(named: "Sad-100")
        
        maxBacInput.text = "\(pickerData[row])"
        let goalPromille = Double(pickerData[row])!
        if(goalPromille == 0.0){
            bacText.textColor = UIColor.white
            bacText.text = ResourceList.introBacInfos[0]
            bacImage.image = happyImage
        }
        else if(goalPromille > 0.0 && goalPromille <= 0.3){
            bacText.textColor = UIColor.white
            bacText.text = ResourceList.introBacInfos[1]
            bacImage.image = happyImage
        }
        else if(goalPromille > 0.3 && goalPromille <= 0.6){
            bacText.text = ResourceList.introBacInfos[2]
            bacImage.image = happyImage
        }
        else if(goalPromille > 0.6 && goalPromille <= 0.9){
            bacText.text = ResourceList.introBacInfos[3]
            bacImage.image = happyImage
        }
        else if(goalPromille > 0.9 && goalPromille <= 1.2){
            bacText.text = ResourceList.introBacInfos[4]
            bacImage.image = sadImage
        }
        else if(goalPromille > 1.2 && goalPromille <= 1.5){
            bacText.text = ResourceList.introBacInfos[5]
            bacImage.image = sadImage
        }
        else if(goalPromille > 1.5 && goalPromille <= 1.7){
            bacText.text = ResourceList.introBacInfos[6]
            bacImage.image = sadImage
        }
        else if(goalPromille > 1.7){
            bacText.text = ResourceList.introBacInfos[7]
            bacImage.image = UIImage(named: "Vomited-100")
        }
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
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            let setAppColors = AppColors()
            pickerLabel?.textColor = setAppColors.textUnderHeadlinesColors()
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        keyboardToolbar.alpha = 0.9
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.white
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        maxBacInput.inputAccessoryView = keyboardToolbar
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
    
    
    
    
}
