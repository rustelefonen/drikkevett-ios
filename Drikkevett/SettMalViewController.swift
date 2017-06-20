import UIKit
import CoreData

class SettMalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var textViewGoal: UITextView!
    @IBOutlet weak var smileyImageView: UIImageView!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var pickGoalTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerData = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0"]
    
    var goalPromille : Double! = 0.0
    
    var getDate = Date()
    
    // Kommunikasjon med database/Core Data
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    
    var setAppColors = AppColors()
    var datePickerView = UIDatePicker()
    var pickGoalProm = UIPickerView()
    
    var dateMessage = ""
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsEnterGoals()
        datePickViewGenderTextField()
        setGoalPickerView()
    }
    
    func setGoalPickerView(){       //DENNE ER RAR? SETTES ETTER AT INPUTVIEW ER SATT
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func letsRoleButton(_ sender: AnyObject) {
        let maxPromille = 2.0
        
        if(goalPromille <= 0.0){
            errorMessage(errorMsg: "Fyll en en aktuell promille! ")
        } else if(goalPromille == nil){
            goalPromille = 0
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        } else if(goalPromille >= maxPromille){
            errorMessage(errorMsg: "Du kan ikke legge inn høyere promille enn \(maxPromille)")
        } else if let goalPromilleString:String? = String(goalPromille!){
            let message = "Målsetning: \(String(format: "%.2f", goalPromille!))\n\(dateMessage)"
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
    
    func privacyMessage(){
        let message = ResourceList.privacyMessage
        let refreshAlert = UIAlertController(title: "Personvernerklæring", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let userDataDao = UserDataDao()
            let userData = userDataDao.createNewUserData()
            
            userData.height = self.userInfo?.nickName
            userData.gender = self.userInfo?.gender as! NSNumber
            userData.age = self.userInfo?.age as! NSNumber
            userData.weight = self.userInfo?.weight as! NSNumber
            
            userData.costsBeer = self.userInfo?.costsBeer as! NSNumber
            userData.costsWine = self.userInfo?.costsWine as! NSNumber
            userData.costsDrink = self.userInfo?.costsDrink as! NSNumber
            userData.costsShot = self.userInfo?.costsShot as! NSNumber
            
            userData.goalPromille = self.goalPromille as! NSNumber
            userData.goalDate = self.getDate
            
            userDataDao.save()
            
            self.isFirstRegistrationCompleted()
            self.isAppGuidanceDone()
            self.performSegue(withIdentifier: "goalSegue", sender: self)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func confirmMessage(_ titleMsg:String = "Bekreft", errorMsg:String = "Informasjon", cancelMsg:String = "Avbryt", confirmMsg: String = "Bekreft" ){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelMsg, style: UIAlertActionStyle.destructive, handler:nil))
        
        alertController.addAction(UIAlertAction(title:confirmMsg, style: UIAlertActionStyle.default, handler:  { action in
            self.privacyMessage()
            }))
        self.present(alertController, animated: true, completion: { action in})
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
        addDoneButton()
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
}
