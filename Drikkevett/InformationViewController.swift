import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var maxBacInput: UITextField!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let pickerData = ["Velg Kjønn", "Mann", "Kvinne"]
    var activeField: UITextField?
    
    var introPageViewController:IntroPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppColors.setBackground(view: view)
        
        nicknameInput.delegate = self
        nicknameInput.keyboardType = UIKeyboardType.asciiCapable
        
        genderInput.inputView = initGenderPicker()
        
        weightInput.delegate = self
        weightInput.keyboardType = UIKeyboardType.numberPad
        
        activeField?.delegate = self
        registerForKeyboardNotifications()
        
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.goNext(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func initGenderPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        return pickerView
    }
    
    func goNext(_ sender: UIButton) {
        performSegue(withIdentifier: PrivacyViewController.segueId, sender: nil)
        /*let nickName = nicknameInput.text
        var gender:Bool? = nil
        if genderInput.text == pickerData[1] {gender = true}
        else if (genderInput.text == pickerData[2]) {gender = false}
        let age = Int(ageInput.text!)
        let weight = Double(weightInput.text!)
        
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
        
        let message = "\(nickName!)\n\(genderInput.text!)\n\(age!)\n\(weight!)"
        
        let continueAlert = UIAlertController(title: "Brukerinfo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        continueAlert.addAction(UIAlertAction(title: "Bekreft", style: .default, handler: { (action: UIAlertAction!) in
            
            let userInfo = UserInfo()
            userInfo.nickName = nickName
            userInfo.gender = gender
            userInfo.age = age
            userInfo.weight = weight
            self.performSegue(withIdentifier: KostnaderViewController.segueId, sender: userInfo)
        }))
        
        continueAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(continueAlert, animated: true, completion: nil)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PrivacyViewController.segueId {
            if segue.destination is PrivacyViewController {
                let destination = segue.destination as! PrivacyViewController
                destination.introPageViewController = introPageViewController
            }
        }
    }
    
    func errorMessage(_ titleMsg:String = "Beklager,", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "OK"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        
        nicknameInput.inputAccessoryView = keyboardToolbar
        genderInput.inputAccessoryView = keyboardToolbar
        weightInput.inputAccessoryView = keyboardToolbar
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderInput.text = pickerData[row]
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nicknameLength = 15
        let weightLength = 3
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == nicknameInput {return prospectiveText.characters.count <= nicknameLength}
        else if textField == weightInput {
            let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
            return prospectiveText.isNumeric() && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) && prospectiveText.characters.count <= weightLength
        }
        return true
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
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        addDoneButton()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}
