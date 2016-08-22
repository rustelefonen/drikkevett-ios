//  VeiledningMiddleViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 09.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit

class VeiledningMiddleViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet weak var underGuidanceTitleBtn: UIButton!
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var pageTextView: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAppAlreadyLaunchedOnce()
        self.pageTitles = NSArray(objects: "Hjem", "Promillekalkulator", "Planlegg Kvelden", "Dagen Derpå", "Historikk", "Utregning", "Enheter")
        self.pageImages = NSArray(objects: "hjemSkjermOmrisse", "promilleKalkOmrisse", "iphone omrisse", "dagenderpOmrisse", "historikkOmrisse", "Math-100", "Unis")
        self.pageTextView = NSArray(objects:
            "På hjemskjermen din vil du ha muligheten til å se hvordan du ligger an med målene dine, sjekke statistikk over dine kvelder og sette et eventuelt profilbilde",
            "Promillekalkulatoren gjør at du kan regne ut hvilken promille du har. Du kan også justere antall timer som har gått siden alkoholen ble konsumert, og finne ut hva promillen vil være etter en viss tid. Promillekalkulatoren gir en indikasjon på din promille, og skal ikke brukes som en utregning for når du kan kjøre!",
            "Denne funksjonen skal hjelpe deg å planlegge kvelden din. Du skal kunne legge inn antall enheter du planlegger å drikke for så å \"drikk\" dem underveis",
            "Med funkjsonen dagen derpå kan du se oversikt over forrige kvelds aktiviteter. Du kan også etterregistrere enheter. Tips-knappen fører deg til tips til dagen derpå.",
            "Historikken viser en oversikt over alle kveldene du har registrert med applikasjonen. Klikk på en enkelt kveld for mer detaljert data om kvelden din.",
            "For kvinner:\nAlkohol i gram / (kroppsvekten i kg x 0,60) – (0,15 x timer fra drikkestart) = promille. \nFor menn: \nAlkohol i gram / (kroppsvekten i kg x 0,70) – (0,15 x timer fra drikkestart) = promille.",
            "Øl: 0.5 dl\nVin: 12 cl\nDrink: 4 cl\nShot: 4 cl"
        )
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VeiledningPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as VeiledningInnholdViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(index: Int) -> VeiledningInnholdViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return VeiledningInnholdViewController()
        }
        
        let vc: VeiledningInnholdViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VeiledningInnholdViewController") as! VeiledningInnholdViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.textViewString = self.pageTextView[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        let vc = viewController as! VeiledningInnholdViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! VeiledningInnholdViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        if (index == self.pageTitles.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

    @IBAction func skipBackButton(sender: AnyObject) {
        let getButtonTitle = self.underGuidanceTitleBtn.currentTitle!
        if(getButtonTitle == "Tilbake"){
            self.navigationController?.navigationBarHidden = false
            self.tabBarController?.tabBar.hidden = false
            navigationController?.popViewControllerAnimated(true)
        }
        if(getButtonTitle == "Sett i gang"){
            self.performSegueWithIdentifier("showUserInfo", sender: self)
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnceGui"){
            print("App already launched")
            // GJØR TING NÅR APPEN HAR LUNCHA
            // SETTE TITTELEN PÅ KNAPPEN TIL "TILBAKE"
            underGuidanceTitleBtn.setTitle("Tilbake", forState: UIControlState.Normal)
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnceGui")
            print("App launched first time")
            // APPEN HAR IKKE LUNCHA GJØR TING
            // SETTE TITTELEN PÅ KNAPPEN TIL "SETT I GANG"
            underGuidanceTitleBtn.setTitle("Sett i gang", forState: UIControlState.Normal)
            return false
        }
    }
}