//  SecondViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class SecondViewController: UIViewController {
    // Database/Core Data kommunikasjon
    let moc = DataController().managedObjectContext

    // SET COLORS
    var setAppColors = AppColors()
    
    // Brain 
    let brain = SkallMenyBrain()
    
    // LABELS
    @IBOutlet weak var numberOfBeersLabel: UILabel!
    @IBOutlet weak var numberOfWinesLabel: UILabel!
    @IBOutlet weak var numberOfDrinksLabel: UILabel!
    @IBOutlet weak var numberOfShots: UILabel!
    @IBOutlet weak var promilleLabel: UILabel!
    @IBOutlet weak var numberOfHours: UILabel!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var titleBeerLabel: UILabel!
    @IBOutlet weak var titleWineLabel: UILabel!
    @IBOutlet weak var titleDrinkLabel: UILabel!
    @IBOutlet weak var titleShotLabel: UILabel!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var textQuotes: UILabel!
    
    // ARROWS
    @IBOutlet weak var arrowLeftImageView: UIImageView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    // TEST SWIPE
    var fetchBeerFromSwipe: String = ""
    var fetchWineFromSwipe: String = ""
    var fetchDrinkFromSwipe: String = ""
    var fetchShotFromSwipe: String = ""
    var fetchUnitType: String = ""
    
    // ØL COUNT, VIN COUNT, DRINK COUNT OG SHOT COUNT
    var beerCount = 0.0
    var wineCount = 0.0
    var drinkCount = 0.0
    var shotCount = 0.0
    
    // ANTALL TIMER
    var numHours = 1.0
    
    // GET GENDER AND WEIGHT FROM CORE DATA
    var getGender : Bool = true
    var getWeight : Double! = 0.0
    
    // ADD MINUS BUTTON OUTLETS
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nPromillekalkulator Loaded...")
        secondViewFontsAndColors()
        isViewLunchedBefore()
    }
    
    func secondViewFontsAndColors(){
        // SETT COLORS OG FONTS
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // PROMILLE LABEL
        self.promilleLabel.textColor = setAppColors.promilleLabelColors()
        self.promilleLabel.font = setAppColors.promilleLabelFonts()
        
        // BUTTON FONT
        self.addButtonOutlet.titleLabel!.font = setAppColors.buttonFonts(20)
        self.addButtonOutlet.titleLabel!.text = "Legg til"
        self.minusButtonOutlet.titleLabel!.font = setAppColors.buttonFonts(20)
        self.minusButtonOutlet.titleLabel!.text = "Fjern"
        
        // LABEL COLORS AND FONT
        self.numberOfHours.textColor = setAppColors.textUnderHeadlinesColors()
        self.numberOfHours.font = setAppColors.textUnderHeadlinesFonts(15)
        self.numberOfHours.text = "Promillen om 1 time"
        self.numberOfBeersLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.numberOfBeersLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        self.numberOfWinesLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.numberOfWinesLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        self.numberOfDrinksLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.numberOfDrinksLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        self.numberOfShots.textColor = setAppColors.textUnderHeadlinesColors()
        self.numberOfShots.font = setAppColors.textUnderHeadlinesFonts(30)
        
        // TITLE LABEL
        self.titleBeerLabel.textColor = setAppColors.textHeadlinesColors()
        self.titleBeerLabel.font = setAppColors.textHeadlinesFonts(14)
        self.titleWineLabel.textColor = setAppColors.textHeadlinesColors()
        self.titleWineLabel.font = setAppColors.textHeadlinesFonts(14)
        self.titleDrinkLabel.textColor = setAppColors.textHeadlinesColors()
        self.titleDrinkLabel.font = setAppColors.textHeadlinesFonts(14)
        self.titleShotLabel.textColor = setAppColors.textHeadlinesColors()
        self.titleShotLabel.font = setAppColors.textHeadlinesFonts(14)
        
        // TEXT QUOTES
        self.textQuotes.font = setAppColors.setTextQuoteFont(15)
        self.textQuotes.textColor = setAppColors.textQuoteColors()
        
        // BUTTONS
        self.minusButtonOutlet.setTitle("Fjern", forState: UIControlState.Normal)
        self.addButtonOutlet.setTitle("Legg til", forState: UIControlState.Normal)
        
        setButtonsRounded(setAppColors.roundedCorners())
        //var font = UIFont()
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, 35.0)
            
            // BUTTONS
            self.minusButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -45.0)
            self.addButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -45.0)
            
            // STATS-NUMBERS
            self.numberOfBeersLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0)
            self.numberOfWinesLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -60.0)
            self.numberOfDrinksLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0)
            self.numberOfShots.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0)
            
            // STATS-TITLES
            self.titleBeerLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -70.0)
            self.titleWineLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -70.0)
            self.titleDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -70.0)
            self.titleShotLabel.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -70.0)
            
            // TEXT QUOTES
            self.textQuotes.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -24.0)
            self.promilleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -12.0)
            self.textQuotes.font = setAppColors.setTextQuoteFont(12)
            self.promilleLabel.font = setAppColors.textHeadlinesFonts(60)
            
            // SLIDER OG SLIDER TEXT
            self.sliderOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            self.numberOfHours.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            
            // FONTS
            setFontsOnConstStats(20, titleStatsFont: 12)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, 25.0)
            
            // BUTTONS
            self.minusButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
            self.addButtonOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
            
            // STATS-NUMBERS
            let statsNumbersYVal : CGFloat = -33.0
            self.numberOfBeersLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, statsNumbersYVal)
            self.numberOfWinesLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, statsNumbersYVal)
            self.numberOfDrinksLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, statsNumbersYVal)
            self.numberOfShots.transform = CGAffineTransformTranslate(self.view.transform, -25.0, statsNumbersYVal)
            
            // STATS-TITLES
            let statsTitlesYval : CGFloat = -40.0
            self.titleBeerLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, statsTitlesYval)
            self.titleWineLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, statsTitlesYval)
            self.titleDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, statsTitlesYval)
            self.titleShotLabel.transform = CGAffineTransformTranslate(self.view.transform, -25.0, statsTitlesYval)
            
            // FONTS
            setFontsOnConstStats(25, titleStatsFont: 15)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            
        }
    }
    
    func setFontsOnConstStats(statsFont: CGFloat, titleStatsFont: CGFloat){
        // STATS: (20)
        self.numberOfBeersLabel.font = setAppColors.textUnderHeadlinesFonts(statsFont)
        self.numberOfWinesLabel.font = setAppColors.textUnderHeadlinesFonts(statsFont)
        self.numberOfDrinksLabel.font = setAppColors.textUnderHeadlinesFonts(statsFont)
        self.numberOfShots.font = setAppColors.textUnderHeadlinesFonts(statsFont)
        // TITLE STATS: (12)
        self.titleBeerLabel.font = setAppColors.textHeadlinesFonts(titleStatsFont)
        self.titleWineLabel.font = setAppColors.textHeadlinesFonts(titleStatsFont)
        self.titleDrinkLabel.font = setAppColors.textHeadlinesFonts(titleStatsFont)
        self.titleShotLabel.font = setAppColors.textHeadlinesFonts(titleStatsFont)
    }
    
    func setButtonsRounded(turnOffOn: Bool){
        if(turnOffOn == true){
            // PLUSS BTN
            addButtonOutlet.layer.cornerRadius = 25;
            addButtonOutlet.layer.borderWidth = 0.5;
            addButtonOutlet.layer.borderColor = UIColor.whiteColor().CGColor
            
            // MINUS BTN
            minusButtonOutlet.layer.cornerRadius = 25;
            minusButtonOutlet.layer.borderWidth = 0.5;
            minusButtonOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func resetProps(sender: AnyObject) {
        beerCount = 0
        let formatBeer = Int(beerCount)
        self.numberOfBeersLabel.text = "\(formatBeer)"
        wineCount = 0
        let formatWine = Int(wineCount)
        self.numberOfWinesLabel.text = "\(formatWine)"
        drinkCount = 0
        let formatDrink = Int(drinkCount)
        self.numberOfDrinksLabel.text = "\(formatDrink)"
        shotCount = 0
        let formatShot = Int(shotCount)
        self.numberOfShots.text = "\(formatShot)"
        self.promilleLabel.text = "0.00"
        self.textQuotes.text = "Kalkuler Promille"
        self.promilleLabel.textColor = UIColor.whiteColor()
        self.textQuotes.textColor = UIColor.whiteColor()
        
        sliderOutlet.value = 1
        numHours = 1
        self.numberOfHours.text = "Promillen om \(Int(sliderOutlet.value).description) Time"
    }
    
    func totalPromille() -> Double{
        fetchUserData()
        var promille = ""
        var totalSum = 0.0
        
        let totalGrams = brain.countingGrams(beerCount, wineUnits: wineCount, drinkUnits: drinkCount, shotUnits: shotCount)
        totalSum += brain.calculatePromille(getGender, weight: getWeight, grams: totalGrams, timer: numHours)
        print(totalSum)
        
        promille = String(format: "%.2f", totalSum)
        self.promilleLabel.text = "\(promille)"
        let formatBeer = Int(beerCount)
        self.numberOfBeersLabel.text = "\(formatBeer)"
        let formatWine = Int(wineCount)
        self.numberOfWinesLabel.text = "\(formatWine)"
        let formatDrink = Int(drinkCount)
        self.numberOfDrinksLabel.text = "\(formatDrink)"
        let formatShot = Int(shotCount)
        self.numberOfShots.text = "\(formatShot)"
        
        self.textQuotes.text = brain.setTextQuote(totalSum)
        self.promilleLabel.textColor = brain.setTextQuoteColor(totalSum)
        self.textQuotes.textColor = brain.setTextQuoteColor(totalSum)
        
        /*
        // HVA SKAL DET STÅ I TEKST FELTENE:
        if(totalSum >= 0.0 && totalSum < 0.4){
            self.textQuotes.text = "Kos deg!"
            self.promilleLabel.textColor = UIColor.whiteColor()
            self.textQuotes.textColor = UIColor.whiteColor()
        }
        // LYKKE PROMILLE
        if(totalSum >= 0.4 && totalSum < 0.8){
            self.textQuotes.text = "Lykkepromille"
            self.promilleLabel.textColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
            self.textQuotes.textColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        }
        if(totalSum >= 0.8 && totalSum < 1.0){
            self.textQuotes.text = "Du blir mer kritikkløs og risikovillig"
            self.promilleLabel.textColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
            self.textQuotes.textColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
        }
        if(totalSum >= 1.0 && totalSum < 1.2){
            self.textQuotes.text = "Balansen blir dårligere"
            self.promilleLabel.textColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
            self.textQuotes.textColor = UIColor(red: 255/255.0, green: 180/255.0, blue: 10/255.0, alpha: 1.0)
        }
        if(totalSum >= 1.2 && totalSum < 1.4){
            self.textQuotes.text = "Talen blir snøvlete og \nkontroll på bevegelser forverres"
            self.promilleLabel.textColor = UIColor.orangeColor()
            self.textQuotes.textColor = UIColor.orangeColor()
        }
        if(totalSum >= 1.4 && totalSum < 1.8){
            self.textQuotes.text = "Man blir trøtt, sløv og \nkan bli kvalm"
            self.promilleLabel.textColor = UIColor.orangeColor()
            self.textQuotes.textColor = UIColor.orangeColor()
        }
        if(totalSum >= 1.8 && totalSum < 3.0){
            self.textQuotes.text = "Hukommelsen sliter!"
            self.promilleLabel.textColor = UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
            self.textQuotes.textColor = UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
        }
        if(totalSum >= 3.0){
            self.textQuotes.text = "Svært høy promille! \nMan kan bli bevistløs!"
            self.promilleLabel.textColor = UIColor.redColor()
            self.textQuotes.textColor = UIColor.redColor()
        }
        */
        return totalSum
    }
    
    func fetchUserData(){
        var userData = [UserData]()
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGender = item.gender! as Bool
                getWeight = item.weight! as Double
                print("UserData PromilleKalkulator Fetched...")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    @IBAction func minusUnitButton(sender: AnyObject) {
        getUnitValues()
        if(fetchUnitType == "Beer"){
            beerCount -= 1
            if(beerCount <= 0) {
                beerCount = 0
            }
        }
        if(fetchUnitType == "Wine"){
            wineCount -= 1
            if(wineCount <= 0) {
                wineCount = 0
            }
        }
        if(fetchUnitType == "Drink"){
            drinkCount -= 1
            if(drinkCount <= 0) {
                drinkCount = 0
            }
        }
        if(fetchUnitType == "Shot"){
            shotCount -= 1
            if(shotCount <= 0) {
                shotCount = 0
            }
        }
        totalPromille()
    }
    
    @IBAction func addUnitButton(sender: AnyObject) {
        getUnitValues()
        if(fetchUnitType == "Beer"){
            beerCount += 1
            if(beerCount >= 20) {
                beerCount = 20
            }
        }
        if(fetchUnitType == "Wine"){
            wineCount += 1
            if(wineCount >= 20) {
                wineCount = 20
            }
        }
        if(fetchUnitType == "Drink"){
            drinkCount += 1
            if(drinkCount >= 20) {
                drinkCount = 20
            }
        }
        if(fetchUnitType == "Shot"){
            shotCount += 1
            if(shotCount >= 20) {
                shotCount = 20
            }
        }
        totalPromille()
    }
    
    @IBAction func slider(sender: UISlider) {
        var promille = ""
        var hoursInt = 0
        let tempHours = Int(sender.value).description
        let valueOfStepper = Int(sender.value).description
        if let myNumber = NSNumberFormatter().numberFromString(valueOfStepper) {
            numHours = myNumber.doubleValue
            hoursInt = Int(numHours)
            if(numHours == 1){
                self.numberOfHours.text = "Promillen om \(hoursInt) Time"
            } else {
                self.numberOfHours.text = "Promillen om \(hoursInt) Timer"
            }
        }
        promille = String(format: "%.2f", totalPromille())
        self.promilleLabel.text = "\(promille)"
    }

    // FØRSTE GANGEN SKAL TEXTVIEWET VISE : (swipe for å velge enhet ) 
    func isViewLunchedBefore()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isViewLunchedBefore"){
            print("View already launched")
            // HVIS REGISTRATION ER FULLFØRT:

            return true
        }else{
            defaults.setBool(true, forKey: "isViewLunchedBefore")
            print("View first time")
            self.textQuotes.text = "Swipe for å velge enhet"
            return false
        }
    }
    
    enum defaultKeys {
        static let secondBeerKey = "secondBeerKey"
        static let secondWineKey = "secondWineKey"
        static let secondDrinkKey = "secondDrinkKey"
        static let secondShotKey = "secondShotKey"
        static let unitTypeKeys = "unitTypeKey"
    }
    
    func storeUnitValues(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(fetchBeerFromSwipe, forKey: defaultKeys.secondBeerKey)
        defaults.setObject(fetchWineFromSwipe, forKey: defaultKeys.secondWineKey)
        defaults.setObject(fetchDrinkFromSwipe, forKey: defaultKeys.secondDrinkKey)
        defaults.setObject(fetchShotFromSwipe, forKey: defaultKeys.secondShotKey)
        defaults.setObject(fetchUnitType, forKey: defaultKeys.unitTypeKeys)
        defaults.synchronize()
    }
    
    func getUnitValues(){ // GETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let beer : AnyObject = defaults.objectForKey(defaultKeys.secondBeerKey) {
            fetchBeerFromSwipe = beer as! String
        }
        if let wine : AnyObject = defaults.objectForKey(defaultKeys.secondWineKey) {
            fetchWineFromSwipe = wine as! String
        }
        if let drink : AnyObject = defaults.objectForKey(defaultKeys.secondDrinkKey) {
            fetchDrinkFromSwipe = drink as! String
        }
        if let shot : AnyObject = defaults.objectForKey(defaultKeys.secondShotKey) {
            fetchShotFromSwipe = shot as! String
        }
        if let unitType : AnyObject = defaults.objectForKey(defaultKeys.unitTypeKeys) {
            fetchUnitType = unitType as! String
        }
        print("getUnitValues gotten...")
    }
}

extension UIImageView{
    
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    
}