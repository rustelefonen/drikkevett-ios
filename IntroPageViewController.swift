//
//  IntroPageViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 06.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var currentIndex: (() -> Int)?
    
    static let segueId = "introSegue"
    
    lazy var vcArr: [UIViewController] = {
        return [
            self.VCInstance(name: "intro_welcome"),
            self.VCInstance(name: "intro_costs"),
            self.VCInstance(name: "intro_userInfo")]
        }()
    
    private func VCInstance(name:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    
    override func viewDidLoad() {
        if let navController = vcArr[0] as? UINavigationController {
            if let welcomeVc = navController.viewControllers.first as? VelkommenViewController {
                welcomeVc.introPageViewController = self
            }
        }
        
        
        if let navController = vcArr[1] as? UINavigationController {
            if let costsVc = navController.viewControllers.first as? KostnaderViewController {
                costsVc.introPageViewController = self
            }
        }
        
        if let navController = vcArr[2] as? UINavigationController {
            if let informationVc = navController.viewControllers.first as? InformationViewController {
                informationVc.introPageViewController = self
            }
        }
        
        
        self.delegate = self
        self.dataSource = self
        
        currentIndex = {() -> Int in
            return self.vcArr.index(of: (self.viewControllers?.first)!)!
        }
        
        if let firstVC = vcArr.first {
            setViewControllers([firstVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        guard vcArr.count > previousIndex else {return nil}
        
        return vcArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController) else {return nil}
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < vcArr.count else {return nil}
        guard vcArr.count > nextIndex else {return nil}
        
        return vcArr[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = vcArr.index(of: firstViewController) else {return 0}
        return firstViewControllerIndex
    }
    
    func areCriticalFieldsValid() -> Bool {
        if vcArr[2] is UINavigationController {
            let navController = vcArr[2] as! UINavigationController
            
            if navController.viewControllers.first is InformationViewController {
                let informationVc = navController.viewControllers.first as! InformationViewController
                
                let gender = informationVc.genderInput.text
                var genderScore:Bool? = nil
                
                if gender == "Mann" || gender == "Kvinne" {genderScore = gender == "Mann"}
                let weight = Double(informationVc.weightInput.text!)
                let maxBac = Double(informationVc.maxBacInput.text!)
                
                if genderScore == nil || weight == nil || maxBac == nil {
                    errorMessage(errorMsg: "Alle felter må fylles ut!")
                    return false
                }
                
                if weight! >= 300.0 {
                    errorMessage(errorMsg: "Du valgte for tung vekt")
                    return false
                }
                else if weight! < 20.0 {
                    errorMessage(errorMsg: "Du valgte for lett vekt")
                    return false
                }
                
                if maxBac! < 0.1 || maxBac! > 2.0 {
                    errorMessage(errorMsg: "Du valgte et ugyldig promillemål")
                    return false
                }
            }
        }
        return true
    }
    
    func saveUser() {
        if vcArr[1] is UINavigationController && vcArr[2] is UINavigationController {
            let navController1 = vcArr[1] as! UINavigationController
            let navController2 = vcArr[2] as! UINavigationController
            
            if navController1.viewControllers.first is KostnaderViewController && navController2.viewControllers.first is InformationViewController {
                let costsVc = navController1.viewControllers.first as! KostnaderViewController
                let informationVc = navController2.viewControllers.first as! InformationViewController
                
                //Critical
                let gender = informationVc.genderInput.text
                var genderScore:Bool? = nil
                if gender == "Mann" || gender == "Kvinne" {genderScore = gender == "Mann"}
                
                let weight = Double(informationVc.weightInput.text!)
                let maxBac = Double(informationVc.maxBacInput.text!)
                
                if genderScore == nil || weight == nil || maxBac == nil {
                    errorMessage(errorMsg: "Alle felter må fylles ut!")
                    return
                }
                
                if (weight! >= 300.0) {
                    errorMessage(errorMsg: "Du valgte for tung vekt")
                    return
                }
                else if (weight! < 20.0) {
                    errorMessage(errorMsg: "Du valgte for lett vekt")
                    return
                }
                
                if maxBac! < 0.1 || maxBac! > 2.0 {
                    errorMessage(errorMsg: "Du valgte et ugyldig promillemål")
                    return
                }
                
                let userDataDao = UserDataDao()
                let userData = userDataDao.createNewUserData()
                
                userData.gender = genderScore! as NSNumber
                userData.weight = weight! as NSNumber
                userData.goalPromille = maxBac! as NSNumber
                
                //Not critical
                userData.height = informationVc.nicknameInput.text ?? ""
                userData.costsBeer = (Int(costsVc.beerInput.text!) ?? 60) as NSNumber
                userData.costsWine = (Int(costsVc.wineInput.text!) ?? 70) as NSNumber
                userData.costsDrink = (Int(costsVc.drinkInput.text!) ?? 100) as NSNumber
                userData.costsShot = (Int(costsVc.shotInput.text!) ?? 110) as NSNumber
                
                userDataDao.save()
                AppDelegate.initUserData()
            }
        }
    }
    
    func errorMessage(_ titleMsg:String = "Beklager,", errorMsg:String = "Noe gikk galt!", confirmMsg:String = "OK"){
        let alertController = UIAlertController(title: titleMsg, message:
            errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: confirmMsg, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeSwipeGesture(){
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
            if let lol = view as? UIPageControl {
                lol.isHidden = true
            }
        }
    }
    
    func restoreSwipeGesture() {
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
            if let lol = view as? UIPageControl {
                lol.isHidden = false
            }
        }
    }
}
