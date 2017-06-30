//
//  UpdateCostsViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 22.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class UpdateCostsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var beerInput: UITextField!
    @IBOutlet weak var wineInput: UITextField!
    @IBOutlet weak var drinkInput: UITextField!
    @IBOutlet weak var shotInput: UITextField!
    @IBOutlet weak var standardButton: UIView!
    @IBOutlet weak var saveButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        
        beerInput.delegate = self
        beerInput.keyboardType = UIKeyboardType.numberPad
        wineInput.delegate = self
        wineInput.keyboardType = UIKeyboardType.numberPad
        drinkInput.delegate = self
        drinkInput.keyboardType = UIKeyboardType.numberPad
        shotInput.delegate = self
        shotInput.keyboardType = UIKeyboardType.numberPad
        
        standardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.insertStandardValues)))
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.save)))
        initUserValues()
    }
    
    func initUserValues() {
        let userData = UserDataDao().fetchUserData()
        if userData == nil {return}
        
        if userData!.costsBeer != nil {beerInput.text = String(describing: userData!.costsBeer!)}
        if userData!.costsWine != nil {wineInput.text = String(describing: userData!.costsWine!)}
        if userData!.costsDrink != nil {drinkInput.text = String(describing: userData!.costsDrink!)}
        if userData!.costsShot != nil {shotInput.text = String(describing: userData!.costsShot!)}
    }
    
    func insertStandardValues() {
        beerInput.text = "60"
        wineInput.text = "70"
        drinkInput.text = "100"
        shotInput.text = "110"
    }
    
    func save() {
        let beerCostsInfo = Int(beerInput.text!)
        let wineCostsInfo = Int(wineInput.text!)
        let drinkCostsInfo = Int(drinkInput.text!)
        let shotCostsInfo = Int(shotInput.text!)
        
        if(beerCostsInfo == nil || wineCostsInfo == nil || drinkCostsInfo == nil || shotCostsInfo == nil){
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        }
        if invalidPrice(cost: beerCostsInfo!) {errorMessage(errorMsg: "Så mye betaler du ikke for øl?")}
        if invalidPrice(cost: wineCostsInfo!) {errorMessage(errorMsg: "Så mye betaler du ikke for vin?")}
        if invalidPrice(cost: drinkCostsInfo!) {errorMessage(errorMsg: "Så mye betaler du ikke for drink?")}
        if invalidPrice(cost: shotCostsInfo!) {errorMessage(errorMsg: "Så mye betaler du ikke for shot?")}
        
        let userDataDao = UserDataDao()
        let userData = userDataDao.fetchUserData()
        if userData == nil {return}
        
        userData?.costsBeer = beerCostsInfo! as NSNumber
        userData?.costsWine = wineCostsInfo! as NSNumber
        userData?.costsDrink = drinkCostsInfo! as NSNumber
        userData?.costsShot = shotCostsInfo! as NSNumber
        
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
    
    func invalidPrice(cost:Int) -> Bool{
        return cost >= 10000 || cost <= 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButton()
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
        beerInput.inputAccessoryView = keyboardToolbar
        wineInput.inputAccessoryView = keyboardToolbar
        drinkInput.inputAccessoryView = keyboardToolbar
        shotInput.inputAccessoryView = keyboardToolbar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {return true}
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            case textField:
                let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
                return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 5
            default:
                return true
        }
    }
}
