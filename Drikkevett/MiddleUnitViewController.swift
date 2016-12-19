//  MiddleUnitViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 04.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class MiddleUnitViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageButtons: NSArray!
    var pageImages: NSArray!
    var currentPageIndex: Int = 0
    
    var setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // COLORS OG FONTS
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        self.pageButtons = NSArray(objects: "LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS")
        self.pageImages = NSArray(objects: "LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS")
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirstPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0)! as ChooseUnitViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        // CONSTRAINTS
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 90)
            
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 60)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 10)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
        }
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(_ index: Int) -> ChooseUnitViewController?
    {
        //currentPageIndex = index
        //print("Current page index: \(currentPageIndex)")
        if ((self.pageButtons.count == 0) || (index >= self.pageButtons.count)) {
            return ChooseUnitViewController()
        }
        
        let vc: ChooseUnitViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseUnitViewController") as! ChooseUnitViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleButton = self.pageButtons[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        
        let vc = viewController as! ChooseUnitViewController
        var index = vc.pageIndex as Int
        
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ChooseUnitViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        if (index == self.pageButtons.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return self.pageButtons.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
