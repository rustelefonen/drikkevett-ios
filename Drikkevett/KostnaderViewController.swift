import UIKit
import CoreData

class KostnaderViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var costsBeerLabel: UITextField!
    @IBOutlet weak var costsWineTextField: UITextField!
    @IBOutlet weak var costsDrinkTextField: UITextField!
    @IBOutlet weak var costsShotTextField: UITextField!
    @IBOutlet weak var standardPrizesBtnOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        costsBeerLabel.attributedPlaceholder = NSAttributedString(string:"oppgi ølpris", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        costsWineTextField.attributedPlaceholder = NSAttributedString(string:"oppgi vinpris", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        costsDrinkTextField.attributedPlaceholder = NSAttributedString(string:"oppgi drinkpris", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        costsShotTextField.attributedPlaceholder = NSAttributedString(string:"oppgi shotpris", attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        standardPrizesBtnOutlet.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButton(_ sender: AnyObject) {
        let beerCostsInfo = Int(costsBeerLabel.text!)
        let wineCostsInfo = Int(costsWineTextField.text!)
        let drinkCostsInfo = Int(costsDrinkTextField.text!)
        let shotCostsInfo = Int(costsShotTextField.text!)
        
        if(beerCostsInfo == nil || wineCostsInfo == nil || drinkCostsInfo == nil || shotCostsInfo == nil){
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        }
        if(beerCostsInfo! >= 10000 || beerCostsInfo! <= 0){errorMessage(errorMsg: "Så mye betaler du ikke for øl?")}
        if(wineCostsInfo! >= 10000 || wineCostsInfo! <= 0){errorMessage(errorMsg: "Så mye betaler du ikke for vin?")}
        if(drinkCostsInfo! >= 10000 || drinkCostsInfo! <= 0){errorMessage(errorMsg: "Så mye betaler du ikke for drink?")}
        if(shotCostsInfo! >= 10000 || shotCostsInfo! <= 0){errorMessage(errorMsg: "Så mye betaler du ikke for shot?")}
        
        let message = "Øl: \(beerCostsInfo!) kr\nVin: \(wineCostsInfo!) kr\nDrink: \(drinkCostsInfo!) kr\nShot: \(shotCostsInfo!) kr"
        
        let alertController = UIAlertController(title: "Kostnader", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.destructive, handler: nil))
        
        alertController.addAction(UIAlertAction(title:"Bekreft", style: UIAlertActionStyle.default, handler:  { action in
            if self.userInfo == nil {return}
            self.userInfo?.costsBeer = beerCostsInfo
            self.userInfo?.costsWine = wineCostsInfo
            self.userInfo?.costsDrink = drinkCostsInfo
            self.userInfo?.costsShot = shotCostsInfo
            
            self.performSegue(withIdentifier: "kostnadTilMalSegue", sender: self.userInfo)
        }))
        present(alertController, animated: true, completion: nil)
        
    }
    
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func useDefaultCosts(_ sender: AnyObject) {
        self.costsBeerLabel.text = "60"
        self.costsWineTextField.text = "70"
        self.costsDrinkTextField.text = "100"
        self.costsShotTextField.text = "110"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kostnadTilMalSegue" {
            if segue.destination is SettMalViewController {
                let destinationVC = segue.destination as! SettMalViewController
                destinationVC.userInfo = sender as? UserInfo
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        keyboardToolbar.alpha = 0.9
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //flexBarButton.tintColor = UIColor.whiteColor()
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.white
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        costsBeerLabel.inputAccessoryView = keyboardToolbar
        costsWineTextField.inputAccessoryView = keyboardToolbar
        costsDrinkTextField.inputAccessoryView = keyboardToolbar
        costsShotTextField.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
                prospectiveText.characters.count <= 4
        default:
            return true
        }
    }
 }
