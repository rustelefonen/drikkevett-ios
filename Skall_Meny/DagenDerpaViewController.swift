//
//  ViewController.swift
//  UIPageViewController
//
//  Created by PJ Vea on 3/27/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.
//

import UIKit
import CoreData

class DagenDerpaViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageImages: NSArray!
    var pageTitles: NSArray!
    var pageTexts: NSArray!
    
    // set colors
    var setAppColors = AppColors()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // COLORS AND FONTS
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        self.pageImages = NSArray(objects: "Bed", "Idea-100", "Wink")
        self.pageTitles = NSArray(objects:
            "Dagen Derpå",
            "Råd for å unngå fyllesyke",
            "Ikke sov på stigende rus"
        )
        self.pageTexts = NSArray(objects:
            "Hodepine, kvalme, mageforstyrrelser og uro (fylleangst), er vanlige symptomer på bakrus.  Bakrus eller fyllesyke kan forklares som en slags abstinensstilstand der hjernen sliter med å venne seg til at alkoholen blir borte. Dehydrering, søvnmangel, lite matinntak, og allergi mot noen av tilsetningsstoffene i alkoholen, har skylden for hvordan formen din er dagen derpå. \n\nEr skaden allerede skjedd, er det dessverre få vidunderkurer som hjelper.",
            "De fleste rådene for å unngå fyllesyke, er råd som ikke har dokumentert effekt. Likevel er det enkelte grep noen føler letter plagene. Å drikke vann eller annen alkoholfri veske, er viktig, siden kroppen din er uttørket. Å spise et godt måltid, kan også hjelpe. Det kan også hjelpe å sove. Det beste rådet mot fyllesyke er likevel å ha drikkevett dagen før. ",
            "Det anbefales å slutte å drikke i god tid før du skal legge deg for å lindre symptomer på bakrus dagen derpå. Da er sjansene for at du får en roligere søvn større. Det kan dessuten være farlig å legge seg på stigende rus, om promillen er høy."
        )
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as InnholdViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 26)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> InnholdViewController
    {
        if ((self.pageImages.count == 0) || (index >= self.pageImages.count)) {
            return InnholdViewController()
        }
        
        let vc: InnholdViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InnholdViewController") as! InnholdViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleString = self.pageTitles[index] as! String
        vc.textString = self.pageTexts[index] as! String
        vc.pageIndex = index
        
        return vc
        
        
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        let vc = viewController as! InnholdViewController
        var index = vc.pageIndex as Int
        
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! InnholdViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        if (index == self.pageImages.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}