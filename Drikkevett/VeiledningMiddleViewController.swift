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
            "Med funksjonen dagen derpå kan du se oversikt over forrige kvelds aktiviteter. Du kan også etterregistrere enheter. Tips-knappen fører deg til tips til dagen derpå.",
            "Historikken viser en oversikt over alle kveldene du har registrert med applikasjonen. Klikk på en enkelt kveld for mer detaljert data om kvelden din.",
            "For kvinner:\nAlkohol i gram / (kroppsvekten i kg x 0,60) – (0,15 x timer fra drikkestart) = promille. \nFor menn: \nAlkohol i gram / (kroppsvekten i kg x 0,70) – (0,15 x timer fra drikkestart) = promille.",
            "Øl: 0,5 l (4,5 % alkohol)\nVin: 1,2 dl (13 % alkohol)\nDrink: 4 cl (40 % alkohol)\nShot: 4 cl (40 % alkohol)"
        )
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "VeiledningPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as VeiledningInnholdViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(_ index: Int) -> VeiledningInnholdViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return VeiledningInnholdViewController()
        }
        
        let vc: VeiledningInnholdViewController = self.storyboard?.instantiateViewController(withIdentifier: "VeiledningInnholdViewController") as! VeiledningInnholdViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.textViewString = self.pageTextView[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

    @IBAction func skipBackButton(_ sender: AnyObject) {
        let getButtonTitle = self.underGuidanceTitleBtn.currentTitle!
        if(getButtonTitle == "Tilbake"){
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            navigationController?.popViewController(animated: true)
        }
        if(getButtonTitle == "Sett i gang"){
            self.performSegue(withIdentifier: "showUserInfo", sender: self)
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnceGui"){
            print("App already launched")
            // GJØR TING NÅR APPEN HAR LUNCHA
            // SETTE TITTELEN PÅ KNAPPEN TIL "TILBAKE"
            underGuidanceTitleBtn.setTitle("Tilbake", for: UIControlState())
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnceGui")
            print("App launched first time")
            // APPEN HAR IKKE LUNCHA GJØR TING
            // SETTE TITTELEN PÅ KNAPPEN TIL "SETT I GANG"
            underGuidanceTitleBtn.setTitle("Sett i gang", for: UIControlState())
            return false
        }
    }
}
