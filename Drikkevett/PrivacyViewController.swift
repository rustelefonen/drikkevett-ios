//
//  PrivacyViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 20.06.2017.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    static let segueId = "privacySegue"
    var introPageViewController:IntroPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        introPageViewController?.removeSwipeGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        introPageViewController?.restoreSwipeGesture()
    }
    
    @IBAction func startApplication(_ sender: UIBarButtonItem) {
        introPageViewController?.saveUser()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController"){
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
