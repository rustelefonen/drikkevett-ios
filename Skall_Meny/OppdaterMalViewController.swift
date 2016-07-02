//  OppdaterMalViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 01.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import CoreData
import UIKit

class OppdaterMalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {

    // GET BRAIN OF APP
    var brain = SkallMenyBrain()
    
    // Kommunikasjon med database/CoreData
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // Set Colors
    let setAppColors = AppColors()
    
    // HEADER
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // IMAGE HIGH PROM
    @IBOutlet weak var imageViewStateOfGoal: UIImageView!
    
    // SCROLLVIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    // FORKLARING
    @IBOutlet weak var textViewGoal: UITextView!
    
    // HEADER TITLE AND SUBTITLE
    @IBOutlet weak var titleLabel: UILabel!
    
    // TEXTLABEL IMAGE VIEWS
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var goalDateImageView: UIImageView!
    
    // TEXTFIELD TITLES
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    
    // TEXTFIELD UNDERSCORES
    @IBOutlet weak var underScoreGoal: UILabel!
    @IBOutlet weak var underscoreDate: UILabel!
    
    // BUTTON
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var letsGoImageView: UIImageView!
    
    var getGoalDate = NSDate()
    var goalPromille : Double! = 0.0
    
    // DATEPICKER OUTLET
    @IBOutlet weak var datePickerTextField: UITextField!
    var datePickerView = UIDatePicker()
    
    // VARIABELS 
    var tempGoalPromille = 0.0
    var tempDateGoalPromille = NSDate()
    
    // TODAYS DATE
    var setCurrentDate = NSDate()
    var todayDate = NSDate()
    
    // GOAL PICKER
    var pickGoalProm = UIPickerView()
    @IBOutlet weak var pickGoalTextField: UITextField!
    
    // sett verdier i picker view
    var pickerData = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0"]
    
    var isGratulationViewRunned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsUpdateGoals()
        fetchUserData()
        
        // MÅLET
        pickGoalProm = UIPickerView()
        pickGoalTextField.inputView = pickGoalProm
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        pickGoalProm.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGrayColor()
        
        datePickViewGenderTextField()
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        setConstraints()
        
        print("isGratulationViewRunned: \(isGratulationViewRunned)")
    }
    
    func setColorsAndFontsUpdateGoals(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXT FIELDS
        //averageGoalPromilleTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        //averageGoalPromilleTextField.textColor = setAppColors.textUnderHeadlinesColors()
        //averageGoalPromilleTextField.attributedPlaceholder = NSAttributedString(string:"din mål promille",
        //    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        // LABELS
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(30)
        self.titleLabel.text = "Makspromille"
        
        self.subTitleLabel.text = "Endre din makspromille"
        
        // TEXTVIEW
        textViewGoal.textColor = setAppColors.textUnderHeadlinesColors()
        textViewGoal.font = setAppColors.textUnderHeadlinesFonts(12)
        
        // TEXTFIELDS
        self.datePickerTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.datePickerTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.datePickerTextField.attributedPlaceholder = NSAttributedString(string:"dato",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        self.pickGoalTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.pickGoalTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"målsetning",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func datePickerGoalPromille(sender: UIDatePicker) {
        getGoalDate = sender.date
    }
    
    @IBAction func saveGoalPromilleButton(sender: AnyObject) {
        // MAKS MÅL
        let maxGoal = 2.0
        
        print("Dato fra picker: \(getGoalDate)")
        //Parsing String values from UITextField to Integers:
        //goalPromille = Double(averageGoalPromilleTextField.text!)
        
        //Handling wrong inputs in UITextFields:
        if(goalPromille == nil){
            goalPromille = tempGoalPromille
        } else if(goalPromille == 0.0){
            errorMessage(errorMsg: "Du kan ikke legge inn 0 som mål!")
        } else if(goalPromille > maxGoal){
            errorMessage(errorMsg: "Du kan ikke legge inn høyere mål enn \(maxGoal)!")
        } else if let goalPromilleString:String! = String(goalPromille!){
            
            let message = "Dine Mål:\nMål Promille: \(goalPromille)\nMål Dato: \(getGoalDate)"
            
            brainCoreData.updateUserDataGoals(goalPromille, updateGoalDate: getGoalDate)
            fetchUserData()
            
            savedAlertController("Lagret", message: "", delayTime: 1.3)
        }
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            
            for item in userData {
                tempGoalPromille = item.goalPromille! as Double
                for values in pickerData {
                    if(tempGoalPromille == Double(values)){
                        if let i = pickerData.indexOf(values) {
                            self.pickGoalProm.selectRow(i, inComponent: 0, animated: true)
                            goalPromille = tempGoalPromille
                            //self.pickGoalTextField.text = "\(goalPromille)"
                            self.pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"\(goalPromille)",
                                attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                        }
                    }
                }
                
                tempDateGoalPromille = item.goalDate! as NSDate
                getGoalDate = tempDateGoalPromille
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                
                let strDate = dateFormatter.stringFromDate(tempDateGoalPromille)
                self.datePickerView.setDate(tempDateGoalPromille, animated: true)
                self.datePickerTextField.attributedPlaceholder = NSAttributedString(string:"\(strDate)",
                                                                                    attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // PICKER METHODS
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //globalGender = pickerData[row]
        self.pickGoalTextField.text = "\(pickerData[row])"
        
        if(goalPromille == Double(pickerData[row])){
            
        }
        print("PickerValue: \(pickerData[row])")
        goalPromille = Double(pickerData[row])
        if(goalPromille == 0.0){
            self.textViewGoal.textColor = UIColor.whiteColor()
            self.textViewGoal.text = "Legg inn en langsiktig makspromille du ønsker å holde deg under frem til en ønsket dato. \n\nMakspromillen tilsvarer et nivå av promille du ikke vil overstige i løpet av EN kveld. "
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-50")
        }
        if(goalPromille > 0.0 && goalPromille <= 0.3){
            self.textViewGoal.textColor = UIColor.whiteColor()
            self.textViewGoal.text = "Denne promillen tilsvarer ca. 1-2 enheter per kveld.\nDette er en godkjent promille. ( og eventuelt legg til et smiley bilde et sted ) "
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-50")
        }
        if(goalPromille > 0.3 && goalPromille <= 0.6){
            textViewGoal.text = "Denne promillen tilsvarer ca. 2-3 enheter per kveld.\nDette er en OGSÅ godkjent promille. ( og eventuelt legg til et smiley bilde et sted ) "
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-50")
        }
        if(goalPromille > 0.6 && goalPromille <= 0.9){
            textViewGoal.text = "Denne promillen tilsvarer ca. 3-4 enheter per kveld.\nNå nærmer du deg noe farlig høyt her!. ( og eventuelt legg til et smiley bilde et sted ) "
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-50")
        }
        if(goalPromille > 0.9 && goalPromille <= 1.2){
            textViewGoal.text = "Denne promillen tilsvarer ca. 5-6 enheter per kveld.\nHer er det farlig høyt. Vær forsiktig. ( og eventuelt legg til et smiley bilde et sted ) "
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-50") 
        }
        if(goalPromille > 1.2 && goalPromille <= 1.5){
            textViewGoal.text = "Denne promillen tilsvarer ca. 7-8 enheter per kveld"
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-50")
        }
        if(goalPromille > 1.5){
            textViewGoal.text = "Denne promillen tilsvarer ca. 10-12 enheter per kveld"
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-50")
        }
        print("Goal Promille: \(goalPromille)")
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
            pickerLabel?.textColor = setAppColors.textUnderHeadlinesColors()
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!;
    }
    
    // Alert om at du har lagret ting.
    func savedAlertController(title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        self.presentViewController(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
            if(self.isGratulationViewRunned == true){
                self.navigationController?.navigationBarHidden = false
                self.tabBarController?.tabBar.hidden = false
                print("segue to homeView")
                self.isGratulationViewRunned = false
                self.performSegueWithIdentifier("newGoalRegSegue", sender: self)
                // newGoalRegSegue
                
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
    
    // TESTING TEXT FIELD DATE PICKER VIEW
    func datePickViewGenderTextField(){
        datePickerView = UIDatePicker()
        //datePickerView.delegate = self
        datePickerTextField.inputView = datePickerView
        datePickerTextField.textColor = UIColor.whiteColor()
        
        // DATEPICKER
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePickerView.datePickerMode = .Date
        datePickerView.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        datePickerView.backgroundColor = UIColor.darkGrayColor()
        let dateString = dateFormatter.stringFromDate(datePickerView.date)
        todayDate = NSDate()
        datePickerView.minimumDate = todayDate
        datePickerView.setDate(tempDateGoalPromille, animated: true)
        datePickerView.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        //datePickerChanged(datePickerView)
        addDoneButton()
    }
    
    func datePickerChanged(sender:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        getGoalDate = sender.date
        let strDate = dateFormatter.stringFromDate(sender.date)
        datePickerTextField.text = strDate
    }
    
    // SCROLL VIEW
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Flytting av testfield
        // iPhone 4 - forskjellige settings
        
        // iPhone 5
        let moveTextFieldFive : CGFloat = 135
        
        // iPhone 6
        let moveTextFieldSix : CGFloat = 98.3
        
        // iPhone 6+
        let moveTextFieldSixPlus : CGFloat = 100
        
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        if(textField == pickGoalTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 68), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
            }
            //scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
        }
        if(textField == datePickerTextField){
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPointMake(0, 140), animated: true)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldFive), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSix), animated: true)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPointMake(0, moveTextFieldSixPlus), animated: true)
            }
        }
    }
    
    //Funksjonen under sørger for at tastaturet forsvinner når en trykker return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        datePickerTextField.inputAccessoryView = keyboardToolbar
        pickGoalTextField.inputAccessoryView = keyboardToolbar
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            // HEADER
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -300)
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -145)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -160)
            self.textViewGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -170)
            self.imageViewStateOfGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -170)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -230)
            
            // BUTTON
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -280.0)
            self.letsGoImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -280.0)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(14)
            self.textViewGoal.font = setAppColors.textUnderHeadlinesFonts(10)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            // HEADER
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -45) // -92
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -75)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -90)
            self.imageViewStateOfGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -97) // + 5
            self.textViewGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -105)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -150.0)
            
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -190.0)
            self.letsGoImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -190.0)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(14)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            
            // HEADER
            self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30) // -92
            self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -50)
            self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60)
            self.imageViewStateOfGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60) // + 5
            self.textViewGoal.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -60)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -82.0)
            
            // BUTTON AND BUTTON IMAGES
            let yValButton : CGFloat = -100.0
            self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, yValButton)
            self.letsGoImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, yValButton)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(16)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            setWholeConstOverall(0.0, yValue: -40)
        }
    }
    
    func setTextFieldsConst(xValue: CGFloat, yValue: CGFloat){
        // TEXTFIELDS, TEXTF IMAGES, TEXTF TITLELABELS
        self.pickGoalTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.datePickerTextField.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.goalImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.goalDateImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.dateTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.goalTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        
        // UNDERSCORES
        self.underscoreDate.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.underScoreGoal.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
    }
    
    func setWholeConstOverall(xValue: CGFloat, yValue: CGFloat){
        
        // HEADER
        self.headerImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.titleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.subTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.textViewGoal.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.imageViewStateOfGoal.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        
        setTextFieldsConst(xValue, yValue: yValue)
        
        // BUTTON AND BUTTON IMAGES
        self.nextBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
        self.letsGoImageView.transform = CGAffineTransformTranslate(self.view.transform, xValue, yValue)
    }
    

    
}
