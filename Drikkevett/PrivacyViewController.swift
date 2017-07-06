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
    }
    
    @IBAction func startApplication(_ sender: UIBarButtonItem) {
        print("lol")
        print(introPageViewController)
        introPageViewController?.saveUser()
        
        
        /*
        if let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController"){
            present(vc, animated: true, completion: nil)
        }*/
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func isAppGuidanceDone()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnceGui"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnceGui")
            print("App launched first time")
            return false
        }
    }
    
    func isFirstRegistrationCompleted()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppRegistrationCompleted = defaults.string(forKey: "isFirstRegistrationCompleted"){
            print("Registration is completed")
            return true
        }else{
            defaults.set(true, forKey: "isFirstRegistrationCompleted")
            print("Registration is NOT completed")
            return false
        }
    }
    
}
