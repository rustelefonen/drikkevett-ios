import UIKit

class VelkommenViewController: UIViewController {
    
    static let storyboardId = "VelkommenViewController"
    
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var getStartedBtnOutlet: UIButton!
    @IBOutlet weak var guidanceBtnOutlet: UIButton!
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var getStartedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let setAppColors = AppColors()
        
        /*view.backgroundColor = setAppColors.mainBackgroundColor()
         let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         view.addSubview(blurEffectView)*/
        
        // PIC
        self.headPicImageView.layer.cornerRadius = 55
        self.headPicImageView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.2)
    }
}
