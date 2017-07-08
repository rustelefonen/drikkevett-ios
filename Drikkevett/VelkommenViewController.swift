import UIKit

class VelkommenViewController: UIViewController {
    
    @IBOutlet weak var guidanceBtnOutlet: UIButton!
    @IBOutlet weak var headPicImageView: UIImageView!
    var introPageViewController:IntroPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        headPicImageView.layer.cornerRadius = 55
        headPicImageView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GuidancePageViewController.segueId {
            if let destination = segue.destination as? GuidancePageViewController {
                destination.introPageViewController = introPageViewController
                
                let backItem = UIBarButtonItem()
                backItem.title = "Velkommen"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
}
