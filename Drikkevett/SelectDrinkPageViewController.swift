//
//  SelectDrinkPageViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class SelectDrinkPageViewController :UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    static let segueId = "selectDrinkSegue"
    static let planPartySegueId = "planPartySelectUnit"
    static let partySegueId = "partySelectUnit"
    static let afterRegisterSegueId = "afterRegisterSegue"
    
    var currentIndex: (() -> Int)?
    
    lazy var vcArr: [myScrollVC] = {
        return [
            self.VCInstance(name: "SelectedDrink"),
            self.VCInstance(name: "SelectedDrink"),
            self.VCInstance(name: "SelectedDrink"),
            self.VCInstance(name: "SelectedDrink")]
    }() as! [myScrollVC]
    
    private func VCInstance(name:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    
    override func viewDidLoad() {
        self.delegate = self
        self.dataSource = self
        
        vcArr[0].image = UIImage(named: "LønningsPils")
        vcArr[1].image = UIImage(named: "AlternativVIN")
        vcArr[2].image = UIImage(named: "AlternativDRINK")
        vcArr[3].image = UIImage(named: "1000SHOTS")
        
        currentIndex = {() -> Int in
            return self.vcArr.index(of: self.viewControllers?.first as! myScrollVC)!
        }
        
        if let firstVC = vcArr.first {
            setViewControllers([firstVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    func lol() -> Int{
        if let vc = childViewControllers.first as? myScrollVC {
            return vcArr.index(of: vc)!
        }
        return -1
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController as! myScrollVC) else {return nil}
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {return vcArr.last}
        guard vcArr.count > previousIndex else {return nil}
        
        return vcArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController as! myScrollVC) else {return nil}
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < vcArr.count else {return vcArr.first}
        guard vcArr.count > nextIndex else {return nil}
        
        return vcArr[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = vcArr.index(of: firstViewController as! myScrollVC) else {return 0}
        return firstViewControllerIndex
    }
}
