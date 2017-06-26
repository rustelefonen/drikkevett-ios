//
//  SelectDrinkPageViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class SelectDrinkPageViewController :UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var myVCs:[SelectedDrinkViewController] = []
    
    override func viewDidLoad() {
        myVCs.append(SelectedDrinkViewController())
        myVCs.append(SelectedDrinkViewController())
        myVCs.append(SelectedDrinkViewController())
        myVCs.append(SelectedDrinkViewController())
        
        setViewControllers([myVCs[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return SelectedDrinkViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return SelectedDrinkViewController()
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return myVCs.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}

