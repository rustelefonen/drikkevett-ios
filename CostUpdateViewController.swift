//
//  CostUpdateViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 08.08.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class CostUpdateViewController:UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var beerPrice: UITextField!
    @IBOutlet weak var winePrice: UITextField!
    @IBOutlet weak var drinkPrice: UITextField!
    @IBOutlet weak var shotPrice: UITextField!
    @IBOutlet weak var standardButton: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    var activeField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        
        standardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(useDefaultCosts)))
        
        beerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editBeer)))
        wineImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editWine)))
        drinkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editDrink)))
        shotImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editShot)))
        
        beerPrice.delegate = self
        beerPrice.keyboardType = UIKeyboardType.numberPad
        winePrice.delegate = self
        winePrice.keyboardType = UIKeyboardType.numberPad
        drinkPrice.delegate = self
        drinkPrice.keyboardType = UIKeyboardType.numberPad
        shotPrice.delegate = self
        shotPrice.keyboardType = UIKeyboardType.numberPad
        
        initPrices()
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
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if hasNoUnsavedChanges() {navigateToPreviousViewController()}
        else {displayWarning()}
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let beerCost = Int(beerPrice.text!) else {
            displayInvalidInput(unitType: 0)
            return
        }
        guard let wineCost = Int(winePrice.text!) else {
            displayInvalidInput(unitType: 1)
            return
        }
        guard let drinkCost = Int(drinkPrice.text!) else {
            displayInvalidInput(unitType: 2)
            return
        }
        guard let shotCost = Int(shotPrice.text!) else {
            displayInvalidInput(unitType: 3)
            return
        }
        if !hasValidCost(price: beerCost, unitType: 0) {return}
        if !hasValidCost(price: wineCost, unitType: 1) {return}
        if !hasValidCost(price: drinkCost, unitType: 2) {return}
        if !hasValidCost(price: shotCost, unitType: 3) {return}
        
        let userDataDao = UserDataDao()
        let userData = userDataDao.fetchUserData()
        userData?.costsBeer = beerCost as NSNumber
        userData?.costsWine = wineCost as NSNumber
        userData?.costsDrink = drinkCost as NSNumber
        userData?.costsShot = shotCost as NSNumber
        
        userDataDao.save()
        AppDelegate.initUserData()
        navigateToPreviousViewController()
    }
    
    func editBeer() {
        performSegue(withIdentifier: UnitViewController.updateSegueId, sender: 0)
    }
    func editWine() {
        performSegue(withIdentifier: UnitViewController.updateSegueId, sender: 1)
    }
    func editDrink() {
        performSegue(withIdentifier: UnitViewController.updateSegueId, sender: 2)
    }
    func editShot() {
        performSegue(withIdentifier: UnitViewController.updateSegueId, sender: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UnitViewController.updateSegueId {
            if segue.destination is UnitViewController {
                let destination = segue.destination as! UnitViewController
                destination.unitType = sender as? Int
                
                let backItem = UIBarButtonItem()
                backItem.title = "Kostnader"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    
    func hasValidCost(price:Int, unitType:Int) ->Bool {
        if price > 0 && price < 1000 {return true}
        
        let refreshAlert = UIAlertController(title: "Ugyldig pris på " + ResourceList.units[unitType], message: "Prisen må være mellom 1 og 999,-", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
        return false
    }
    
    func navigateToPreviousViewController() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func hasNoUnsavedChanges() -> Bool{
        guard let beerCost = Int(beerPrice.text!) else {return true}
        guard let wineCost = Int(winePrice.text!) else {return true}
        guard let drinkCost = Int(drinkPrice.text!) else {return true}
        guard let shotCost = Int(shotPrice.text!) else {return true}
        
        guard let userData = AppDelegate.getUserData() else {return false}
        
        return beerCost == Int(userData.costsBeer!) && wineCost == Int(userData.costsWine!) && drinkCost == Int(userData.costsDrink!) && shotCost == Int(userData.costsShot!)
    }
    
    func displayWarning() {
        let refreshAlert = UIAlertController(title: "Du har ulagrede endringer", message: "Er du sikker på at du vil gå tilbake uten å lagre?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ja", style: .destructive, handler: { (action: UIAlertAction!) in
            self.navigateToPreviousViewController()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func displayInvalidInput(unitType:Int) {
        let refreshAlert = UIAlertController(title: "Ugyldig verdi for " + ResourceList.units[unitType], message: "Feltet må være et tall og kan ikke være tomt.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func initPrices() {
        guard let userData = AppDelegate.getUserData() else {return}
        
        if let beerCost = userData.costsBeer {beerPrice.text = String(describing: beerCost)}
        if let wineCost = userData.costsWine {winePrice.text = String(describing: wineCost)}
        if let drinkCost = userData.costsDrink {drinkPrice.text = String(describing: drinkCost)}
        if let shotCost = userData.costsShot {shotPrice.text = String(describing: shotCost)}
    }
    
    func useDefaultCosts() {
        beerPrice.text = "60"
        winePrice.text = "70"
        drinkPrice.text = "100"
        shotPrice.text = "110"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 3
        
        if string.characters.count == 0 {return true}
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
        return prospectiveText.isNumeric() &&
            prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
            prospectiveText.characters.count <= maxLength
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
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        keyboardToolbar.alpha = 0.9
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.white
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        beerPrice.inputAccessoryView = keyboardToolbar
        winePrice.inputAccessoryView = keyboardToolbar
        drinkPrice.inputAccessoryView = keyboardToolbar
        shotPrice.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        addDoneButton()
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
        
    }
}
