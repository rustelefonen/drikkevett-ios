import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var chooseGenderTextField: UITextField!
    
    var pickGenderView = UIPickerView()
    
    let pickerData = ["Velg Kjønn", "Mann", "Kvinne"]
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // TEXTFIELDS
        ageField.attributedPlaceholder = NSAttributedString(string:"oppgi alder", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        heightField.attributedPlaceholder = NSAttributedString(string:"oppgi kallenavn", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        weightField.attributedPlaceholder = NSAttributedString(string:"oppgi vekt", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.chooseGenderTextField.attributedPlaceholder = NSAttributedString(string:"oppgi kjønn", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        pickViewGenderTextField()
        
        heightField.delegate = self
        heightField.keyboardType = UIKeyboardType.asciiCapable
        
        weightField.delegate = self
        weightField.keyboardType = UIKeyboardType.numberPad
        
        ageField.delegate = self
        ageField.keyboardType = UIKeyboardType.numberPad
    }
    
    func pickViewGenderTextField(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        chooseGenderTextField.inputView = pickerView
        pickGenderView.dataSource = self
        pickGenderView.delegate = self
        pickGenderView.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        let nickName = heightField.text
        var gender:Bool? = nil
        if chooseGenderTextField.text == pickerData[1] {gender = true}
        else if (chooseGenderTextField.text == pickerData[2]) {gender = false}
        let age = Int(ageField.text!)
        let weight = Double(weightField.text!)
        
        if (nickName == nil || nickName == "" || gender == nil || age == nil || weight == nil) {
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
        
        let message = "\(nickName!)\n\(chooseGenderTextField.text!)\n\(age!)\n\(weight!)"
        
        let continueAlert = UIAlertController(title: "Brukerinfo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        continueAlert.addAction(UIAlertAction(title: "Bekreft", style: .default, handler: { (action: UIAlertAction!) in
            self.setUserData(nickName: nickName, gender: gender, age: age, weight: weight)
            self.performSegue(withIdentifier: "settingsSegue", sender: nil)
        }))
        
        continueAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(continueAlert, animated: true, completion: nil)
    }
    
    func errorMessage(_ titleMsg:String = "Beklager,", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "OK"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUserData(nickName:String?, gender:Bool?, age:Int?, weight:Double?) {
        let moc = DataController().managedObjectContext
        
        let userData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: moc) as! UserData
        userData.height = nickName
        userData.gender = gender! as NSNumber
        userData.age = age! as NSNumber
        userData.weight = weight as NSNumber?
        
        try? moc.save()
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
        ageField.inputAccessoryView = keyboardToolbar
        heightField.inputAccessoryView = keyboardToolbar
        weightField.inputAccessoryView = keyboardToolbar
        chooseGenderTextField.inputAccessoryView = keyboardToolbar
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseGenderTextField.text = pickerData[row]
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {return true}

        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            case heightField:
                return prospectiveText.characters.count <= 15
            
            case weightField:
                let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
                return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= 3
            
            case ageField:
                let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
                return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= 2

            default:
                return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
