import UIKit
import CoreData

class KostnaderViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    static let segueId = "settingsSegue"
    
    @IBOutlet weak var beerInput: UITextField!
    @IBOutlet weak var wineInput: UITextField!
    @IBOutlet weak var drinkInput: UITextField!
    @IBOutlet weak var shotInput: UITextField!
    
    @IBOutlet weak var standardButton: UIView!
    @IBOutlet weak var nextButton: UIView!
    
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)*/
        
        standardButton.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector (self.useDefaultCosts)))
        nextButton.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector (self.goNext)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func goNext() {
        let beerCostsInfo = Int(beerInput.text!)
        let wineCostsInfo = Int(wineInput.text!)
        let drinkCostsInfo = Int(drinkInput.text!)
        let shotCostsInfo = Int(shotInput.text!)
        
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
            
            self.performSegue(withIdentifier: SettMalViewController.segueId, sender: self.userInfo)
        }))
        present(alertController, animated: true, completion: nil)
        
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
        if segue.identifier == SettMalViewController.segueId {
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
        
        beerInput.inputAccessoryView = keyboardToolbar
        wineInput.inputAccessoryView = keyboardToolbar
        drinkInput.inputAccessoryView = keyboardToolbar
        shotInput.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4

        if string.characters.count == 0 {return true}

        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
        return prospectiveText.isNumeric() &&
            prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
            prospectiveText.characters.count <= maxLength
    }
 }
