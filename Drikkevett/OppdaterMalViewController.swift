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
    
    var getGoalDate = Date()
    var goalPromille : Double! = 0.0
    
    // DATEPICKER OUTLET
    @IBOutlet weak var datePickerTextField: UITextField!
    var datePickerView = UIDatePicker()
    
    // VARIABELS 
    var tempGoalPromille = 0.0
    var tempDateGoalPromille = Date()
    
    // TODAYS DATE
    var setCurrentDate = Date()
    var todayDate = Date()
    
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
        pickGoalProm.backgroundColor = UIColor.darkGray
        
        datePickViewGenderTextField()
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        setConstraints()
        
        print("isGratulationViewRunned: \(isGratulationViewRunned)")
    }
    
    func setColorsAndFontsUpdateGoals(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
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
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.pickGoalTextField.textColor = setAppColors.textUnderHeadlinesColors()
        self.pickGoalTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        self.pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"målsetning",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func datePickerGoalPromille(_ sender: UIDatePicker) {
        getGoalDate = sender.date
    }
    
    @IBAction func saveGoalPromilleButton(_ sender: AnyObject) {
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
        } else if let goalPromilleString:String? = String(goalPromille!){
            
            //let message = "Dine Mål:\nMål Promille: \(goalPromille)\nMål Dato: \(getGoalDate)"
            
            brainCoreData.updateUserDataGoals(goalPromille, updateGoalDate: getGoalDate)
            fetchUserData()
            
            savedAlertController("Lagret", message: "", delayTime: 1.3)
        }
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        let timeStampFetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            
            for item in userData {
                tempGoalPromille = item.goalPromille! as Double
                for values in pickerData {
                    if(tempGoalPromille == Double(values)){
                        if let i = pickerData.index(of: values) {
                            self.pickGoalProm.selectRow(i, inComponent: 0, animated: true)
                            goalPromille = tempGoalPromille
                            //self.pickGoalTextField.text = "\(goalPromille)"
                            self.pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"\(goalPromille)",
                                attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
                        }
                    }
                }
                
                tempDateGoalPromille = item.goalDate! as Date
                getGoalDate = tempDateGoalPromille
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short
                
                let strDate = dateFormatter.string(from: tempDateGoalPromille)
                self.datePickerView.setDate(tempDateGoalPromille, animated: true)
                self.datePickerTextField.attributedPlaceholder = NSAttributedString(string:"\(strDate)",
                                                                                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // PICKER METHODS
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //globalGender = pickerData[row]
        self.pickGoalTextField.text = "\(pickerData[row])"
        
        if(goalPromille == Double(pickerData[row])){
            
        }
        print("PickerValue: \(pickerData[row])")
        goalPromille = Double(pickerData[row])
        if(goalPromille == 0.0){
            self.textViewGoal.textColor = UIColor.white
            self.textViewGoal.text = "Legg inn en langsiktig makspromille du ønsker å holde deg under frem til en ønsket dato. \n\nMakspromillen tilsvarer et nivå av promille du ikke vil overstige i løpet av EN kveld. "
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.0 && goalPromille <= 0.3){
            self.textViewGoal.textColor = UIColor.white
            self.textViewGoal.text = "En promille der de fleste vil fremstå som normale."
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.3 && goalPromille <= 0.6){
            textViewGoal.text = "En promille der de fleste vil fremstå som normale.\n\nDu kan føle velbehag, bli pratsom og bli mer avslappet."
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.6 && goalPromille <= 0.9){
            textViewGoal.text = "Denne promillen tilsvarer det man kaller lykkepromille!"
            self.imageViewStateOfGoal.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.9 && goalPromille <= 1.2){
            textViewGoal.text = "Balansen vil bli svekket. "
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.2 && goalPromille <= 1.5){
            textViewGoal.text = "Talen blir snøvlete og kontrollen på bevegelser forverres"
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.5 && goalPromille <= 1.7){
            textViewGoal.text = "Man blir trøtt sløv og kan bli kvalm"
            self.imageViewStateOfGoal.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.7){
            textViewGoal.text = "Hukommelsen sliter og man kan bli bevisstløs."
            self.imageViewStateOfGoal.image = UIImage(named: "Vomited-100")
        }
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
            pickerLabel?.textColor = setAppColors.textUnderHeadlinesColors()
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!;
    }
    
    // Alert om at du har lagret ting.
    func savedAlertController(_ title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
            if(self.isGratulationViewRunned == true){
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                self.isGratulationViewRunned = false
                self.performSegue(withIdentifier: "newGoalRegSegue", sender: self)
                // newGoalRegSegue
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    // TESTING TEXT FIELD DATE PICKER VIEW
    func datePickViewGenderTextField(){
        datePickerView = UIDatePicker()
        //datePickerView.delegate = self
        datePickerTextField.inputView = datePickerView
        datePickerTextField.textColor = UIColor.white
        
        // DATEPICKER
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePickerView.datePickerMode = .date
        datePickerView.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        datePickerView.backgroundColor = UIColor.darkGray
        //let dateString = dateFormatter.stringFromDate(datePickerView.date)
        todayDate = Date()
        
        let calendar = Calendar.current
        let tomorrow = (calendar as NSCalendar).date(byAdding: .day, value: +1, to: Date(), options: [])
        
        
        datePickerView.minimumDate = tomorrow
        datePickerView.setDate(tomorrow!, animated: true)
        datePickerView.addTarget(self, action: #selector(OppdaterMalViewController.datePickerChanged(_:)), for: UIControlEvents.valueChanged)
        //datePickerChanged(datePickerView)
        addDoneButton()
    }
    
    func datePickerChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        getGoalDate = sender.date
        let strDate = dateFormatter.string(from: sender.date)
        datePickerTextField.text = strDate
    }
    
    // SCROLL VIEW
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 68), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
            //scrollView.setContentOffset(CGPointMake(0, moveTextField), animated: true)
        }
        if(textField == datePickerTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldFive), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSix), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextFieldSixPlus), animated: true)
            }
        }
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
        datePickerTextField.inputAccessoryView = keyboardToolbar
        pickGoalTextField.inputAccessoryView = keyboardToolbar
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -300)
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -145)
            self.subTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -160)
            self.textViewGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -170)
            self.imageViewStateOfGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -170)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -230)
            
            // BUTTON
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -280.0)
            self.letsGoImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -280.0)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(14)
            self.textViewGoal.font = setAppColors.textUnderHeadlinesFonts(10)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -45) // -92
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -75)
            self.subTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -90)
            self.imageViewStateOfGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -97) // + 5
            self.textViewGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -105)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -150.0)
            
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -190.0)
            self.letsGoImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -190.0)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(14)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -30) // -92
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -50)
            self.subTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -60)
            self.imageViewStateOfGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -60) // + 5
            self.textViewGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -60)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -82.0)
            
            // BUTTON AND BUTTON IMAGES
            let yValButton : CGFloat = -100.0
            self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: yValButton)
            self.letsGoImageView.transform = self.view.transform.translatedBy(x: 0.0, y: yValButton)
            
            // FONT
            self.subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(16)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            setWholeConstOverall(0.0, yValue: -40)
        }
    }
    
    func setTextFieldsConst(_ xValue: CGFloat, yValue: CGFloat){
        // TEXTFIELDS, TEXTF IMAGES, TEXTF TITLELABELS
        self.pickGoalTextField.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.datePickerTextField.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.goalImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.goalDateImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.dateTitleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.goalTitleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        
        // UNDERSCORES
        self.underscoreDate.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.underScoreGoal.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
    }
    
    func setWholeConstOverall(_ xValue: CGFloat, yValue: CGFloat){
        
        // HEADER
        self.headerImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.titleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.subTitleLabel.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.textViewGoal.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.imageViewStateOfGoal.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        
        setTextFieldsConst(xValue, yValue: yValue)
        
        // BUTTON AND BUTTON IMAGES
        self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.letsGoImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
    }
    

    
}
