//  SettMalViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 01.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class SettMalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var textViewGoal: UITextView!
    
    // IMAGES
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var smileyImageView: UIImageView!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var goalDateImageView: UIImageView!
    @IBOutlet weak var letsGoImageView: UIImageView!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    
    // UNDERSCORES
    @IBOutlet weak var underScoreGoal: UILabel!
    @IBOutlet weak var underscoreDate: UILabel!
    
    // TITLE LABELS
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    
    // sett verdier i picker view
    var pickerData = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0"]
    
    var getDate = Date()
    var goalPromille : Double! = 0.0
    
    // Kommunikasjon med database/Core Data
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    // set Colors
    var setAppColors = AppColors()
    
    // Set current date
    var todayDate = Date()
    
    // MÅL DATO DATEPICKERVIEW
    @IBOutlet weak var datePickerTextField: UITextField!
    var datePickerView = UIDatePicker()
    
    // MÅL PICKERVIEW
    @IBOutlet weak var pickGoalTextField: UITextField!
    var pickGoalProm = UIPickerView()
    
    // SCROLLVIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dateMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsEnterGoals()
        
        // SET DATE PICKER
        datePickViewGenderTextField()
        
        // SET GOAL DATE PICKER
        setGoalPickerView()
        setConstraints()
    }
    
    func setGoalPickerView(){
        // MÅLET
        pickGoalProm = UIPickerView()
        pickGoalTextField.inputView = pickGoalProm
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        pickGoalProm.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGray
    }
    
    func setColorsAndFontsEnterGoals(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TITLE OG SUBTITLE
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(34)
        subTitleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        subTitleLabel.font = setAppColors.textUnderHeadlinesFonts(18)
        
        // LABELS
        
        // TEXTVIEW
        textViewGoal.textColor = setAppColors.textUnderHeadlinesColors()
        textViewGoal.font = setAppColors.textUnderHeadlinesFonts(12)
        
        // TEXTFIELDS
        datePickerTextField.textColor = setAppColors.textUnderHeadlinesColors()
        datePickerTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        pickGoalTextField.textColor = setAppColors.textUnderHeadlinesColors()
        pickGoalTextField.font = setAppColors.textUnderHeadlinesFonts(15)
        
        datePickerTextField.attributedPlaceholder = NSAttributedString(string:"dato",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"makspromille",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func letsRoleButton(_ sender: AnyObject) {
        let maxPromille = 2.0
        
        //Handling wrong inputs in UITextFields:
        if(goalPromille <= 0.0){
            errorMessage(errorMsg: "Fyll en en aktuell promille! ")
        } else if(goalPromille == nil){
            goalPromille = 0
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        } else if(goalPromille >= maxPromille){
            errorMessage(errorMsg: "Du kan ikke legge inn høyere promille enn \(maxPromille)")
        } else if let goalPromilleString:String? = String(goalPromille!){
            let message = "Målsetning: \(goalPromille)\n\(dateMessage)"
            confirmMessage("Mål", errorMsg: message, cancelMsg:"Avbryt", confirmMsg: "Bekreft")
        }
    }
    
    //Method for pop-up messages when handling wrong inputs:
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmMessage(_ titleMsg:String = "Bekreft", errorMsg:String = "Informasjon", cancelMsg:String = "Avbryt", confirmMsg: String = "Bekreft" ){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelMsg, style: UIAlertActionStyle.destructive, handler:{ (action: UIAlertAction!) in
            print("Handle cancel logic here")
        }))
        
        alertController.addAction(UIAlertAction(title:confirmMsg, style: UIAlertActionStyle.default, handler:  { action in
            self.brainCoreData.updateUserDataGoals(self.goalPromille, updateGoalDate: self.getDate)
            self.isFirstRegistrationCompleted()
            self.isAppGuidanceDone()
            self.performSegue(withIdentifier: "goalSegue"
                , sender: self) }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isAppGuidanceDone()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnceGui"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnceGui")
            print("App launched first time")
            return false
        }
    }
    
    func isFirstRegistrationCompleted()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppRegistrationCompleted = defaults.string(forKey: "isFirstRegistrationCompleted"){
            print("Registration is completed")
            return true
        }else{
            defaults.set(true, forKey: "isFirstRegistrationCompleted")
            print("Registration is NOT completed")
            return false
        }
    }
    
    // PICKER METHODS
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //globalGender = pickerData[row]
        self.pickGoalTextField.text = "\(pickerData[row])"
        print("PickerValue: \(pickerData[row])")
        goalPromille = Double(pickerData[row])
        if(goalPromille == 0.0){
            self.textViewGoal.textColor = UIColor.white
            self.textViewGoal.text = "Legg inn en langsiktig makspromille du ønsker å holde deg under frem til en ønsket dato. \n\nMakspromillen tilsvarer et nivå av promille du ikke vil overstige i løpet av EN kveld. "
            self.smileyImageView.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.0 && goalPromille <= 0.3){
            self.textViewGoal.textColor = UIColor.white
            self.textViewGoal.text = "En promille der de fleste vil fremstå som normale."
            self.smileyImageView.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.3 && goalPromille <= 0.6){
            textViewGoal.text = "En promille der de fleste vil fremstå som normale.\n\nDu kan føle velbehag, bli pratsom og bli mer avslappet."
            self.smileyImageView.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.6 && goalPromille <= 0.9){
            textViewGoal.text = "Denne promillen tilsvarer det man kaller lykkepromille!\n\nDu føler velbehag, blir mer pratsom og har redusert hemning."
            self.smileyImageView.image = UIImage(named: "Happy-100")
        }
        if(goalPromille > 0.9 && goalPromille <= 1.2){
            textViewGoal.text = "Balansen vil bli svekket."
            self.smileyImageView.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.2 && goalPromille <= 1.5){
            textViewGoal.text = "Talen blir snøvlete og kontrollen på bevegelser forverres."
             self.smileyImageView.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.5 && goalPromille <= 1.7){
            textViewGoal.text = "Man blir trøtt sløv og kan bli kvalm."
            self.smileyImageView.image = UIImage(named: "Sad-100")
        }
        if(goalPromille > 1.7){
            textViewGoal.text = "Hukommelsen sliter og man kan bli bevisstløs."
            self.smileyImageView.image = UIImage(named: "Vomited-100")
        }
        print("Goal Promille: \(goalPromille)")
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
        datePickerView.addTarget(self, action: #selector(SettMalViewController.datePickerChanged(_:)), for: UIControlEvents.valueChanged)
        //datePickerChanged(datePickerView)
        addDoneButton()
    }
    
    func datePickerChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        getDate = sender.date
        let strDate = dateFormatter.string(from: sender.date)
        dateMessage = "Måldato: \(strDate)"
        datePickerTextField.text = strDate
    }
    
    // SCROLL VIEW
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //If sørger for at kun det textfeltet du ønsker å flytte blir flyttet
        // iPhone 6
        let moveTextField : CGFloat = 100
        
        if(textField == datePickerTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 167.5), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: 170), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
            }
        }
        if(textField == pickGoalTextField){
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                scrollView.setContentOffset(CGPoint(x: 0, y: moveTextField), animated: true)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
        addDoneButton()
        //else kan brukes for å håndtere andre textfields som ikke må dyttes like høyt opp!
    }
    //Funksjonen under sørger for å re-posisjonere tekstfeltet etter en har skrevet noe.
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // TATSTATUR
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
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -180)
            self.subTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -180)
            self.textViewGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -180)
            self.smileyImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -180)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -200)
            
            // BUTTON
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -235.0)
            self.letsGoImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -235.0)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            // HEADER
            self.headerImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -82) // -92
            self.titleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -95)
            self.subTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -105)
            self.smileyImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -110) // + 5
            self.textViewGoal.transform = self.view.transform.translatedBy(x: 0.0, y: -105)
            
            // TEXTFIELDS
            setTextFieldsConst(0.0, yValue: -132.5)
            
            // BUTTON AND BUTTON IMAGES
            self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -160.0)
            self.letsGoImageView.transform = self.view.transform.translatedBy(x: 0.0, y: -160.0)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            setWholeConstOverall(0.0, yValue: -82.0)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            setWholeConstOverall(0.0, yValue: -50)
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
        self.smileyImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        
        setTextFieldsConst(xValue, yValue: yValue)
        
        // BUTTON AND BUTTON IMAGES
        self.nextBtnOutlet.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
        self.letsGoImageView.transform = self.view.transform.translatedBy(x: xValue, y: yValue)
    }
}
