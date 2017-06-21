import UIKit
import CoreData

class SettMalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    static let segueId = "kostnadTilMalSegue"
    
    @IBOutlet weak var textViewGoal: UITextView!
    @IBOutlet weak var smileyImageView: UIImageView!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var pickGoalTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerData = [String]()
    var getDate = Date()
    var dateMessage = ""
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0"]
        
        setColorsAndFontsEnterGoals()
        datePickViewGenderTextField()
        setGoalPickerView()
    }
    
    func setColorsAndFontsEnterGoals(){
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        datePickerTextField.attributedPlaceholder = NSAttributedString(string:"dato",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        pickGoalTextField.attributedPlaceholder = NSAttributedString(string:"makspromille",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    }
    
    func datePickViewGenderTextField(){
        let datePickerView = UIDatePicker()
        datePickerTextField.inputView = datePickerView
        datePickerTextField.textColor = UIColor.white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePickerView.datePickerMode = .date
        
        let setAppColors = AppColors()
        datePickerView.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        datePickerView.backgroundColor = UIColor.darkGray
        
        let calendar = Calendar.current
        let tomorrow = (calendar as NSCalendar).date(byAdding: .day, value: +1, to: Date(), options: [])
        
        datePickerView.minimumDate = tomorrow
        datePickerView.setDate(tomorrow!, animated: true)
        datePickerView.addTarget(self, action: #selector(SettMalViewController.datePickerChanged(_:)), for: UIControlEvents.valueChanged)
        addDoneButton()
    }
    
    func setGoalPickerView(){       //DENNE ER RAR? SETTES ETTER AT INPUTVIEW ER SATT
        let pickGoalProm = UIPickerView()
        pickGoalTextField.inputView = pickGoalProm
        pickGoalProm.dataSource = self
        pickGoalProm.delegate = self
        let setAppColors = AppColors()
        pickGoalProm.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        pickGoalProm.backgroundColor = UIColor.darkGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func letsRoleButton(_ sender: AnyObject) {
        var goalPromille = Double(pickGoalTextField.text!)
        if goalPromille == nil {return}
        
        let maxPromille = 2.0
        
        if(goalPromille! <= 0.0){errorMessage(errorMsg: "Fyll en en aktuell promille! ")}
        else if(goalPromille == nil){
            goalPromille = 0
            errorMessage(errorMsg: "Alle felter må fylles ut!")
        } else if(goalPromille! >= maxPromille){errorMessage(errorMsg: "Du kan ikke legge inn høyere promille enn \(maxPromille)")}
        else if let goalPromilleString:String? = String(goalPromille!){
            let message = "Målsetning: \(String(format: "%.2f", goalPromille!))\n\(dateMessage)"
            confirmMessage("Mål", errorMsg: message, cancelMsg:"Avbryt", confirmMsg: "Bekreft")
        }
    }
    
    func errorMessage(_ titleMsg:String = "Feil", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "Okei"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmMessage(_ titleMsg:String = "Bekreft", errorMsg:String = "Informasjon", cancelMsg:String = "Avbryt", confirmMsg: String = "Bekreft" ){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelMsg, style: UIAlertActionStyle.destructive, handler:nil))
        
        alertController.addAction(UIAlertAction(title:confirmMsg, style: UIAlertActionStyle.default, handler:  { action in
            self.userInfo?.goalPromille = Double(self.pickGoalTextField.text!)
            self.userInfo?.goalDate = self.getDate
            self.performSegue(withIdentifier: PrivacyViewController.segueId, sender: self.userInfo)
        }))
        self.present(alertController, animated: true, completion: { action in})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PrivacyViewController.segueId {
            if segue.destination is UINavigationController {
                let navController = segue.destination as! UINavigationController
                if navController.viewControllers.first is PrivacyViewController {
                    let destinationVC = navController.viewControllers.first as! PrivacyViewController
                    destinationVC.userInfo = sender as? UserInfo
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let happyImage = UIImage(named: "Happy-100")
        let sadImage = UIImage(named: "Sad-100")
        
        pickGoalTextField.text = "\(pickerData[row])"
        let goalPromille = Double(pickerData[row])!
        if(goalPromille == 0.0){
            textViewGoal.textColor = UIColor.white
            textViewGoal.text = ResourceList.introBacInfos[0]
            smileyImageView.image = happyImage
        }
        else if(goalPromille > 0.0 && goalPromille <= 0.3){
            textViewGoal.textColor = UIColor.white
            textViewGoal.text = ResourceList.introBacInfos[1]
            smileyImageView.image = happyImage
        }
        else if(goalPromille > 0.3 && goalPromille <= 0.6){
            textViewGoal.text = ResourceList.introBacInfos[2]
            smileyImageView.image = happyImage
        }
        else if(goalPromille > 0.6 && goalPromille <= 0.9){
            textViewGoal.text = ResourceList.introBacInfos[3]
            smileyImageView.image = happyImage
        }
        else if(goalPromille > 0.9 && goalPromille <= 1.2){
            textViewGoal.text = ResourceList.introBacInfos[4]
            smileyImageView.image = sadImage
        }
        else if(goalPromille > 1.2 && goalPromille <= 1.5){
            textViewGoal.text = ResourceList.introBacInfos[5]
             smileyImageView.image = sadImage
        }
        else if(goalPromille > 1.5 && goalPromille <= 1.7){
            textViewGoal.text = ResourceList.introBacInfos[6]
            smileyImageView.image = sadImage
        }
        else if(goalPromille > 1.7){
            textViewGoal.text = ResourceList.introBacInfos[7]
            smileyImageView.image = UIImage(named: "Vomited-100")
        }
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
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            
            let setAppColors = AppColors()
            pickerLabel?.textColor = setAppColors.textUnderHeadlinesColors()
        }
        pickerLabel?.text = pickerData[row]
        return pickerLabel!
    }
    
    func datePickerChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        getDate = sender.date
        let strDate = dateFormatter.string(from: sender.date)
        dateMessage = "Måldato: \(strDate)"
        datePickerTextField.text = strDate
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
        datePickerTextField.inputAccessoryView = keyboardToolbar
        pickGoalTextField.inputAccessoryView = keyboardToolbar
    }
}
