//
//  RootViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 20.06.2017.
//

import UIKit

class RootViewController: UIViewController {
    
    let tabBarId = "tabBarController"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userData = AppDelegate.getUserData()
                
        let id = userData == nil ? VelkommenViewController.storyboardId : tabBarId
        if let vc = storyboard?.instantiateViewController(withIdentifier: id){
            present(vc, animated: false, completion: nil)
        }
    }
}
