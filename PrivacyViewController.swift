//
//  PrivacyViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 20.06.2017.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    static let segueId = "privacySegue"
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
    }
    
    @IBAction func startApplication(_ sender: UIBarButtonItem) {
        let userDataDao = UserDataDao()
        let userData = userDataDao.createNewUserData()
        
        if userInfo == nil {return}
        
        userData.height = userInfo!.nickName
        userData.gender = userInfo!.gender! as NSNumber?
        userData.age = userInfo!.age! as NSNumber?
        userData.weight = userInfo!.weight! as NSNumber?
        
        userData.costsBeer = userInfo!.costsBeer! as NSNumber?
        userData.costsWine = userInfo!.costsWine! as NSNumber?
        userData.costsDrink = userInfo!.costsDrink! as NSNumber?
        userData.costsShot = userInfo!.costsShot! as NSNumber?
        
        userData.goalPromille = userInfo!.goalPromille! as NSNumber?
        userData.goalDate = userInfo?.goalDate
        
        userDataDao.save()
        
        isFirstRegistrationCompleted()
        isAppGuidanceDone()
        
        AppDelegate.initUserData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController"){
            present(vc, animated: true, completion: nil)
        }
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
