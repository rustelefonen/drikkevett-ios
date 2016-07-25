//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    ////////////////////////////////////////////////////////////////////////
    //                        ATTRIBUTTER (0001)                          //
    ////////////////////////////////////////////////////////////////////////
    
    //-----------------------------   OUTLETS    -------------------------\\
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var ageTitleLabel: UILabel!
    @IBOutlet weak var heightTitleLabel: UILabel!
    @IBOutlet weak var weightTitleLabel: UILabel!
    
    // LINES
    @IBOutlet weak var nicknameUnderlinedLabel: UILabel!
    @IBOutlet weak var genderUnderLinedLabel: UILabel!
    @IBOutlet weak var weightUnderLinedLabel: UILabel!
    @IBOutlet weak var ageUnderLinedLabel: UILabel!
    
    // IMAGES
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nickNameImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var weightImageView: UIImageView!
    
    // BUTTONS
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //@IBOutlet weak var pickGenderView: UIPickerView!
    var pickGenderView = UIPickerView()
    @IBOutlet weak var chooseGenderTextField: UITextField!
    
    // SCROLL VIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    // sett verdier i picker view
    var pickerData = ["Velg Kjønn", "Mann", "Kvinne"]
    var genderString = "Velg Kjønn"
    //---------------------  GLOBALE VARIABLER    -------------------------\\
    
    // Database/Core Data Kommunikasjon
    let moc = DataController().managedObjectContext
    
    // set Colors
    var setAppColors = AppColors()
    
    var saveAge = String()
    var saveHeight = String()
    var saveWeight = String()
    var saveGender = "Mann"
    
    // DOUBLE
    var weight : Double! = 0
    var age : Int! = 0
    var height : String! = ""
    var gender : Bool = true
    
    // PARSE VALUES - 
    var beerCostsInfo : Int! = 0
    var wineCostsInfo : Int! = 0
    var drinkCostsInfo : Int! = 0
    var shotCostsInfo : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsEnterPersonaliaView()
        pickViewGenderTextField()
        initializeTextFields()
        setConstraints()
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            print("iphone 4")
            let lineSize : CGFloat = 14
            let titleTextFieldSize : CGFloat = 14
            
            // HEADER IMAGE
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -25.0)
            
            // HEADER TITLE AND SUBTITLE
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -40.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -55.0)
            self.titleLabel.font = setAppColors.textHeadlinesFonts(25)
            self.subTitleLabel.font = setAppColors.textHeadlinesFonts(14)
            
            // LINES
            self.nicknameUnderlinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.genderUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.weightUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.ageUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.nicknameUnderlinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.genderUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.weightUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.ageUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            
            // TITLES TEXT FIELDS
            self.heightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // NICKNAME
            self.ageTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // ALDER
            self.genderTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // KJØNN
            self.weightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // VEKT
            self.heightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.ageTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.genderTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.weightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            
            // TEXT FIELDS
            self.heightField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // NICKNAME
            self.ageField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // ALDER
            self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // KJØNN
            self.weightField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // VEKT
            
            // TEXT FIELD IMAGES
            self.nickNameImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // NICKNAME
            self.ageImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // ALDER
            self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // KJØNN
            self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // VEKT
            
            // NEXT IMAGE AND BUTTON
            self.nextImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -90.0)
            self.nextButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -90.0)
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            print("iPhone 5")
            let lineSize : CGFloat = 14
            let titleTextFieldSize : CGFloat = 14
            
            // HEADER IMAGE
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -25.0)
            
            // HEADER TITLE AND SUBTITLE
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -40.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -55.0)
            self.titleLabel.font = setAppColors.textHeadlinesFonts(25)
            self.subTitleLabel.font = setAppColors.textHeadlinesFonts(14)
            
            // LINES
            self.nicknameUnderlinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.genderUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.weightUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.ageUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.nicknameUnderlinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.genderUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.weightUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.ageUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            
            // TITLES TEXT FIELDS
            self.heightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // NICKNAME
            self.ageTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // ALDER
            self.genderTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // KJØNN
            self.weightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // VEKT
            self.heightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.ageTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.genderTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.weightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            
            // TEXT FIELDS
            self.heightField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // NICKNAME
            self.ageField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // ALDER
            self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // KJØNN
            self.weightField.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0) // VEKT
            
            // TEXT FIELD IMAGES
            self.nickNameImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // NICKNAME
            self.ageImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // ALDER
            self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // KJØNN
            self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0) // VEKT
            
            // NEXT IMAGE AND BUTTON
            self.nextImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -40.0)
            self.nextButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -40.0)
            
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            print("iPhone 6")
            let lineSize : CGFloat = 16
            let titleTextFieldSize : CGFloat = 15
            
            // HEADER IMAGE
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -70.0)
            
            // HEADER TITLE AND SUBTITLE
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -75.0)
            self.titleLabel.font = setAppColors.textHeadlinesFonts(30)
            self.subTitleLabel.font = setAppColors.textHeadlinesFonts(17)
            
            // LINES
            self.nicknameUnderlinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.genderUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.weightUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.ageUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.nicknameUnderlinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.genderUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.weightUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            self.ageUnderLinedLabel.font = setAppColors.textHeadlinesFonts(lineSize)
            
            // TITLES TEXT FIELDS
            self.heightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // NICKNAME
            self.ageTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // ALDER
            self.genderTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // KJØNN
            self.weightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // VEKT
            self.heightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.ageTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.genderTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            self.weightTitleLabel.font = setAppColors.textHeadlinesFonts(titleTextFieldSize)
            
            // TEXT FIELDS
            self.heightField.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // NICKNAME
            self.ageField.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // ALDER
            self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // KJØNN
            self.weightField.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0) // VEKT
            
            // TEXT FIELD IMAGES
            self.nickNameImageView.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0) // NICKNAME
            self.ageImageView.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0) // ALDER
            self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0) // KJØNN
            self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0) // VEKT
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            print("iPhone 6+")
            // HEADER IMAGE
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -70.0)
            
            // HEADER TITLE AND SUBTITLE
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60.0)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -75.0)
            
            moveTextFieldConstraints(0.0, yValue: -60.0)
        }
    }
    
    func moveTextFieldConstraints(xValue: CGFloat, yValue: CGFloat){
        // LINES
        self.nicknameUnderlinedLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.genderUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.weightUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.ageUnderLinedLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)

        
        // TITLES TEXT FIELDS
        self.heightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // NICKNAME
        self.ageTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // ALDER
        self.genderTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // KJØNN
        self.weightTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // VEKT

        // TEXT FIELDS
        self.heightField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // NICKNAME
        self.ageField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // ALDER
        self.chooseGenderTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // KJØNN
        self.weightField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // VEKT
        
        // TEXT FIELD IMAGES
        self.nickNameImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // NICKNAME
        self.ageImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // ALDER
        self.genderImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // KJØNN
        self.weightImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue) // VEKT
    }
    
    func setColorsAndFontsEnterPersonaliaView(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TITLE AND SUBTITLE
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(34)
        subTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(18)
        
        // LABELS
        ageTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        ageTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        genderTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        genderTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        weightTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        weightTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        heightTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        heightTitleLabel.font = setAppColors.textUnderHeadlinesFonts(15)
        
        // TEXTFIELDS
        ageField.textColor = setAppColors.textUnderHeadlinesColors()
        ageField.font = setAppColors.textUnderHeadlinesFonts(15)
        ageField.attributedPlaceholder = NSAttributedString(string:"oppgi alder",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        heightField.textColor = setAppColors.textUnderHeadlinesColors()
        heightField.font = setAppColors.textUnderHeadlinesFonts(15)
        heightField.attributedPlaceholder = NSAttributedString(string:"oppgi kallenavn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        weightField.textColor = setAppColors.textUnderHeadlinesColors()
        weightField.font = setAppColors.textUnderHeadlinesFonts(15)
        weightField.attributedPlaceholder = NSAttributedString(string:"oppgi vekt",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.chooseGenderTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.chooseGenderTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"oppgi kjønn",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }
    
    func pickViewGenderTextField(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGrayColor()
        chooseGenderTextField.inputView = pickerView
        pickGenderView.dataSource = self
        pickGenderView.delegate = self
        pickGenderView.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        //Parsing String values from UITextField to Integers:
        weight = Double(weightField.text!)
        age = Int(ageField.text!)
        height = String(heightField.text!)
        
        var errorArray = [String]()
        //Handling wrong inputs in UITextFields:
        if(weight == nil || height == nil || age == nil){
            weight = 0; age = 0; height = "";
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        }
        if(age >= 120 || age < 18){
            if(age < 18){
                //errorMessage(errorMsg: "Du er for ung!")
                errorArray.append("alder")
            }
            if(age >= 120){
                //errorMessage(errorMsg: "Du er for gammel!")
            }
        }
        if(weight >= 300 || weight <= 20){
            var descriptionWeight = ""
            if(weight >= 300){
                descriptionWeight = "tung"
                errorArray.append(descriptionWeight)
            }
            if(weight <= 20){
                descriptionWeight = "lett"
                errorArray.append(descriptionWeight)
            }
            //errorMessage(errorMsg: "Vi tillater ikke så \(descriptionWeight) vekt")
        }
        if(genderString == "Velg Kjønn"){
            //errorMessage(errorMsg: "Vennligst velg kjønn")
            errorArray.append("kjønn")
        }
        if(errorArray.count > 0){
            print("Arrayet er ikke tomt! ")
            var stringErrors = ""
            for elements in errorArray {
                if(elements == "lett" || elements == "tung"){
                    stringErrors += "du valgte for \(elements) vekt"
                }
                if(elements == "alder"){
                    stringErrors += "du valgte for ung \(elements)"
                }
                if(elements == "kjønn"){
                    stringErrors += "vennligst velg \(elements)"
                }
                stringErrors += "\n"
            }
            //print("\(stringErrors)")
            errorMessage(errorMsg: "\(stringErrors)")
            errorArray.removeAll()
        }
        //Printing input values in console:
        else if let weightString:String! = String(weight!), heightString:String = String(height), ageString:String = String(age){
            saveAge = ageString
            saveHeight = heightString
            saveWeight = weightString
            let notSetCost = 0
            let notSetGoalPromille = 0.0
            let notSetGoalDate : NSDate = NSDate()
            if(genderString == "Mann"){
                gender = true
            }
            if(genderString == "Kvinne"){
                gender = false
            }
            confirmMessage("Brukerinfo", errorMsg: heightString + "\n" + genderString + "\n" + ageString + " år\n" + weightString + " kg", cancelMsg:"Avbryt", confirmMsg: "Bekreft")
            
            seedUserDataValues(gender, age: age, height: height, weight: weight, beerCost: notSetCost, wineCost: notSetCost, drinkCost: notSetCost, shotCost: notSetCost, goalPromille: notSetGoalPromille, goalDate: notSetGoalDate)
        }
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(titleMsg:String = "Beklager,", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "OK"){
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
            self.performSegueWithIdentifier("settingsSegue", sender: self)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func seedUserDataValues(gender: Bool, age: Int, height: String, weight: Double, beerCost: Int, wineCost: Int, drinkCost: Int, shotCost: Int, goalPromille: Double, goalDate: NSDate) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: moc) as! UserData
        
        entity.setValue(gender, forKey: "gender")
        entity.setValue(age, forKey: "age")
        entity.setValue(height, forKey: "height")
        entity.setValue(weight, forKey: "weight")
        entity.setValue(beerCost, forKey: "costsBeer")
        entity.setValue(wineCost, forKey: "costsWine")
        entity.setValue(drinkCost, forKey: "costsDrink")
        entity.setValue(shotCost, forKey: "costsShot")
        entity.setValue(goalPromille, forKey: "goalPromille")
        entity.setValue(goalDate, forKey: "goalDate")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
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
            genderString = "Mann"
            self.chooseGenderTextField.text = "Mann"
        }
        if(pickerData[row] == "Kvinne"){
            genderString = "Kvinne"
            self.chooseGenderTextField.text = "Kvinne"
        }
        if(pickerData[row] == "Velg Kjønn"){
            genderString = "Velg Kjønn"
            self.chooseGenderTextField.text = "Velg Kjønn"
        }
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
    
    // SCROLL VIEW
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        
        // iphone 4 - forskjellige for hver enkelt textfield
        
        // iPhone 5
        let moveTextFieldIphoneFive : CGFloat = 117
        
        // iPhone 6
        let moveTextField : CGFloat = 130
        
        // iphone 6+
        let moveTextFieldIphoneSixPlus : CGFloat = 40
        
        
        if(textField == ageField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 128), animated: true)
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
        if(textField == heightField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
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
        if(textField == weightField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 155), animated: true)
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
        if(textField == chooseGenderTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 30), animated: true)
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
        ageField.inputAccessoryView = keyboardToolbar
        heightField.inputAccessoryView = keyboardToolbar
        weightField.inputAccessoryView = keyboardToolbar
        chooseGenderTextField.inputAccessoryView = keyboardToolbar
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
        case heightField:
            return prospectiveText.characters.count <= 15
            
        case weightField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= 3
            
            // Allow only values that evaluate to proper numeric values in this field,
        // and limit its contents to a maximum of 7 characters.
        case ageField:
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
        heightField.delegate = self
        heightField.keyboardType = UIKeyboardType.ASCIICapable
        
        weightField.delegate = self
        weightField.keyboardType = UIKeyboardType.NumberPad
        
        ageField.delegate = self
        ageField.keyboardType = UIKeyboardType.NumberPad
    }
}