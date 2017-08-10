import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var bacImage: UIImageView!
    @IBOutlet weak var bacText: UITextView!
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var maxBacInput: UITextField!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var maxBacPickerData = ["0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4"]
    let pickerData = ["Velg Kjønn", "Mann", "Kvinne"]
    var activeField: UITextField?
    
    let maxBacTag = 555
    let genderTag = 666
    
    var introPageViewController:IntroPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppColors.setBackground(view: view)
        
        nicknameInput.delegate = self
        nicknameInput.keyboardType = UIKeyboardType.asciiCapable
        
        genderInput.inputView = initGenderPicker()
        
        weightInput.delegate = self
        weightInput.keyboardType = UIKeyboardType.numberPad
        
        setGoalPickerView()
        
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.goNext(_:))))
    
        addDoneButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        activeField?.delegate = self
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func setGoalPickerView(){       //DENNE ER RAR? SETTES ETTER AT INPUTVIEW ER SATT
        let pickGoalProm = UIPickerView()
        maxBacInput.inputView = pickGoalProm
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        let setAppColors = AppColors()
        pickGoalProm.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGray
        
        pickGoalProm.tag = maxBacTag
    }
    
    func initGenderPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.darkGray
        pickerView.tag = genderTag
        return pickerView
    }
    
    func updateBacText() {
        guard let bacChosen = Double(maxBacInput.text!) else {return}
        
        bacText.textColor = getQuoteTextColorBy(bac: bacChosen)
        bacText.text = getQuoteRegisterTextBy(bac: bacChosen)
        bacImage.image = getUIImageRegisterBy(bac: bacChosen)
    }
    
    func goNext(_ sender: UIButton) {
        if (introPageViewController?.areCriticalFieldsValid())! {performSegue(withIdentifier: PrivacyViewController.segueId, sender: nil)}
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
        maxBacInput.inputAccessoryView = keyboardToolbar
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == genderTag {genderInput.text = pickerData[row]}
        else if pickerView.tag == maxBacTag {maxBacInput.text = maxBacPickerData[row]}
        updateBacText()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 0.01)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == genderTag ? pickerData.count : maxBacPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.white
        }
        
        pickerLabel?.text = pickerView.tag == genderTag ? pickerData[row] : maxBacPickerData[row]
        
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
