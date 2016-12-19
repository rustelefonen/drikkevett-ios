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
            style: UIBarButtonItemStyle.plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    func setColorsAndFontsUpdateCosts(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXT FIELDS
        beerTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        beerTextField.textColor = setAppColors.textUnderHeadlinesColors()
        beerTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på øl",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        wineTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        wineTextField.textColor = setAppColors.textUnderHeadlinesColors()
        wineTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på vin",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        drinkTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        drinkTextField.textColor = setAppColors.textUnderHeadlinesColors()
        drinkTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på drink",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        shotTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        shotTextField.textColor = setAppColors.textUnderHeadlinesColors()
        shotTextField.attributedPlaceholder = NSAttributedString(string:"ca. pris på shot",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
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
        self.standardPrizesBtnOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        //self.standardPrizesBtnOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func updateButton(_ sender: AnyObject) {
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
        else if let beerString:String? = String(updateBeerCost!), let wineString:String = String(updateWineCost), let drinkString:String = String(updateDrinkCost), let shotString:String = String(updateShotCost){
            
            brainCoreData.updateUserDataCosts(updateBeerCost, updateWineCost: updateWineCost, updateDrinkCost: updateDrinkCost, updateShotCost: updateShotCost)
            fetchUserData()
            
            savedAlertController("Lagret", message: "", delayTime: 1.3)
        }
    }
    
    // SETT STANDARD VALUES:
    @IBAction func setStandardPrizesBtn(_ sender: AnyObject) {
        self.beerTextField.text = "60"
        self.wineTextField.text = "70"
        self.drinkTextField.text = "100"
        self.shotTextField.text = "110"
    }
    
    //Method for pop-up messages when handling wrong inputs:
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
                tempUpdateBeerCost = item.costsBeer! as Int
                self.beerTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateBeerCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.beerTextField.text = ""
                tempUpdateWineCost = item.costsWine! as Int
                self.wineTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateWineCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.wineTextField.text = ""
                tempUpdateDrinkCost = item.costsDrink! as Int
                self.drinkTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateDrinkCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.drinkTextField.text = ""
                tempUpdateShotCost = item.costsShot! as Int
                self.shotTextField.attributedPlaceholder = NSAttributedString(string:"\(tempUpdateShotCost),-",
                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                self.shotTextField.text = ""
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
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
        // iphone 4
        let moveTextFieldIphoneFour : CGFloat = 136
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 75 // 120
        
        // iPhone 6
        let moveTextField : CGFloat = 38
        
        // iphone 6+
        let moveTextFieldIphoneSixPlus : CGFloat = 20
        
        if(textField == beerTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == wineTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == drinkTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        if(textField == shotTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFour), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldIphoneSixPlus), animated: true)
            }
        }
        addDoneButton()
        //else kan brukes for å håndtere andre textfields som ikke må dyttes like høyt opp!
    }
    //Funksjonen under sørger for at tastaturet forsvinner når en trykker return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        beerTextField.inputAccessoryView = keyboardToolbar
        wineTextField.inputAccessoryView = keyboardToolbar
        drinkTextField.inputAccessoryView = keyboardToolbar
        shotTextField.inputAccessoryView = keyboardToolbar
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
        case textField:
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 5
        default:
            return true
        }
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -130.0)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -150.0)
            self.headerSubtitle.transform = self.view.transform.translatedBy(x: 0.0, y: -170.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -200.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = self.view.transform.translatedBy(x: -50.0, y: -250.0)
            self.saveImageView.transform = self.view.transform.translatedBy(x: -50.0, y: -250.0)
            self.standardImageView.transform = self.view.transform.translatedBy(x: -20.0, y: -250.0)
            self.standardPrizesBtnOutlet.transform = self.view.transform.translatedBy(x: -20.0, y: -250.0)
            
            setTextSizes(20, subtitle: 11)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -130.0)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -140.0)
            self.headerSubtitle.transform = self.view.transform.translatedBy(x: 0.0, y: -155.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -170.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = self.view.transform.translatedBy(x: -50.0, y: -175.0)
            self.saveImageView.transform = self.view.transform.translatedBy(x: -50.0, y: -175.0)
            self.standardImageView.transform = self.view.transform.translatedBy(x: -20.0, y: -175.0)
            self.standardPrizesBtnOutlet.transform = self.view.transform.translatedBy(x: -20.0, y: -175.0)
            
            //setTextSizes(10, title: 27, subtitle: 17)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            setAllConstValues(0.0, yValue: -100.0)
            
            self.standardImageView.transform = self.view.transform.translatedBy(x: -20.0, y: -100.0)
            self.standardPrizesBtnOutlet.transform = self.view.transform.translatedBy(x: -20.0, y: -100.0)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -60.0)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -60.0)
            self.headerSubtitle.transform = self.view.transform.translatedBy(x: 0.0, y: -60.0)
            
            setTextFieldPlaces(0.0, yAxisTextFields: -60.0)
            
            // STANDARD AND NEXT ( IMG AND BTNS )
            self.saveCostsBtnOutlet.transform = self.view.transform.translatedBy(x: 20.0, y: -60.0)
            self.saveImageView.transform = self.view.transform.translatedBy(x: 20.0, y: -60.0)
            self.standardImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -60.0)
            self.standardPrizesBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -60.0)
        }
    }
    
    func setAllConstValues(_ xValue: CGFloat, yValue: CGFloat){
        
        // TITLE, TITLEIMG, SUBTITLE AND TEXTVIEW
        self.titleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.headerSubtitle.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.headerImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        
        setTextFieldPlaces(xValue, yAxisTextFields: yValue)
        
        // STANDARD AND NEXT ( IMG AND BTNS )
        self.saveCostsBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.saveImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.standardImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.standardPrizesBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
    }
    
    func setTextFieldPlaces(_ xValue: CGFloat, yAxisTextFields: CGFloat){
        // TITLE UNITS
        self.beerLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.wineLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.drinkLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.shotLabel.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // TEXTFIELDS
        self.beerTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.wineTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.drinkTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.shotTextField.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // UNIT IMAGES
        self.beerImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.wineImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.drinkImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.shotImageView.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        
        // UNIT UNDERSCORES
        self.beerUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.wineUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.drinkUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
        self.shotUnderscore.transform = self.view.transform.translatedBy(x: xValue, y: yAxisTextFields)
    }
    
    func setTextSizes(_ title: CGFloat, subtitle: CGFloat){
        // TITLE AND SUBTITLE
        self.titleLabel.font = setAppColors.textHeadlinesFonts(title)
        self.headerSubtitle.font = setAppColors.textUnderHeadlinesFonts(subtitle)
    }
}
