import UIKit
import CoreData

class KostnaderViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    static let segueId = "settingsSegue"
    
    @IBOutlet weak var beerInput: UITextField!
    @IBOutlet weak var wineInput: UITextField!
    @IBOutlet weak var drinkInput: UITextField!
    @IBOutlet weak var shotInput: UITextField!
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    @IBOutlet weak var standardButton: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField:UITextField?
    var introPageViewController:IntroPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        
        beerInput.delegate = self
        beerInput.keyboardType = UIKeyboardType.numberPad
        wineInput.delegate = self
        wineInput.keyboardType = UIKeyboardType.numberPad
        drinkInput.delegate = self
        drinkInput.keyboardType = UIKeyboardType.numberPad
        shotInput.delegate = self
        shotInput.keyboardType = UIKeyboardType.numberPad
        
        standardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (useDefaultCosts)))
        beerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editBeer)))
        wineImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editWine)))
        drinkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editDrink)))
        shotImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (editShot)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        activeField?.delegate = self
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func editBeer() {
        performSegue(withIdentifier: UnitViewController.segueId, sender: 0)
    }
    func editWine() {
        performSegue(withIdentifier: UnitViewController.segueId, sender: 1)
    }
    func editDrink() {
        performSegue(withIdentifier: UnitViewController.segueId, sender: 2)
    }
    func editShot() {
        performSegue(withIdentifier: UnitViewController.segueId, sender: 3)
    }
    
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func useDefaultCosts() {
        beerInput.text = "60"
        wineInput.text = "70"
        drinkInput.text = "100"
        shotInput.text = "110"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UnitViewController.segueId {
            if segue.destination is UnitViewController {
                let destination = segue.destination as! UnitViewController
                destination.unitType = sender as? Int
                destination.introPageViewController = introPageViewController
                
                let backItem = UIBarButtonItem()
                backItem.title = "Kostnader"
                navigationItem.backBarButtonItem = backItem
            }
        }
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
        beerInput.inputAccessoryView = keyboardToolbar
        wineInput.inputAccessoryView = keyboardToolbar
        drinkInput.inputAccessoryView = keyboardToolbar
        shotInput.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        addDoneButton()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
 }
