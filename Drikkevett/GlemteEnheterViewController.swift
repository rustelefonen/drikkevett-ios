//
//  GlemteEnheterViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 17.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData
import Charts

class GlemteEnheterViewController: UIViewController, ChartViewDelegate, UITextFieldDelegate {
    ////////////////////////////////////////////////////////////////////////
    //                        ATTRIBUTTER (0001)                          //
    ////////////////////////////////////////////////////////////////////////
    //@IBOutlet weak var backgroundYesterdaysStats: UIView!
    //@IBOutlet weak var backgorundYestExper: UIView!
    
    // STATS
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var wineLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var shotLabel: UILabel!
    
    @IBOutlet weak var yesterdaysCosts: UILabel!
    @IBOutlet weak var yesterdaysHighestProm: UILabel!
    @IBOutlet weak var currentPromille: UILabel!
    @IBOutlet weak var beerOutletButton: UIButton!
    @IBOutlet weak var wineOutletButton: UIButton!
    @IBOutlet weak var drinkOutletButton: UIButton!
    @IBOutlet weak var shotOutletButton: UIButton!
    @IBOutlet weak var yestCostTitleLabel: UILabel!
    @IBOutlet weak var yestHighestPromTitleLabel: UILabel!
    @IBOutlet weak var currPromTitleLabel: UILabel!
    @IBOutlet weak var endDayAfterButtonOutlet: UIButton!
    
    /* ADD TO NEW BUILD */
    @IBOutlet weak var overallTitle: UILabel!
    @IBOutlet weak var overallSubtitle: UILabel!
    
    // X - IMG - BTN
    @IBOutlet weak var xImageBtn: UIImageView!
    
    // PIE CHART VIEW
    @IBOutlet weak var pieChartView: PieChartView!
    
    //--------------------   MODEL/DATABASE/COLORS    ---------------------\\
    let moc = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    let brain = SkallMenyBrain()
    var setAppColors = AppColors()
    
    //--------------------------   VARIABLER   -----------------------------\\
    
    // ARRAYS SOM OPPDATERER HØYSTE PROMILLE OG CURRENT PROMILLE DAGENDERPÅ
    var beerArray : [NSDate] = [NSDate]()
    var wineArray : [NSDate] = [NSDate]()
    var drinkArray : [NSDate] = [NSDate]()
    var shotArray : [NSDate] = [NSDate]()
    
    // Check if session is started
    var updateStamp : NSDate = NSDate()
    
    // GET GENDER, WEIGHT OG KOSTNADER FROM CORE DATA
    var getGender : Bool = true
    var getWeight : Double! = 0.0
    var getNickName : String!
    
    // Start tidspunkt dagenderpå sesjon
    var endDagenDerpaStamp : NSDate = NSDate()
    
    // endOf og startOf Planlegg kvelden sesjon
    var startOfPlanPartyStamp : NSDate = NSDate()
    var endOfPlanPartyStamp : NSDate = NSDate()
    
    var checkIfLatestHistorikkIsFetched : NSDate = NSDate()
    
    // hente sessionsnummer
    var fetchSessionNumber : Int = 0
    
    // Antall ganger appdelegate timeren har kjørt
    var countCounter : Int = 0
    
    // STORE DEFAULT VALUES
    var unitsOfBeers = 0
    var unitsOfWines = 0
    var unitsOfDrink = 0
    var unitsOfShots = 0
    var yestCost = 0
    var yestHighProm = 0.0
    var currentPromilleNow = 0.0
    var totalUnits = 0
    
    
    // Antall ganger updateVisuals har kjørt
    var countVisuals = 0
    
    // Er dagenderpå i gang eller ei
    var isDayAfterRunning = false

    // pluss / minus
    var goalReached = 6
    var overGoal = 3
    
    let months = [String]()
    
    // SLICE COLORS
    var beerSliceColor = UIColor()
    var wineSliceColor = UIColor()
    var drinkSliceColor = UIColor()
    var shotSliceColor = UIColor()
    
    // VISUALS TIMER
    var visualsNSTimer = NSTimer()
    
    var textFieldTest = UITextField()
    
    // planlagte enheter
    var plannedNumberOfUnits = 0
    
    // makspromille
    var getMaxPromille : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsDagenDerpa()

        print("Is blarhar: \(isDayAfterRunning)")
        
        getDefaultValues()
        getIsDayAfterRunning()
        
        // SETT INN DENNE METODEN I VIEW DID LOAD:
        visualsDayAfterStudio()
        // SLUTT
        
        visualsCurrentPromille()
        visualsTimer()
        currentPromilleTimer()
        
        // DELEGATE
        pieChartView.delegate = self
        
        // PIE CHART:
        let months = ["", "", "", ""]
        let unitsSold = [Double(unitsOfBeers), Double(unitsOfWines), Double(unitsOfDrink), Double(unitsOfShots)]
        
        // DUMMY PIECHART DATA
        // unitsSold = [12.6, 4.6, 2.9, 10.0]
        
        setChart(months, values: unitsSold)
        
        
        // ALT DETTE MED NOTIFICATION CENTER MÅ INN
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GlemteEnheterViewController.visualsDayAfterStudio), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        
        // CONSTRAINTS
        setConstraints()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /* METODEN UNDER MÅ IMPLEMENTERES*/
    
    func visualsTimer(){
        visualsNSTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(GlemteEnheterViewController.visualsDayAfterStudio), userInfo: nil, repeats: true)
    }
    
    func visualsDayAfterStudio(){
        if(isDayAfterRunning == true){
            visualsOnDayAfterRunning()
            visualsCurrentPromille()
        }
        if(isDayAfterRunning == false){
            visualsOnDayAfterNotRunning()
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(unitsOfBeers), Double(unitsOfWines), Double(unitsOfDrink), Double(unitsOfShots)]
            setChart(months, values: unitsSold)
        }
    }
    
    /* METODEN OVER MÅ IMPLEMENTERES*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.hidden = false
        
        updatePromilleAppDelegate()
        setColorsAndFontsDagenDerpa()
        getDefaultValues()
        getIsDayAfterRunning()
        
        if(isDayAfterRunning == true){
            visualsOnDayAfterRunning()
            visualsCurrentPromille()
        }
        if(isDayAfterRunning == false){
            visualsOnDayAfterNotRunning()
        }
        
        // PIE CHART:
        let months = ["", "", "", ""]
        let unitsSold = [Double(unitsOfBeers), Double(unitsOfWines), Double(unitsOfDrink), Double(unitsOfShots)]
        setChart(months, values: unitsSold)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func visualsOnDayAfterRunning(){
        self.beerOutletButton.enabled = true
        self.wineOutletButton.enabled = true
        self.drinkOutletButton.enabled = true
        self.shotOutletButton.enabled = true
        self.endDayAfterButtonOutlet.enabled = true
        self.beerLabel.text = "\(unitsOfBeers)"
        self.wineLabel.text = "\(unitsOfWines)"
        self.drinkLabel.text = "\(unitsOfDrink)"
        self.shotLabel.text = "\(unitsOfShots)"
        self.yesterdaysCosts.text = "\(yestCost),-"
        print("visualsOnDayafterrunning: yestHighProm: \(yestHighProm)")
        let formatYestHighPromille = String(format: "%.2f", yestHighProm)
        self.yesterdaysHighestProm.text = "\(formatYestHighPromille)"
        
        // ADD TO LATES BUILD
        self.overallTitle.text = "Drakk du mer enn planlagt?"
        self.overallSubtitle.text = "Klikk på enhetene for å legge til"
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.xImageBtn.hidden = true
            self.endDayAfterButtonOutlet.hidden = false
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.xImageBtn.hidden = false
            self.endDayAfterButtonOutlet.hidden = false
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.xImageBtn.hidden = false
            self.endDayAfterButtonOutlet.hidden = false
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.xImageBtn.hidden = false
            self.endDayAfterButtonOutlet.hidden = false
        }
        
        // HVIS DU OVERSTIGER MÅLET DITT BLIR STATISTIKKEN RØD
        plannedNumberOfUnits = Int(brainCoreData.fetchLastPlannedNumberOfUnits())
        if(plannedNumberOfUnits < totalUnits){
            yesterdaysCosts.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
            print("du drakk mer enn planlagt")
        } else {
            yesterdaysCosts.textColor = setAppColors.textUnderHeadlinesColors()
        }
        
        if(brainCoreData.fetchGoal() < yestHighProm){
            yesterdaysHighestProm.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            yesterdaysHighestProm.textColor = setAppColors.textUnderHeadlinesColors()
        }
    }

    func visualsOnDayAfterNotRunning(){
        // BEER BTN SKAL VÆRE FALSE ::::
        self.beerOutletButton.enabled = false
        self.wineOutletButton.enabled = false
        self.drinkOutletButton.enabled = false
        self.shotOutletButton.enabled = false
        self.endDayAfterButtonOutlet.enabled = false
        self.beerLabel.text = "-" // -
        self.wineLabel.text = "-" // -
        self.drinkLabel.text = "-" // -
        self.shotLabel.text = "-" // -
        self.yesterdaysCosts.text = "-" // --,-
        self.yesterdaysHighestProm.text = "-" // --.-
        self.currentPromille.text = "-" // --.-
        
        // ADD TO LATES BUILD
        fetchUserData()
        self.overallTitle.text = "Ingen statistikk å vise til!"
        self.overallSubtitle.text = "Planlegg en kveld og se din statistikk"
        self.xImageBtn.hidden = true // SKAL VÆRE TRUE
        self.endDayAfterButtonOutlet.hidden = true // SKAL VÆRE TRUE
        
        if(brainCoreData.fetchGoal() < yestHighProm){
            yesterdaysHighestProm.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            yesterdaysHighestProm.textColor = setAppColors.textUnderHeadlinesColors()
        }
    }
    ////////////////////////////////////////////////////////////////////////
    //                   COLORS AND FONTS (0002)                          //
    ////////////////////////////////////////////////////////////////////////
    
    func setColorsAndFontsDagenDerpa(){
        //self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        // OVERALL TITLES
        overallTitle.textColor = setAppColors.textHeadlinesColors()
        overallTitle.font = setAppColors.textHeadlinesFonts(22)
        overallSubtitle.textColor = setAppColors.textUnderHeadlinesColors()
        overallSubtitle.font = setAppColors.textUnderHeadlinesFonts(11)
        
        // TOTAL RESULTS LABELS
        beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        beerLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
        wineLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        drinkLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        shotLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        
        // BUTTONS
        beerOutletButton.titleLabel?.font = setAppColors.buttonFonts(14)
        self.beerOutletButton.titleLabel?.textAlignment = NSTextAlignment.Center
        wineOutletButton.titleLabel?.font = setAppColors.buttonFonts(14)
        drinkOutletButton.titleLabel?.font = setAppColors.buttonFonts(14)
        shotOutletButton.titleLabel?.font = setAppColors.buttonFonts(14)
        
        // RESULTS GÅRSDAGENS ERFARINGER
        yesterdaysCosts.textColor = setAppColors.textUnderHeadlinesColors()
        yesterdaysCosts.font = setAppColors.textUnderHeadlinesFonts(32)
        yesterdaysHighestProm.textColor = setAppColors.textUnderHeadlinesColors()
        yesterdaysHighestProm.font = setAppColors.textUnderHeadlinesFonts(32)
        currentPromille.textColor = setAppColors.textUnderHeadlinesColors()
        currentPromille.font = setAppColors.textUnderHeadlinesFonts(32)
        
        // TITLES GÅRSDAGENS ERFARINGER
        yestCostTitleLabel.text = "Forbruk"
        yestCostTitleLabel.textColor = setAppColors.textHeadlinesColors()
        yestCostTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        yestHighestPromTitleLabel.text = "Høyeste Promille"
        yestHighestPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        yestHighestPromTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        currPromTitleLabel.text = "Nåværende Promille"
        currPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        currPromTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        
        // BACKGROUND ON SECTIONS
        /*
        backgroundAfterRegPie.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        backgroundStats.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        backgroundBtn.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        */
        // BUTTONS
        endDayAfterButtonOutlet.titleLabel?.font = setAppColors.buttonFonts(14)
        endDayAfterButtonOutlet.setTitle("Avslutt", forState: UIControlState.Normal)
        //endDayAfterButtonOutlet.backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 0.6)
        //endDayAfterButtonOutlet.layer.cornerRadius = 3;
        //endDayAfterButtonOutlet.titleLabel?.font = setAppColors.buttonFonts(20)
        
        //self.beerOutletButton.layer.cornerRadius = 0.5 * beerOutletButton.bounds.size.width;
        //self.beerOutletButton.layer.borderWidth = 0.5;
        //self.beerOutletButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                     SJEKK PROMILLE (0003)                          //
    ////////////////////////////////////////////////////////////////////////
    
    //GJØR DENNE NOE SOM HELST?
    
    func currentPromilleTimer(){
        var timeTimer = NSTimer()
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("visualsCurrentPromille"), userInfo: nil, repeats: true)
    }
    
    func visualsCurrentPromille(){
        getIsDayAfterRunning()
        //visualsDayAfterStudio()
        if(isDayAfterRunning == true){
            let currPromille = updatePromilleAppDelegate()
            print("Curr promille DAGEN DERP: \(currPromille)")
            print("currentPromilleNow Dagen derP: \(currentPromilleNow)")
            var promille = ""
            promille = String(format: "%.2f", currPromille)
            self.currentPromille.text = "\(promille)"
        }
    }
    
    //GJØR DENNE NOE SOM HELST?
    
    func startVisualsTimer(){
        var timeTimer = NSTimer()
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("setVisualsAtViewOpening"), userInfo: nil, repeats: true)
    }
    
    func setVisualsAtViewOpening(){
        countVisuals += 1
        print("-----> VISUALS NR: \(countVisuals) <----")
        getDefaultValues()
        fetchUserData()
        
        let checkEntityTS2 = brainCoreData.entityIsEmpty("TimeStamp2")
        let checkEntityStartEndTS = brainCoreData.entityIsEmpty("StartEndTimeStamps")
        
        if(checkEntityTS2 == true && checkEntityStartEndTS == true){
            self.beerOutletButton.enabled = false
            self.wineOutletButton.enabled = false
            self.drinkOutletButton.enabled = false
            self.shotOutletButton.enabled = false
        }
        
        if(checkEntityTS2 == false && checkEntityStartEndTS == false){
            let currentStamp = NSDate()
            
            var getPlanPartyStamps : [NSDate] = [NSDate]()
            getPlanPartyStamps = brainCoreData.getPlanPartySession()
            startOfPlanPartyStamp = getPlanPartyStamps[0]
            endOfPlanPartyStamp = getPlanPartyStamps[1]
            
            let isPlanPartyover = endOfPlanPartyStamp.timeIntervalSinceDate(currentStamp)
            
            if(isPlanPartyover < 0.0){
                self.beerOutletButton.enabled = true
                self.wineOutletButton.enabled = true
                self.drinkOutletButton.enabled = true
                self.shotOutletButton.enabled = true
            } else {
                self.beerOutletButton.enabled = false
                self.wineOutletButton.enabled = false
                self.drinkOutletButton.enabled = false
                self.shotOutletButton.enabled = false
            }
        }
        
        self.beerLabel.text = "\(unitsOfBeers)"
        self.wineLabel.text = "\(unitsOfWines)"
        self.drinkLabel.text = "\(unitsOfDrink)"
        self.shotLabel.text = "\(unitsOfShots)"
        self.yesterdaysCosts.text = "Forbruk: \(yestCost),-"
        let formatYestHighPromille = String(format: "%.2f", yestHighProm)
        self.yesterdaysHighestProm.text = "Gårdsdagens høyeste promille: \(formatYestHighPromille)"
        let formatCurrentPromille = String(format: "%.2f", currentPromilleNow)
        self.currentPromille.text = "Nåværende Promille: \(formatCurrentPromille)"
        print("-----> VISUALS NR: \(countVisuals) !SLUTT! <----")
    }
    
    //GJØR startDagenDerpa noe som helst?
    
    func startDagenDerpaTimerAppDelegate(){
        var timeTimer = NSTimer()
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(61, target: self, selector: Selector("updatePromilleAppDelegate"), userInfo: nil, repeats: true)
    }
    
    func updatePromilleAppDelegate() -> Double{
        countCounter += 1
        print("\n-> \(countCounter) MINUTE (MainDagenDerpå-APPDELEGATE) <-")
        
        fetchUserData()
        getDefaultValues()
        
        currentPromilleNow = 0.0
        
        // ATTRIBUTTER
        let entityStartEndTimeStamp = "StartEndTimeStamps"
        let checkEntity = brainCoreData.entityIsEmpty(entityStartEndTimeStamp)
        print("\(entityStartEndTimeStamp) is: \(checkEntity)")
        
        if(checkEntity == true){
            // Sesjon er ikke startet ( startendTimestamp er tom )
            print("Entity is empty. Dont do shit. Sesjonen DagenDerpå er ikke i gang! ")
            unitsOfBeers = 0
            unitsOfWines = 0
            unitsOfDrink = 0
            unitsOfShots = 0
            totalUnits = 0
            yestCost = 0
            yestHighProm = 0.0
            currentPromilleNow = 0.0
            isDayAfterRunning = false
            setDefaultValues()
        } else {
            // Sesjon planleggKvelden er startet siden entiten inneholder verdier
            print("Entity is NOT empty. Sesjon planlegg kvelden er i gang. ")
            
            updateStamp = NSDate()
            
            // CREATE DAY AFTER SESSION:
            var getPlanPartyStamps : [NSDate] = [NSDate]()
            getPlanPartyStamps = brainCoreData.getPlanPartySession()
            startOfPlanPartyStamp = getPlanPartyStamps[0]
            print("Start OF plan part stamp: \(startOfPlanPartyStamp)")
            print("End of plan party stamp: \(endOfPlanPartyStamp)")
            endOfPlanPartyStamp = getPlanPartyStamps[1]
            // sett enden av Dagen Derpa tidspunkt, tallet i (antall minutter fra enden av planlegg kvelden)
            endDagenDerpaStamp = brainCoreData.setDagenDerpaSession()
            
            let isPlanPartyover = endOfPlanPartyStamp.timeIntervalSinceDate(updateStamp)
            
            if(isPlanPartyover < 0.0){
                // Sesjon planlegg kvelden er ferdig.
                print("Sesjon planlegg Kvelden er ferdig. Sesjon DagenDerpå er i gang! ")
                isDayAfterRunning = true
                setDefaultValues()
                let distance = endDagenDerpaStamp.timeIntervalSinceDate(updateStamp)
                let secToMin = distance / 60
                let minToHour = secToMin / 60
                
                // Hvis avstanden fra nå tidspunkt og slutten av sesjonen er negativ, vil det si at sesjonen er over.
                
                if(minToHour < 0.0){
                    // sesjonen er avsluttet
                    print("Sesjon DagenDerpå er avsluttet!")
                    
                    unitsOfBeers = 0
                    unitsOfWines = 0
                    unitsOfDrink = 0
                    unitsOfShots = 0
                    totalUnits = 0
                    yestCost = 0
                    yestHighProm = 0.0
                    currentPromilleNow = 0.0
                    isDayAfterRunning = false
                    setDefaultValues()
                    getDefaultValues()
                    print("\n\n\nBEFORE POP GRAPH VALUES: ")
                    print("Start Planlegg kvelden: \(startOfPlanPartyStamp)")
                    print("Slutt planlegg kvelden: \(endOfPlanPartyStamp)")
                    print("\n\n")
                    // FJERNE DENNE METODEN HERFAR OG HELLER OPPDATERE GRAFEN "HVIS" NOEN LEGGER TIL TING I ETTERKANT AV KVELDEN
                    // \
                    //  \
                    //brain.populateGraphValues(getGender, weight: getWeight, startPlanStamp: startOfPlanPartyStamp, endPlanStamp: endOfPlanPartyStamp)
                    // Clear database slik at den skal ta inn nye timeStamp
                    brainCoreData.clearCoreData("TimeStamp2")
                    brainCoreData.clearCoreData(entityStartEndTimeStamp)
                    brainCoreData.clearCoreData("TerminatedTimeStamp")
                } else {
                    print("Sesjon DagenDerpå pågår, men Historikk er ikke oppdatert")
                    
                    // sesjonen pågår.
                    populateArrays()
                    checkIfLatestHistorikkIsFetched = brainCoreData.checkHistorikk()
                    print("checkIfLatestHistorikkIsFetched: \(checkIfLatestHistorikkIsFetched)")
                    
                    if(checkIfLatestHistorikkIsFetched == startOfPlanPartyStamp){
                        print("Sesjon DagenDerpå pågår... (Historikk ER oppdatert)")
                        setHistorikkValues()
                        
                        let tempStoreFirstUnitAddedValue = brainCoreData.getFirstUnitAddedTimeStamp()
                        print("WHAT THA CTU: \(tempStoreFirstUnitAddedValue)")
                        
                        currentPromilleNow += brain.liveUpdatePromille(getWeight, gender: getGender, firstUnitAddedTimeS: tempStoreFirstUnitAddedValue)
                        
                        print("Sum On Array DDPÅ: \(currentPromilleNow)")
                        
                        if(currentPromilleNow <= 0.0){
                            currentPromilleNow = 0.0
                        }
                        setDefaultValues()
                    } else {
                        print("Historikk er ikke oppdatert! Ingenting skal skje, alt fortsetter!")
                        currentPromilleNow = 0.0
                    }
                }
            }
        }
        return currentPromilleNow
        //print(">-< UPDATE PROMILLE APP DELEGATE OVER >--<\n")
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                    ADD UNITS DAY AFTER (0004)                      //
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func addBeerDayAfter(sender: AnyObject) {
        addBeerPopUp("Legg til Øl", messageAlCon: "Glemt av øl? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt")
    }
    
    @IBAction func addWineDayAfter(sender: AnyObject) {
        addWinePopUp("Legg til Vin", messageAlCon: "Glemt av vin? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt")
    }
    
    @IBAction func addDrinkDayAfter(sender: AnyObject) {
        addDrinkPopUp("Legg til Drink", messageAlCon: "Glemt av drink? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt")
    }
    
    @IBAction func addShotDayAfter(sender: AnyObject) {
        addShotPopUp("Legg til Drink", messageAlCon: "Glemt av drink? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt")
    }
    
    // ØL
    func addBeerPopUp(titleAlCon: String, messageAlCon: String, titleActionOne: String, titleActionTwo: String){
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .DateAndTime
        var getPlanPartyStamps : [NSDate] = [NSDate]()
        getPlanPartyStamps = brainCoreData.getPlanPartySession()
        startOfPlanPartyStamp = getPlanPartyStamps[0]
        endOfPlanPartyStamp = getPlanPartyStamps[1]
        
        datepicker.minimumDate = startOfPlanPartyStamp
        datepicker.maximumDate = endOfPlanPartyStamp
        datepicker.setDate(endOfPlanPartyStamp, animated: true)
        datepicker.backgroundColor = UIColor.darkGrayColor()
        datepicker.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        
        let vc = UIAlertController(title: titleAlCon, message: messageAlCon, preferredStyle: .Alert)
        vc.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textfield.delegate = self
            // add delegate ... here
            textField.delegate = self
            textField.inputView = datepicker
            textField.placeholder = "Dato"
            //textfield.hidden = true
        })
        vc.addAction(UIAlertAction(title: titleActionOne, style: .Default, handler: { (action) -> Void in
            self.datePickValueChangedBeer(datepicker)
            self.fetchUserData()
            self.getDefaultValues()
            
            // TEMPORARY STORE SESSION VALUES
            let tempPlanPartSesNr = self.brainCoreData.fetchPlanPartySessionNr()
            let tempNumBeer = self.brainCoreData.tempStoreUnits("Beer")
            let tempNumWine = self.unitsOfWines //self.brainCoreData.tempStoreUnits("Wine")
            let tempNumDrink = self.unitsOfDrink //self.brainCoreData.tempStoreUnits("Drink")
            let tempNumShot = self.unitsOfShots //self.brainCoreData.tempStoreUnits("Shot")
            let tempCosts = self.brainCoreData.tempStoreCosts(tempNumBeer, numWine: tempNumWine, numDrink: tempNumDrink, numShot: tempNumShot)
            let printDay = self.brain.getDayOfWeekAsString(self.startOfPlanPartyStamp)
            let printDate = self.brain.getDateOfMonth(self.startOfPlanPartyStamp)
            let printMonth = self.brain.getMonthOfYear(self.startOfPlanPartyStamp)
            let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
            let tempFirstUnitAdded = self.brainCoreData.getFirstUnitAddedTimeStamp()
            
            // METODE FOR Å OPPDATERE ENHET
            
            self.brainCoreData.deleteLastItemAdded(tempPlanPartSesNr)
            self.brainCoreData.deleteLastGraphValue(tempPlanPartSesNr)
            
            self.brainCoreData.seedHistoryValues(self.startOfPlanPartyStamp, forbruk: tempCosts, hoyestePromille: 0.0, antallOl: tempNumBeer, antallVin: tempNumWine, antallDrink: tempNumDrink, antallShot: tempNumShot, stringDato: fullDate, endOfSesDate: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr, firstUnitStamp: tempFirstUnitAdded)
            
            self.brain.populateGraphValues(self.getGender, weight: self.getWeight, startPlanStamp: self.startOfPlanPartyStamp, endPlanStamp: self.endOfPlanPartyStamp)
            
            self.setHistorikkValues()
            self.visualsOnDayAfterRunning()
            
            self.populateArrays()
            self.currentPromilleNow = 0.0
            self.currentPromilleNow += self.brain.liveUpdatePromille(self.getWeight, gender: self.getGender, firstUnitAddedTimeS: tempFirstUnitAdded)
            
            print("Sum On Array DDPÅ: \(self.currentPromilleNow)")
            
            if(self.currentPromilleNow <= 0.0){
                self.currentPromilleNow = 0.0
            }
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(self.unitsOfBeers), Double(self.unitsOfWines), Double(self.unitsOfDrink), Double(self.unitsOfShots)]
            self.setChart(months, values: unitsSold)
            
            self.setDefaultValues()
        }))
        vc.addAction(UIAlertAction(title: titleActionTwo, style: .Cancel, handler: nil))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func datePickValueChangedBeer(sender:UIDatePicker){
        let pickerTime = sender.date
        
        brainCoreData.seedTimeStamp(pickerTime, unitAlcohol: "Beer")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        //textField.text =
    }
    
    // VIN
    func addWinePopUp(titleAlCon: String, messageAlCon: String, titleActionOne: String, titleActionTwo: String){
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .DateAndTime
        datepicker.minimumDate = startOfPlanPartyStamp
        datepicker.maximumDate = endOfPlanPartyStamp
        datepicker.setDate(endOfPlanPartyStamp, animated: true)
        
        let vc = UIAlertController(title: titleAlCon, message: messageAlCon, preferredStyle: .Alert)
        vc.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.inputView = datepicker
        })
        vc.addAction(UIAlertAction(title: titleActionOne, style: .Default, handler: { (action) -> Void in
            self.datePickerValueChangedWine(datepicker)
            self.fetchUserData()
            self.getDefaultValues()
            
            // TEMPORARY STORE SESSION VALUES
            let tempPlanPartSesNr = self.brainCoreData.fetchPlanPartySessionNr()
            
            // VALUE ADDED:
            let tempNumWine = self.brainCoreData.tempStoreUnits("Wine")
            
            // GET OLD VALUES:
            let tempNumBeer = self.unitsOfBeers
            let tempNumDrink = self.unitsOfDrink
            let tempNumShot = self.unitsOfShots
            
            // COSTS
            let tempCosts = self.brainCoreData.tempStoreCosts(tempNumBeer, numWine: tempNumWine, numDrink: tempNumDrink, numShot: tempNumShot)
            
            // FORMAT NEW DATE FOR HISTORY
            let printDay = self.brain.getDayOfWeekAsString(self.startOfPlanPartyStamp)
            let printDate = self.brain.getDateOfMonth(self.startOfPlanPartyStamp)
            let printMonth = self.brain.getMonthOfYear(self.startOfPlanPartyStamp)
            let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
            let tempFirstUnitAdded = self.brainCoreData.getFirstUnitAddedTimeStamp()
            
            // METODE FOR Å OPPDATERE ENHET
            self.brainCoreData.deleteLastItemAdded(tempPlanPartSesNr)
            self.brainCoreData.deleteLastGraphValue(tempPlanPartSesNr)
            
            // SETTE NYE VERDIER
            self.brainCoreData.seedHistoryValues(self.startOfPlanPartyStamp, forbruk: tempCosts, hoyestePromille: 0.0, antallOl: tempNumBeer, antallVin: tempNumWine, antallDrink: tempNumDrink, antallShot: tempNumShot, stringDato: fullDate, endOfSesDate: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr, firstUnitStamp: tempFirstUnitAdded)
            
            self.brain.populateGraphValues(self.getGender, weight: self.getWeight, startPlanStamp: self.startOfPlanPartyStamp, endPlanStamp: self.endOfPlanPartyStamp)
            
            self.setHistorikkValues()
            self.visualsOnDayAfterRunning()
            
            self.populateArrays()
            self.currentPromilleNow = 0.0
            self.currentPromilleNow += self.brain.liveUpdatePromille(self.getWeight, gender: self.getGender, firstUnitAddedTimeS: tempFirstUnitAdded)
            
            print("Sum On Array DDPÅ: \(self.currentPromilleNow)")
            
            if(self.currentPromilleNow <= 0.0){
                self.currentPromilleNow = 0.0
            }
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(self.unitsOfBeers), Double(self.unitsOfWines), Double(self.unitsOfDrink), Double(self.unitsOfShots)]
            self.setChart(months, values: unitsSold)
            
            self.setDefaultValues()
        }))
        vc.addAction(UIAlertAction(title: titleActionTwo, style: .Cancel, handler: nil))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func datePickerValueChangedWine(sender:UIDatePicker) {
        let pickerTime = sender.date
        
        brainCoreData.seedTimeStamp(pickerTime, unitAlcohol: "Wine")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    // DRINK
    func addDrinkPopUp(titleAlCon: String, messageAlCon: String, titleActionOne: String, titleActionTwo: String){
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .DateAndTime
        datepicker.minimumDate = startOfPlanPartyStamp
        datepicker.maximumDate = endOfPlanPartyStamp
        datepicker.setDate(endOfPlanPartyStamp, animated: true)
        
        let vc = UIAlertController(title: titleAlCon, message: messageAlCon, preferredStyle: .Alert)
        vc.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            
            // add delegate ... here
            textfield.inputView = datepicker
            
        })
        vc.addAction(UIAlertAction(title: titleActionOne, style: .Default, handler: { (action) -> Void in
            self.datePickValueChangedDrink(datepicker)
            self.fetchUserData()
            self.getDefaultValues()
            
            // TEMPORARY STORE SESSION VALUES
            let tempPlanPartSesNr = self.brainCoreData.fetchPlanPartySessionNr()
            let tempNumDrink = self.brainCoreData.tempStoreUnits("Drink")
            
            let tempNumBeer = self.unitsOfBeers
            let tempNumWine = self.unitsOfWines
            let tempNumShot = self.unitsOfShots
            
            let tempCosts = self.brainCoreData.tempStoreCosts(tempNumBeer, numWine: tempNumWine, numDrink: tempNumDrink, numShot: tempNumShot)
            let printDay = self.brain.getDayOfWeekAsString(self.startOfPlanPartyStamp)
            let printDate = self.brain.getDateOfMonth(self.startOfPlanPartyStamp)
            let printMonth = self.brain.getMonthOfYear(self.startOfPlanPartyStamp)
            let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
            let tempFirstUnitAdded = self.brainCoreData.getFirstUnitAddedTimeStamp()
            
            // METODE FOR Å OPPDATERE ENHET
            self.brainCoreData.deleteLastItemAdded(tempPlanPartSesNr)
            self.brainCoreData.deleteLastGraphValue(tempPlanPartSesNr)
            
            self.brainCoreData.seedHistoryValues(self.startOfPlanPartyStamp, forbruk: tempCosts, hoyestePromille: 0.0, antallOl: tempNumBeer, antallVin: tempNumWine, antallDrink: tempNumDrink, antallShot: tempNumShot, stringDato: fullDate, endOfSesDate: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr, firstUnitStamp: tempFirstUnitAdded)
            
            self.brain.populateGraphValues(self.getGender, weight: self.getWeight, startPlanStamp: self.startOfPlanPartyStamp, endPlanStamp: self.endOfPlanPartyStamp)
            
            self.setHistorikkValues()
            self.visualsOnDayAfterRunning()
            
            self.populateArrays()
            self.currentPromilleNow = 0.0
            self.currentPromilleNow += self.brain.liveUpdatePromille(self.getWeight, gender: self.getGender, firstUnitAddedTimeS: tempFirstUnitAdded)
            
            print("Sum On Array DDPÅ: \(self.currentPromilleNow)")
            
            if(self.currentPromilleNow <= 0.0){
                self.currentPromilleNow = 0.0
            }
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(self.unitsOfBeers), Double(self.unitsOfWines), Double(self.unitsOfDrink), Double(self.unitsOfShots)]
            self.setChart(months, values: unitsSold)
            
            self.setDefaultValues()
        }))
        vc.addAction(UIAlertAction(title: titleActionTwo, style: .Cancel, handler: nil))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func datePickValueChangedDrink(sender:UIDatePicker){
        let pickerTime = sender.date
        
        brainCoreData.seedTimeStamp(pickerTime, unitAlcohol: "Drink")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    // SHOT
    func addShotPopUp(titleAlCon: String, messageAlCon: String, titleActionOne: String, titleActionTwo: String){
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .DateAndTime
        datepicker.minimumDate = startOfPlanPartyStamp
        datepicker.maximumDate = endOfPlanPartyStamp
        datepicker.setDate(endOfPlanPartyStamp, animated: true)
        
        let vc = UIAlertController(title: titleAlCon, message: messageAlCon, preferredStyle: .Alert)
        vc.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            
            // add delegate ... here
            textfield.inputView = datepicker
            
        })
        vc.addAction(UIAlertAction(title: titleActionOne, style: .Default, handler: { (action) -> Void in
            self.datePickValueChangedShot(datepicker)
            self.fetchUserData()
            self.getDefaultValues()
            
            // TEMPORARY STORE SESSION VALUES
            let tempPlanPartSesNr = self.brainCoreData.fetchPlanPartySessionNr()
            let tempNumShot = self.brainCoreData.tempStoreUnits("Shot")
            
            let tempNumBeer = self.unitsOfBeers
            let tempNumWine = self.unitsOfWines
            let tempNumDrink = self.unitsOfDrink
            
            let tempCosts = self.brainCoreData.tempStoreCosts(tempNumBeer, numWine: tempNumWine, numDrink: tempNumDrink, numShot: tempNumShot)
            let printDay = self.brain.getDayOfWeekAsString(self.startOfPlanPartyStamp)
            let printDate = self.brain.getDateOfMonth(self.startOfPlanPartyStamp)
            let printMonth = self.brain.getMonthOfYear(self.startOfPlanPartyStamp)
            let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
            let tempFirstUnitAdded = self.brainCoreData.getFirstUnitAddedTimeStamp()
            
            // METODE FOR Å OPPDATERE ENHET
            self.brainCoreData.deleteLastItemAdded(tempPlanPartSesNr)
            self.brainCoreData.deleteLastGraphValue(tempPlanPartSesNr)
            
            self.brainCoreData.seedHistoryValues(self.startOfPlanPartyStamp, forbruk: tempCosts, hoyestePromille: 0.0, antallOl: tempNumBeer, antallVin: tempNumWine, antallDrink: tempNumDrink, antallShot: tempNumShot, stringDato: fullDate, endOfSesDate: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr, firstUnitStamp: tempFirstUnitAdded)
            
            self.brain.populateGraphValues(self.getGender, weight: self.getWeight, startPlanStamp: self.startOfPlanPartyStamp, endPlanStamp: self.endOfPlanPartyStamp)
            
            self.setHistorikkValues()
            self.visualsOnDayAfterRunning()
            
            self.populateArrays()
            self.currentPromilleNow = 0.0
            self.currentPromilleNow += self.brain.liveUpdatePromille(self.getWeight, gender: self.getGender, firstUnitAddedTimeS: tempFirstUnitAdded)
            
            print("Sum On Array DDPÅ: \(self.currentPromilleNow)")
            
            if(self.currentPromilleNow <= 0.0){
                self.currentPromilleNow = 0.0
            }
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(self.unitsOfBeers), Double(self.unitsOfWines), Double(self.unitsOfDrink), Double(self.unitsOfShots)]
            self.setChart(months, values: unitsSold)
            
            self.setDefaultValues()
        }))
        vc.addAction(UIAlertAction(title: titleActionTwo, style: .Cancel, handler: nil))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func datePickValueChangedShot(sender:UIDatePicker){
        let pickerTime = sender.date
        
        brainCoreData.seedTimeStamp(pickerTime, unitAlcohol: "Shot")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                      INITIATE METHODS (0005)                       //
    ////////////////////////////////////////////////////////////////////////
    
    func checkHighestPromille(gender: Bool, weight: Double) -> Double {
        var getPlanPartyStamps : [NSDate] = [NSDate]()
        getPlanPartyStamps = brainCoreData.getPlanPartySession()
        startOfPlanPartyStamp = getPlanPartyStamps[0]
        endOfPlanPartyStamp = getPlanPartyStamps[1]
        
        var highestPromille : Double = 0.0
        var sum : Double = 0.0
        var valueBetweenTerminated : Double = 0.0
        var genderScore : Double = 0.0
        
        if(gender == true) { // TRUE ER MANN
            genderScore = 0.70
        } else if (gender == false) { // FALSE ER KVINNE
            genderScore = 0.60
        }
        
        var countIterasjons = 0
        var count = 0
        var timeStamps = [TimeStamp2]()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        
        // SESJON PLANLEGG KVELDEN TIME INTEVALL
        let sesPlanKveldIntervall = endOfPlanPartyStamp.timeIntervalSinceDate(startOfPlanPartyStamp)
        print("Tolv timer skal det være: 120 sek ish: \(sesPlanKveldIntervall)")
        
        while(valueBetweenTerminated < sesPlanKveldIntervall){
            do {
                timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
                
                // Henter ut verdier hvert (valg av sekunder) for å se hva promillen var på det tidspunkt
                valueBetweenTerminated += 60
                countIterasjons += 1
                
                print("\n\nIterasjoner: \(countIterasjons)(\(valueBetweenTerminated))\n")
                
                for unitOfAlcohol in timeStamps {
                    let timeStampTesting : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    let unit : String = unitOfAlcohol.unitAlkohol! as String
                    
                    count += 1
                    print("Timestamp nr: \(count)")
                    
                    let datePerMin = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: countIterasjons, toDate: startOfPlanPartyStamp, options: NSCalendarOptions(rawValue: 0))!
                    let intervallShiz = datePerMin.timeIntervalSinceDate(timeStampTesting)
                    
                    // Hvis intervallshiz er negativ vil det si at enheten ikke enda er lagt til
                    if(intervallShiz <= 0){
                        // enhet ikke lagt til
                    } else {
                        // enhet lagt til
                        let convertMin = intervallShiz / 60
                        var checkPromille : Double = 0.0
                        let convertHours = convertMin / 60 as Double
                        if(unit == "Beer"){
                            checkPromille += brain.firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Wine"){
                            checkPromille += brain.firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Drink"){
                            checkPromille += brain.firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        if (unit == "Shot"){
                            checkPromille += brain.firstFifteen(convertHours, weightFif: weight, genderFif: genderScore, unitAlco: unit)
                        }
                        sum += checkPromille
                        print("Sum units: \(sum)")
                        
                        if(sum > highestPromille){
                            highestPromille = sum
                            print("Høyeste Promille chechHigestPromille() -- MAINDAGEN: \(sum)")
                        }
                    }
                }
                sum = 0
                print("\n")
            } catch {
                fatalError("bad things happened \(error)")
            }
        }
        return highestPromille
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                     DEFAULT VERDIER (0006)                         //
    ////////////////////////////////////////////////////////////////////////
    
    enum defaultKeys {
        static let keyOne = "firstKey"
        static let keyTwo = "secondKey"
        static let keyThree = "thirdKey"
        static let keyFour = "fourthKey"
        static let keyFive = "fifthKey"
        static let keySix = "sixthKey"
        static let keySeven = "seventhKey"
    }
    
    func setDefaultValues(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(unitsOfBeers, forKey: defaultKeys.keyOne)
        defaults.setInteger(unitsOfWines, forKey: defaultKeys.keyTwo)
        defaults.setInteger(unitsOfDrink, forKey: defaultKeys.keyThree)
        defaults.setInteger(unitsOfShots, forKey: defaultKeys.keyFour)
        defaults.setInteger(yestCost, forKey: defaultKeys.keyFive)
        defaults.setDouble(yestHighProm, forKey: defaultKeys.keySix)
        defaults.setDouble(currentPromilleNow, forKey: defaultKeys.keySeven)
        defaults.setBool(isDayAfterRunning, forKey: SkallMenyBrain.defKeyBool.isDayAfterRun)
        defaults.synchronize()
    }
    
    func getDefaultValues(){ // GETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        if let beer : Int = defaults.integerForKey(defaultKeys.keyOne) {
            unitsOfBeers = beer
            print("Def Values Units of Beer: \(unitsOfBeers)")
        }
        if let wine : Int = defaults.integerForKey(defaultKeys.keyTwo) {
            unitsOfWines = wine
        }
        if let drink : Int = defaults.integerForKey(defaultKeys.keyThree) {
            unitsOfDrink = drink
        }
        if let shot : Int = defaults.integerForKey(defaultKeys.keyFour) {
            unitsOfShots = shot
        }
        if let yestCostings : Int = defaults.integerForKey(defaultKeys.keyFive) {
            yestCost = yestCostings
        }
        if let yHighestPromille : Double = defaults.doubleForKey(defaultKeys.keySix) {
            print("getDefaultValues: yestHighProm: \(yestHighProm)")
            yestHighProm = yHighestPromille
        }
        if let currPromNow : Double = defaults.doubleForKey(defaultKeys.keySeven) {
            currentPromilleNow = currPromNow
        }
        if let isRunning : Bool = defaults.boolForKey(SkallMenyBrain.defKeyBool.isDayAfterRun) {
            isDayAfterRunning = isRunning
            print("Is day after running: \(isDayAfterRunning)")
        }
        print("DefaultValues DAGENDERPÅ gotten...\n")
    }
    
    func getIsDayAfterRunning(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isRunning : Bool = defaults.boolForKey(SkallMenyBrain.defKeyBool.isDayAfterRun) {
            isDayAfterRunning = isRunning
            print("Dagen Derpå kjører: \(isDayAfterRunning)")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    //           CORE DATA - SAMHANDLING MED DATABASEN (0007)             //
    ////////////////////////////////////////////////////////////////////////
    
    func setHistorikkValues() {
        var historikk = [Historikk]()
        
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            print("-----------------> DAGEN DERPÅ - SET VALUES <---------------------")
            for antOlLoop in historikk {
                unitsOfBeers = antOlLoop.antallOl! as Int
            }
            for antWineLoop in historikk {
                unitsOfWines = antWineLoop.antallVin! as Int
            }
            for antDriLoop in historikk {
                unitsOfDrink = antDriLoop.antallDrink! as Int
            }
            for antShoLoop in historikk {
                unitsOfShots = antShoLoop.antallShot! as Int
            }
            for forbruksPromille in historikk {
                yestCost = forbruksPromille.forbruk! as Int
            }
            for hoyesteProm in historikk {
                yestHighProm = hoyesteProm.hoyestePromille! as Double
                print("setHistorikkValues: yestHighProm: \(yestHighProm)")
            }
            totalUnits = unitsOfWines + unitsOfBeers + unitsOfDrink + unitsOfShots
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGender = item.gender! as Bool
                getWeight = item.weight! as Double
                getNickName = item.height! as String
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func populateArrays() {
        var timeStamps = [TimeStamp2]()
        beerArray.removeAll()
        wineArray.removeAll()
        drinkArray.removeAll()
        shotArray.removeAll()
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        do {
            timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
            for unitOfAlcohol in timeStamps {
                if (unitOfAlcohol.unitAlkohol! == "Beer"){
                    let beerItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    beerArray.append(beerItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Wine"){
                    let wineItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    wineArray.append(wineItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Drink"){
                    let drinkItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    drinkArray.append(drinkItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Shot"){
                    let shotItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    shotArray.append(shotItem)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    @IBAction func endDayAfterBtn(sender: UIButton) {
        print("Button pressed! ")
        endDayAfterAlert("Avslutt Dagen Derpå?", msg: "Du vil ikke kunne gå tilbake", cancelTitle: "Avbryt", confirmTitle: "Bekreft")
    }
    
    func endDayAfterAlert(titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
            print("Handle cancel logic here")
        }))
        
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.Default, handler:  { action in
            //self.endParty(NSDate())
            print("End Dagen Derpå knapp trykket! ")
            print("Sesjon DagenDerpå er avsluttet!")
            self.unitsOfBeers = 0
            self.unitsOfWines = 0
            self.unitsOfDrink = 0
            self.unitsOfShots = 0
            self.totalUnits = 0
            self.yestCost = 0
            self.yestHighProm = 0.0
            self.currentPromilleNow = 0.0
            self.isDayAfterRunning = false
            self.setDefaultValues()
            self.getDefaultValues()
            self.brainCoreData.clearCoreData("TimeStamp2")
            self.brainCoreData.clearCoreData("StartEndTimeStamps")
            self.brainCoreData.clearCoreData("TerminatedTimeStamp")
            
            // PIE CHART:
            let months = ["", "", "", ""]
            let unitsSold = [Double(self.unitsOfBeers), Double(self.unitsOfWines), Double(self.unitsOfDrink), Double(self.unitsOfShots)]
            self.setChart(months, values: unitsSold)
            self.visualsOnDayAfterNotRunning()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setSliceColors(){
        // SLICE COLORS
        beerSliceColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0)
        wineSliceColor = UIColor(red: 157/255, green: 9/255, blue: 9/255, alpha: 1.0)
        drinkSliceColor = UIColor(red: 38/255, green: 207/255, blue: 86/255, alpha: 1.0)
        shotSliceColor = UIColor(red: 139/255, green: 65/255, blue: 232/255, alpha: 1.0) // BLÅ: 0, 170, 255
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        setSliceColors()
        
        //Creating Chart
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "???")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartData.setDrawValues(false)
        
        var colors: [UIColor] = []
        
        colors.append(beerSliceColor)
        colors.append(wineSliceColor)
        colors.append(drinkSliceColor)
        colors.append(shotSliceColor)
        
        pieChartDataSet.colors = colors
        
        //Styling chart:
        //pieChartDataSet.colors = [UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0), UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0), ]
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = CGFloat(0.55)
        pieChartView.holeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        pieChartView.centerTextRadiusPercent = CGFloat(1.0)
        pieChartView.transparentCircleRadiusPercent = 0.67
        pieChartView.animate(yAxisDuration: 1.0)
        pieChartView.descriptionText = ""
        pieChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        //pieChartView.transparentCircleColor?.CGColor
        pieChartView.drawSliceTextEnabled = false
        pieChartView.legend.enabled = false
        
        var centerText = ""
        
        if(isDayAfterRunning == false){
            centerText = "-"
        } else {
            centerText = "\(totalUnits)"
        }
        var fontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(30.0), NSForegroundColorAttributeName: UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)]
        
        // HVIS DU OVERSTIGER MÅLET DITT BLIR STATISTIKKEN RØD
        plannedNumberOfUnits = Int(brainCoreData.fetchLastPlannedNumberOfUnits())
        if(plannedNumberOfUnits < totalUnits){
            fontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(30.0), NSForegroundColorAttributeName: UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)]
            yesterdaysCosts.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            fontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(30.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
            yesterdaysCosts.textColor = UIColor.whiteColor()
        }
        
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        pieChartView.centerAttributedText = attriButedString
        pieChartView.userInteractionEnabled = true
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        setSliceColors()
        print("\n\nChartView: \n\(chartView), \n\nEntry: \n\(entry), \n\ndataSetIndex: \n\(dataSetIndex), \n\nHighlight: \n\(highlight)")
        //print("\(entry.value) in \(months[entry.xIndex])")
        print("\n\n INDEX NR: \(entry.xIndex)")
        if(entry.xIndex == 0){
            print("GJØR ØL")
            beerLabel.textColor = beerSliceColor
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.xIndex == 1){
            print("GJØR VIN")
            wineLabel.textColor = wineSliceColor
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.xIndex == 2){
            print("GJØR DRINK")
            drinkLabel.textColor = drinkSliceColor
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.xIndex == 3){
            print("GJØR SHOT")
            shotLabel.textColor = shotSliceColor
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        self.beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            print("iphone 4 - GlemteEnheter")
            let unitLabButHeight : CGFloat = -50.0
            let unitLabButWidthBeerWine : CGFloat = 18.0
            let unitLabButWidthDrinkShot : CGFloat = -18.0
            // PIE CHART
            self.pieChartView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -50.0)
            
            // TITLE AND SUBTITLE
            self.overallTitle.font = setAppColors.textHeadlinesFonts(18)
            self.overallSubtitle.font = setAppColors.textUnderHeadlinesFonts(11)
            self.overallTitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -17.0)
            self.overallSubtitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -32.0)
            
            // TOTAL RESULTS LABELS
            self.beerLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.wineLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.drinkLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.shotLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.beerLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.wineLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.drinkLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            self.shotLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            
            // BUTTONS
            beerOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            wineOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            drinkOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            shotOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            self.beerOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.wineOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.drinkOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            self.shotOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            
            let statsHeight : CGFloat = -85.0
            let titleStatsHeight : CGFloat = -95.0
            
            // RESULTS GÅRSDAGENS ERFARINGER
            yesterdaysCosts.font = setAppColors.textUnderHeadlinesFonts(20)
            yesterdaysHighestProm.font = setAppColors.textUnderHeadlinesFonts(20)
            currentPromille.font = setAppColors.textUnderHeadlinesFonts(20)
            self.yesterdaysCosts.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            self.yesterdaysHighestProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            self.currentPromille.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            
            // TITLES GÅRSDAGENS ERFARINGER
            yestCostTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            yestHighestPromTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            currPromTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            self.yestCostTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
            self.yestHighestPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
            self.currPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
            
            self.xImageBtn.hidden = true
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            let unitLabButHeight : CGFloat = -37.0
            let unitLabButWidthBeerWine : CGFloat = 18.0
            let unitLabButWidthDrinkShot : CGFloat = -18.0
            // PIE CHART
            self.pieChartView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -37.0)
            
            // TITLE AND SUBTITLE
            self.overallTitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -10.0)
            self.overallSubtitle.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -18.0)
            
            // TOTAL RESULTS LABELS
            self.beerLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.wineLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.drinkLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            self.shotLabel.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            
            // BUTTONS
            self.beerOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.wineOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthBeerWine, unitLabButHeight)
            self.drinkOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            self.shotOutletButton.transform = CGAffineTransformTranslate(self.view.transform, unitLabButWidthDrinkShot, unitLabButHeight)
            
            let statsHeight : CGFloat = -65.0
            let titleStatsHeight : CGFloat = -75.0
            
            // RESULTS GÅRSDAGENS ERFARINGER
            self.yesterdaysCosts.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            self.yesterdaysHighestProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            self.currentPromille.transform = CGAffineTransformTranslate(self.view.transform, 0.0, statsHeight)
            
            // TITLES GÅRSDAGENS ERFARINGER
            self.yestCostTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
            self.yestHighestPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
            self.currPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, titleStatsHeight)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            
        }
    }
}
