//
//  TipsPageViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 05.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class TipsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var vcArr: [DayAfterViewController] = {
        return [
            self.VCInstance(name: "dayAfterContent"),
            self.VCInstance(name: "dayAfterContent"),
            self.VCInstance(name: "dayAfterContent")]
        }() as! [DayAfterViewController]
    
    private func VCInstance(name:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    
    override func viewDidLoad() {
        self.delegate = self
        self.dataSource = self
        
        for i in 0..<vcArr.count {
            let vc = vcArr[i]
            vc.titleValue = ResourceList.tipsTitles[i]
            vc.imageValue = ResourceList.tipsImages[i]
            vc.textValue = ResourceList.tipsTexts[i]
        }
        
        if let firstVC = vcArr.first {
            setViewControllers([firstVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController as! DayAfterViewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        guard vcArr.count > previousIndex else {return nil}
        
        return vcArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController as! DayAfterViewController) else {return nil}
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
            let firstViewControllerIndex = vcArr.index(of: firstViewController as! DayAfterViewController) else {return 0}
        return firstViewControllerIndex
    }
    
}
