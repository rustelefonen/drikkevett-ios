import UIKit

class VelkommenViewController: UIViewController {
    
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var getStartedBtnOutlet: UIButton!
    @IBOutlet weak var guidanceBtnOutlet: UIButton!
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var getStartedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAppAlreadyLaunchedOnce()
        
        let setAppColors = AppColors()
        
        /*view.backgroundColor = setAppColors.mainBackgroundColor()
         let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         view.addSubview(blurEffectView)*/
        
        // PIC
        self.headPicImageView.layer.cornerRadius = 55
        self.headPicImageView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.2)
    }
    
    func timeToMoveOn() {
        self.performSegue(withIdentifier: "regCompletedSegue", sender: self) // tar deg til appen når du har logget inn
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            // HVIS REGISTRATION ER FULLFØRT:
            if(checkIfRegistrationWasCompleted() == true){
                //welcomeImageView.isHidden = false
                //imageShit.hidden = false
                let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(VelkommenViewController.timeToMoveOn), userInfo: nil, repeats: false)
            }
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    func checkIfRegistrationWasCompleted() -> Bool{
        let defaults = UserDefaults.standard
        // SESJON START
        if let bool : Bool = defaults.bool(forKey: "isFirstRegistrationCompleted") {
            print("\(bool)")
            return bool
        }
    }
}
