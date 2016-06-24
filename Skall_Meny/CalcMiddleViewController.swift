//  CalcMiddleViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 08.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class CalcMiddleViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageUnits: NSArray!
    var pageImages: NSArray!
    
    var setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // COLORS OG FONTS
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        /*
        self.pageUnits = NSArray(objects: "Øl", "Vin", "Drink", "Shot")
        self.pageImages = NSArray(objects: "Øl", "Vin", "Drink", "Shot")
        */
        self.pageUnits = NSArray(objects: "LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS")
        self.pageImages = NSArray(objects: "LønningsPils", "AlternativVIN", "AlternativDRINK", "1000SHOTS")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as CalcSwipeViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        var font = UIFont()
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 90)
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 10)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
        }
        
        
        //self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(index: Int) -> CalcSwipeViewController
    {
        if ((self.pageUnits.count == 0) || (index >= self.pageUnits.count)) {
            return CalcSwipeViewController()
        }
        
        let vc: CalcSwipeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CalcSwipeViewController") as! CalcSwipeViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.unitTitle = self.pageUnits[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as! CalcSwipeViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        print(index)
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! CalcSwipeViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageUnits.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageUnits.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
