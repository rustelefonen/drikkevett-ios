//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData
import Foundation

class FirstViewController: UIViewController {
    
    @IBOutlet weak var oppdaterPromilleLabel: UILabel!
    @IBOutlet weak var antallOlLabel: UILabel!
    @IBOutlet weak var antallVinLabel: UILabel!
    @IBOutlet weak var antallDrinkLabel: UILabel!
    @IBOutlet weak var antallShotLabel: UILabel!
    @IBOutlet weak var buttonStartKveldenOutlet: UIButton!
    @IBOutlet weak var startEndPartyBtn: UIButton!
    @IBOutlet weak var titleBeer: UILabel!
    @IBOutlet weak var titleWine: UILabel!
    @IBOutlet weak var titleDrink: UILabel!
    @IBOutlet weak var titleShot: UILabel!
    @IBOutlet weak var clearButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var minusBeerBtnOutlet: UIButton!
    @IBOutlet weak var addUnitsBtnOutlet: UIButton!
    
    // START KVELD / END KVELD BILDE KNAPP
    @IBOutlet weak var startEndImage: UIImageView!
    
    // CONT VIEW
    @IBOutlet weak var containerView: UIView!
    
    // TEXT VIEW QUOTES
    @IBOutlet weak var textViewQuotes: UILabel!
    
    //----------------------   MODEL/DATABASE/COLORS    ---------------------//
    var brain = SkallMenyBrain()
    var brainCoreData = CoreDataMethods()
    let moc = DataController().managedObjectContext
    var setAppColors = AppColors()
    var forgotViewCont = GlemteEnheterViewController()
    let planPartyUtils = PlanPartyUtil()
    
    //---------------------------   VARIABLER    -----------------------------//
    var isPlanPartyNotGoing : Bool = true
    
    // ARRAYS TIL POPULATION AV CURRENT PROMILLE
    var universalWineArray : [NSDate] = [NSDate]()
    var universalBeerArray : [NSDate] = [NSDate]()
    var universalDrinkArray : [NSDate] = [NSDate]()
    var universalShotArray : [NSDate] = [NSDate]()
    
    // Denne verdien settes til hvilken type alkohol det er:
    var unitAlcohol : String = ""
    
    // TOTALT ANTALL
    var counter : Double = 0
    
    // TELLE OPP FØR KVELDEN
    var numberOfWineCount = 0
    var numberOfBeerCount = 0
    var numberOfDrinkCount = 0
    var numberOfShotCount = 0
    
    // ANTALL SOM LEGGES TIL I HISTORIKK
    var historyCountBeer = 0
    var historyCountWine = 0
    var historyCountDrink = 0
    var historyCountShot = 0
    
    // Setter timestampet når appen ble terminated
    var timeStampTerminated : NSDate = NSDate()
    
    // Start/End av sesjon timestamps og updateStamp som er tidspunktet nå
    var startOfSessionStamp : NSDate = NSDate()
    var setEndOfSessionStamp : NSDate = NSDate()
    var updateStamp : NSDate = NSDate()
    
    // User Data henting variabler
    var getGender : Bool = true
    var getWeight : Double! = 0.0
    var getBeerCost : Int = 0
    var getWineCost : Int = 0
    var getDrinkCost : Int = 0
    var getShotCost : Int = 0
    
    // Høyeste Promille
    var highestPromille : Double = 0.0
    
    // Nåværende promille ( blir vist i oppdaterlabel )
    var sumOnArray : Double = 0.0
    
    // ANTALL GANGER STARTTIMER HAR KJØRT
    var countCounter : Int = 0
    
    // SESJONSNUMMER
    var numberOfSessionPlanParty = 0
    
    // DU HAR OVERSTEGET MÅL PROMILLE
    var overGoalPromille = false
    
    // TESTING SEGUE
    var someText = ""
    
    // FETCH UNIT TYPE FROM SWIPE
    var fetchUnitTypeFromSwipe = ""
    
    var isDayAfterOnGoing = false
    
    // Har første enhet blitt lagt til
    var hasFirstUnitBeenAdded = false
    var setDateOnFirstUnitAdded = NSDate()
    
    // TOTAL COSTS VARIABLE
    var costsVariable = 0
    
    //  TIMER VISUALS
    var visualsTimer = NSTimer()
     
    var plannedCounter : Double = 0
    
    // GET IF NOTIFICATIONS IS TURNED ON OR OFF
    let instMenu = InnstillingerMenyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsFirstView()
        setConstraints()
        
        isAppAlreadyLaunchedOnce()
        isPlanPartyViewLunchedBefore()
        brainCoreData.fetchHistorikk()
        visualsMethod()
        updatePromilleLabel()
        timerShowPromille()
        startTimerUpdateVisuals()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        didBecomeActive()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.hidden = false
        
        let checkEntityTS2 = brainCoreData.entityIsEmpty("TimeStamp2")
        let checkEntityStartEndTS = brainCoreData.entityIsEmpty("StartEndTimeStamps")
        
        getIfDayAfterIsRunning()
        getDefaultCheckSessionBool()
        getDefaultBool()
        
        visualsMethod()
        if(isDayAfterOnGoing == true){
            dayAfterIsRunningPopUp("Dagen Derpå Pågår", msg: "Avslutt Dagen Derpå for å starte en ny kveld. Klikk på \"Avslutt\" nederst på Dagen Derpå siden.", buttonTitle: "OK")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        didEnterBackground()
    }
    
    // AT TIMEREN HER STARTE MÅ IMPLEMENTERES SLIK AT OM DU ER I APPEN NÅR KVELDEN ER OVER MØRKES DEN UT
    
    func startTimerUpdateVisuals(){
        visualsTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(FirstViewController.visualsMethod), userInfo: nil, repeats: true)
    }
    
    func didEnterBackground() {
        self.visualsTimer.invalidate()
    }
    
    func didBecomeActive() {
        self.visualsTimer.fire()
    }
    
    func visualsMethod(){
        getIfDayAfterIsRunning()
        getDefaultCheckSessionBool()
        getDefaultBool()
        
        // planlegg kvelden er ferdig/har ikke kjørt
        if(isPlanPartyNotGoing == true){
            updateVisualUnits()
            print("IsPlanPartyNotGoing: \(isPlanPartyNotGoing)")
        }
        // planlegg kvelden er fortsatt i gang, men ikke dagen derpå
        if(isPlanPartyNotGoing == false){
            updateVisualUnitsOnGoingSes()
            updatePromilleLabel()
            print("IsPlanPartyNotGoing: \(isPlanPartyNotGoing)")
        }
        // Dagen derpå er igang, planlegg kvelden er ferdig
        if(isDayAfterOnGoing == true){
            updateVisualUnitsWhenDayAfterIsRunning()
            print("isDayafterongoging == \(isDayAfterOnGoing)")
        }
    }
    
    func dayAfterIsRunningPopUp(titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) in
            print("Dagen Derpå Kjører Pop Up")
            self.tabBarController?.selectedIndex = 3
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isFirstControllerRunned"){
            print("First already launched")
            return true
        }else{
            defaults.setBool(true, forKey: "isFirstControllerRunned")
            print("First launched first time - FIRST VIEW CONT")
            isPlanPartyNotGoing = true
            storeIfSesStartedBool()
            return false
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                    FONTS AND COLORS (0002)                         //
    ////////////////////////////////////////////////////////////////////////
    
    func setColorsFirstView(){
        // COLORS OG FONTS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        containerView.frame = CGRectMake(0, 0, 100, 100)
        containerView.frame.size.height = 600
     
        // SHOW PROMILLE
        oppdaterPromilleLabel.textColor = setAppColors.promilleLabelColors()
        oppdaterPromilleLabel.font = setAppColors.promilleLabelFonts()
     
        self.textViewQuotes.font = setAppColors.setTextQuoteFont(15)
        self.textViewQuotes.textColor = setAppColors.textQuoteColors()
     
     
        // LABELS - NR OF UNITS
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallOlLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.font = setAppColors.textUnderHeadlinesFonts(30)
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.font = setAppColors.textUnderHeadlinesFonts(30)
     
        // TITLE - LABEL
        titleBeer.textColor = setAppColors.textHeadlinesColors()
        titleBeer.font = setAppColors.textHeadlinesFonts(14)
        titleWine.textColor = setAppColors.textHeadlinesColors()
        titleWine.font = setAppColors.textHeadlinesFonts(14)
        titleDrink.textColor = setAppColors.textHeadlinesColors()
        titleDrink.font = setAppColors.textHeadlinesFonts(14)
        titleShot.textColor = setAppColors.textHeadlinesColors()
        titleShot.font = setAppColors.textHeadlinesFonts(14)
     
        // BUTTON FONT
        startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(14)
        startEndPartyBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        addUnitsBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(20)
        minusBeerBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(20)
        setButtonsRounded(setAppColors.roundedCorners())
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                        SJEKK PROMILLE (0003)                       //
    ////////////////////////////////////////////////////////////////////////
    
    func setButtonsRounded(turnOffOn: Bool){
        if(turnOffOn == true){
            // START END KVELDEN 
            startEndPartyBtn.layer.cornerRadius = 25;
            startEndPartyBtn.layer.borderWidth = 0.5;
            startEndPartyBtn.layer.borderColor = UIColor.whiteColor().CGColor
            
            // PLUSS BTN
            addUnitsBtnOutlet.layer.cornerRadius = 25;
            addUnitsBtnOutlet.layer.borderWidth = 0.5;
            addUnitsBtnOutlet.layer.borderColor = UIColor.whiteColor().CGColor
            
            // MINUS BTN
            minusBeerBtnOutlet.layer.cornerRadius = 25;
            minusBeerBtnOutlet.layer.borderWidth = 0.5;
            minusBeerBtnOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    // Kjøres i App Delegate
    func timerShowPromille(){
        var timeTimer = NSTimer()
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("updatePromilleLabel"), userInfo: nil, repeats: true)
    }
    
    func updatePromilleLabel(){
        print("timerShowPromille running (updatePromilleLabel && testingCheckPromilleActive)")
        let currPromille = testingCheckPromilleActive()
        print("Sum On Array updatePromilleLabel(): \(sumOnArray)")
        print("CurrPromille updatePro(): \(currPromille)")
        var promille = ""
        promille = String(format: "%.2f", currPromille)
        self.oppdaterPromilleLabel.text = "\(promille)"
    }
    
    // Kjøres i App Delegate
    func startTimerTesting(){
        var timeTimer = NSTimer()
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("testingCheckPromilleActive"), userInfo: nil, repeats: true)
        print("Timer (First ViewController) started...")
    }
    
    func testingCheckPromilleActive() -> Double{
        countCounter += 1
        print("---------> UPDATE NR. \(countCounter) (FirstViewController) <---------")
        fetchUserData()
        getDefaultCheckSessionBool()
        print("Change Buttons: \(isPlanPartyNotGoing)")
        getDefaultBool()
        print("Change Buttons: \(isPlanPartyNotGoing)")
        
        let checkEntityTS2 = brainCoreData.entityIsEmpty("TimeStamp2")
        let checkEntityStartEndTS = brainCoreData.entityIsEmpty("StartEndTimeStamps")
        
        if(checkEntityStartEndTS == false){
            print("Sesjon Plan Kvelden er i gang! ")
            var getPlanPartyStamps : [NSDate] = [NSDate]()
            getPlanPartyStamps = brainCoreData.getPlanPartySession()
            startOfSessionStamp = getPlanPartyStamps[0]
            
            setEndOfSessionStamp = getPlanPartyStamps[1]
            
            print("End of session stamp in testingcheckProm: \(setEndOfSessionStamp)")
            
            updateStamp = NSDate()
            
            // Finner avstand mellom start-session og slutt-session
            let distance = setEndOfSessionStamp.timeIntervalSinceDate(updateStamp)
            let secToMin = distance / 60
            let minToHour = secToMin / 60
            sumOnArray = 0.0
            
            populateArrays()
            getDefaultCheckSessionBool()
            if(minToHour < 0.0) {
                print("minToHour < 0.0 kjøres...")
                endParty(setEndOfSessionStamp)
            } else {
                
                sumOnArray = 0.0
                
                getIfFirstUnitHasBeenAdded()
                if(hasFirstUnitBeenAdded == true){
                    print("utregningen kjøres...")
                    sumOnArray = brain.liveUpdatePromille(getWeight, gender: getGender, firstUnitAddedTimeS: setDateOnFirstUnitAdded)
                    print("Sum On Array: \(sumOnArray)")
                } else {
                    print("utregningen kjøres IKKE...")
                }
                storeBoolValue()
            }
        } else {
            print("Sesjon ikke i gang (entity tomme) - (FIRST VIEW)")
        }
        return sumOnArray
    }
    
    func endParty(endedPartyStamp: NSDate){
        // RESET ALLE VERDIER, LAGRE HISTORIKK OG SEND INFO TIL DAGEN DERPÅ
        // Change buttons blir true slik at changeButton knappen igjen skal være klar til ny session
        var totalCosts : Int = 0
        getDefaultCheckSessionBool()
        getIfFirstUnitHasBeenAdded()
        fetchUserData()
        
        if(isPlanPartyNotGoing == false) {
            // SESSIONEN ER OVER
            print("Sesjonen har vært startet og er nå over! ")
            
            let printDay = brain.getDayOfWeekAsString(startOfSessionStamp)
            let printDate = brain.getDateOfMonth(startOfSessionStamp)
            let printMonth = brain.getMonthOfYear(startOfSessionStamp)
            let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
            
            let totalBeerCost = getBeerCost * historyCountBeer
            let totalWineCost = getWineCost * historyCountWine
            let totalDrinkCost = getDrinkCost * historyCountDrink
            let totalShotCost = getShotCost * historyCountShot
            totalCosts = totalBeerCost + totalWineCost + totalDrinkCost + totalShotCost
            
            // SJEKKE HØYESTE PROMILLE
            // ATTRIBUTTER
            let termCoreData = "TerminatedTimeStamp"
            let isAppTerminated = brainCoreData.entityIsEmpty(termCoreData)
            if(isAppTerminated == false){
                // SJEKKE OM HØYERE PROMILLE HAR INNTRUFFET NÅR DU HAR LUKKET APPEN
                let checkTerminatedHighPromille = brain.checkHighestPromille(getGender, weight: getWeight, endOfSesStamp: setEndOfSessionStamp, terminatedStamp: brainCoreData.fetchTerminationTimeStamp(), startOfSesStamp: startOfSessionStamp)
                
                if(checkTerminatedHighPromille > highestPromille){
                    highestPromille = checkTerminatedHighPromille
                }
                brainCoreData.clearCoreData(termCoreData)
            }
            /* --- UNMARK DETTE FOR Å LEGGE TIL TEST DATA --- */
            //dummyDataTesting()
            /* DUMMY DATE ENDING ----- ----- ----- ----- ----- */
            
            // UNCHECK DETTE FOR Å FÅ DET "EKTE" IGJEN
            
            print("\n\n\n VERDIENE SOM SEEDES TIL HISTORIKK: ")
            print("Start Dato/Tidspunkt: \(startOfSessionStamp)")
            print("DatoTwo: \(fullDate)")
            print("Antall Øl: \(historyCountBeer)")
            print("Antall Vin: \(historyCountWine)")
            print("Antall Drink: \(historyCountDrink)")
            print("Antall Shot: \(historyCountShot)")
            print("Forbruk: \(totalCosts)")
            print("Høyeste Promille: \(highestPromille)")
            highestPromille = 0.0
            print("Sesjons Nummer: \(numberOfSessionPlanParty)")
            print("End of Sesjon date: \(endedPartyStamp)")
            print("Date on first unit added: \(setDateOnFirstUnitAdded)")
            print("Planlagte enheter: \(getPlannedCounter())")
            print("\n\n")
            
            brainCoreData.seedHistoryValuesPlanParty(startOfSessionStamp, forbruk: totalCosts, hoyestePromille: highestPromille, antallOl: historyCountBeer, antallVin: historyCountWine, antallDrink: historyCountDrink, antallShot: historyCountShot, stringDato: fullDate, endOfSesDate: endedPartyStamp, sessionNumber: numberOfSessionPlanParty, firstUnitStamp: setDateOnFirstUnitAdded, plannedNrOfUnits: getPlannedCounter())
            // KJØR POPULATE GRAPH
            print("brain.pop: w-e-ight: \(getWeight)")
            print("brain.pop: gender: \(getGender)")
            brain.populateGraphValues(getGender, weight: getWeight, startPlanStamp: startOfSessionStamp, endPlanStamp: endedPartyStamp)
 
            // STOPPE ALLE NOTIFICATIONS
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            
            // Nulle ut alle verdiene hvis session er over
            numberOfBeerCount = 0
            numberOfWineCount = 0
            numberOfDrinkCount = 0
            numberOfShotCount = 0
            historyCountBeer = 0
            historyCountWine = 0
            historyCountDrink = 0
            historyCountShot = 0
            counter = 0
            sumOnArray = 0.0
            highestPromille = 0.0
            plannedCounter = 0.0
            unitAlcohol = ""
            universalWineArray.removeAll()
            universalBeerArray.removeAll()
            universalDrinkArray.removeAll()
            universalShotArray.removeAll()
            isPlanPartyNotGoing = true
            hasFirstUnitBeenAdded = false
            storeIsFirstUnitAdded()
            storeIfSesStartedBool()
            storeBoolValue()
            storedPlannedCounter()
            
            // IMPLEMENTER I NY VERSJON
            forgotViewCont.updatePromilleAppDelegate()
        }
    }
    
    func unitAddedAlertController(title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        self.presentViewController(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                 START/END KVELDEN KNAPP (0004)                     //
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func startKveld(sender: AnyObject) {
        let titleValueString = startEndPartyBtn.currentTitle!
        
        if(titleValueString == "Start Kvelden"){
            if (numberOfShotCount == 0 && numberOfBeerCount == 0 && numberOfWineCount == 0 && numberOfDrinkCount == 0) {
                let refreshAlert = UIAlertView()
                refreshAlert.title = "Ingen enhet lagt til"
                refreshAlert.message = "Klikk på enhet for å legge til"
                refreshAlert.addButtonWithTitle("OK")
                refreshAlert.backgroundColor = UIColor.redColor()
                refreshAlert.show()
            } else {
                // Clear database slik at den skal ta inn nye timeStamp
                brainCoreData.clearCoreData("TimeStamp2")
                brainCoreData.clearCoreData("StartEndTimeStamps")
                
                getDefaultCheckSessionBool()
                isPlanPartyNotGoing = false
                storeIfSesStartedBool()
                getDefaultCheckSessionBool()
                
                minusBeerBtnOutlet.enabled = false
                
                updateVisualUnitsOnGoingSes()
                
                // Setter start av session
                startOfSessionStamp = NSDate()
                    
                // Setter slutt tidspunkt på session // .Hour, 12 timer
                setEndOfSessionStamp = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 12, toDate: startOfSessionStamp, options: NSCalendarOptions(rawValue: 0))!
                
                getPrevSessionNumber()
                numberOfSessionPlanParty += 1
                
                storeBoolValue()
                
                brainCoreData.seedStartEndTimeStamp(startOfSessionStamp, endStamp: setEndOfSessionStamp)
               
                plannedCounter = counter
                storedPlannedCounter()
               
                unitAddedAlertController("Kvelden er startet", message: "Have fun og drikk med måte", delayTime: 3.0)
                
                startEndPartyBtn.setTitle("Slutt Kvelden", forState: UIControlState.Normal)
                clearButtonOutlet.enabled = false
            }
        }
        if(titleValueString == "Slutt Kvelden"){
            let title = "Slutt Kvelden"
            let msg = "Er du sikker på at du vil ende kvelden?"
            let cnclTitle = "Avbryt"
            let confTitle = "End Kvelden"
            
            endPartyAlert(title, msg: msg, cancelTitle: cnclTitle, confirmTitle: confTitle)
        }
    }
    
    func endPartyAlert(titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
        }))
        
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.Default, handler:  { action in
            self.setEndOfSessionStamp = NSDate()
            self.brainCoreData.clearCoreData("StartEndTimeStamps")
            self.endParty(self.setEndOfSessionStamp)
            self.brainCoreData.seedStartEndTimeStamp(self.startOfSessionStamp, endStamp: self.setEndOfSessionStamp)
            self.updateVisualUnitsWhenDayAfterIsRunning()
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func randomUnit() -> String{
        let quoteArray = ["Beer", "Wine", "Drink", "Shot"]
        let randomIndex = Int(arc4random_uniform(UInt32(quoteArray.count)))
        let finalString = quoteArray[randomIndex]
        return finalString
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                      ACTION BUTTONS (0005)                         //
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func minusUnitButton(sender: AnyObject) {
        getFetchedValue()
        if(fetchUnitTypeFromSwipe == "Beer"){
            if(isPlanPartyNotGoing == true) {
                if(counter > 0 && numberOfBeerCount > 0){
                    counter -= 1
                    numberOfBeerCount -= 1
                } else {
                    counter = 0
                    numberOfBeerCount = 0
                }
                storeBoolValue()
            }
        }
        if(fetchUnitTypeFromSwipe == "Wine"){
            if(isPlanPartyNotGoing == true) {
                if(counter > 0 && numberOfWineCount > 0){
                    counter -= 1
                    numberOfWineCount -= 1
                } else {
                    counter = 0
                    numberOfWineCount = 0
                }
                storeBoolValue()
            }
        }
        if(fetchUnitTypeFromSwipe == "Drink"){
            if(isPlanPartyNotGoing == true) {
                if(counter > 0  && numberOfDrinkCount > 0){
                    counter -= 1
                    numberOfDrinkCount -= 1
                } else {
                    counter = 0
                    numberOfDrinkCount = 0
                }
                storeBoolValue()
            }
        }
        if(fetchUnitTypeFromSwipe == "Shot"){
            if(isPlanPartyNotGoing == true) {
                if(counter > 0  && numberOfShotCount > 0){
                    counter -= 1
                    numberOfShotCount -= 1
                } else {
                    counter = 0
                    numberOfShotCount = 0
                }
                storeBoolValue()
            }
        }
        updateVisualUnits()
    }
    
    func addNumUnit(unit: String) -> Int{
        let maxPlanUnitValue = 30.0
        var unitCount = 0
        
        if(counter < maxPlanUnitValue){
            counter += 1
            print("counter: \(counter)")
            unitCount += 1
            print("\(unitCount)")
        }
        storeBoolValue()
        popUpPlanParty()
        return unitCount
    }
    
    func addHistUnit(unit: String, numVal: Int, historyValue: Int) -> Int{
        var histUnitCount = 0
        let maxUnitsOverGoal = 5
        
        unitAlcohol = unit
        if(historyValue < (numVal + maxUnitsOverGoal)){
            let todaysTimeStamp = NSDate()
            seedTimeStamp(todaysTimeStamp)
            histUnitCount += 1
            getIfFirstUnitHasBeenAdded()
            if(hasFirstUnitBeenAdded == false){
                setDateOnFirstUnitAdded = NSDate()
                hasFirstUnitBeenAdded = true
                storeIsFirstUnitAdded()
            }
            // ENDRE FRA BEER OG WINE TIL ( ØL OG VIN ) ---- >>
            unitAddedAlertController("\(unit) drukket!", message: "", delayTime: 0.8)
        }
        storeBoolValue()
    
        return histUnitCount
    }
    
    func checkWhichSession(type: String, numValue: Int, histValue: Int) -> Int {
        getFetchedValue()
        getDefaultCheckSessionBool()
        
        var tempValue = 0
        
        if(fetchUnitTypeFromSwipe == type){
            if(isPlanPartyNotGoing == true) {
                tempValue = addNumUnit(type)
            }
            if(isPlanPartyNotGoing == false){
                tempValue = addHistUnit(type, numVal: numValue, historyValue: histValue)
            }
        }
        return tempValue
    }
    
    @IBAction func addUnitButton(sender: AnyObject) {
        getFetchedValue()
        getDefaultCheckSessionBool()
        if(isPlanPartyNotGoing == true) {
            numberOfBeerCount += checkWhichSession("Beer", numValue: numberOfBeerCount, histValue: historyCountBeer)
            numberOfWineCount += checkWhichSession("Wine", numValue: numberOfWineCount, histValue: historyCountWine)
            numberOfDrinkCount += checkWhichSession("Drink", numValue: numberOfDrinkCount, histValue: historyCountDrink)
            numberOfShotCount += checkWhichSession("Shot", numValue: numberOfShotCount, histValue: historyCountShot)
            storeBoolValue()
            updateVisualUnits()
        } else {
            historyCountBeer += checkWhichSession("Beer", numValue: numberOfBeerCount, histValue: historyCountBeer)
            historyCountWine += checkWhichSession("Wine", numValue: numberOfWineCount, histValue: historyCountWine)
            historyCountDrink += checkWhichSession("Drink", numValue: numberOfDrinkCount, histValue: historyCountDrink)
            historyCountShot += checkWhichSession("Shot", numValue: numberOfShotCount, histValue: historyCountShot)
            storeBoolValue()
            updateVisualUnitsOnGoingSes()
        }
    }
    
    func popUpPlanParty(){
        // ADVAR BRUKER OM AT PROMILLEN BLIR HØY MED DETTE ANTALLET
        // HVIS MAN HAR LAGT TIL FOR MANGE ENHETER:
        if(counter == 15){
            unitsAddedPopUp("Høyt Antall", msg: "Er du sikker på dette?", buttonTitle: "OK")
        }
        if(counter >= 30){
            unitsAddedPopUp("Ikke tillatt", msg: "Drikkevett tillater ikke flere enheter\nEndre eller start kvelden", buttonTitle: "OK")
        }
    }
    
    func unitsAddedPopUp(titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
            print("TUILL")
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addActionShot(){
        getDefaultCheckSessionBool()
        if(isPlanPartyNotGoing == true) {
            counter += 1
            numberOfShotCount += 1
            storeBoolValue()
        } else {
            if(numberOfShotCount <= 0){
                numberOfShotCount = 0
                storeBoolValue()
            } else {
                unitAlcohol = "Shot"
                let todaysTimeStamp = NSDate()
                seedTimeStamp(todaysTimeStamp)
                numberOfShotCount -= 1
                historyCountShot += 1
                storeBoolValue()
            }
        }
    }
    
    func updateVisualUnits(){
        self.antallOlLabel.text = "\(numberOfBeerCount)"
        self.antallVinLabel.text = "\(numberOfWineCount)"
        self.antallDrinkLabel.text = "\(numberOfDrinkCount)"
        self.antallShotLabel.text = "\(numberOfShotCount)"
        self.oppdaterPromilleLabel.text = "0.00"
        self.clearButtonOutlet.enabled = true
        self.minusBeerBtnOutlet.enabled = true
        self.minusBeerBtnOutlet.setTitle("Fjern", forState: UIControlState.Normal)
        self.addUnitsBtnOutlet.enabled = true
        self.addUnitsBtnOutlet.setTitle("Legg til", forState: UIControlState.Normal)
        self.startEndPartyBtn.enabled = true
        self.startEndPartyBtn.setTitle("Start Kvelden", forState: UIControlState.Normal)
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(14)
        self.startEndImage.image = UIImage(named: "Ok Filled-100")!
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        
        self.textViewQuotes.text = "Planlegg kvelden din!"
        self.oppdaterPromilleLabel.textColor = UIColor.whiteColor()
        self.textViewQuotes.textColor = UIColor.whiteColor()
        
        // SET CONSTRAINTS TILBAKE
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -45.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        }
        
    }
    
     func updateVisualUnitsOnGoingSes(){
     self.antallOlLabel.text = "\(historyCountBeer)/\(numberOfBeerCount)"
        self.antallVinLabel.text = "\(historyCountWine)/\(numberOfWineCount)"
        self.antallDrinkLabel.text = "\(historyCountDrink)/\(numberOfDrinkCount)"
        self.antallShotLabel.text = "\(historyCountShot)/\(numberOfShotCount)"
        self.clearButtonOutlet.enabled = false
        self.minusBeerBtnOutlet.enabled = false
        self.minusBeerBtnOutlet.setTitle("", forState: UIControlState.Normal)
        self.addUnitsBtnOutlet.enabled = true
        self.addUnitsBtnOutlet.setTitle("Drikk", forState: UIControlState.Normal)
        self.startEndPartyBtn.enabled = true
        self.startEndPartyBtn.setTitle("Slutt Kvelden", forState: UIControlState.Normal)
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(14)
        self.startEndImage.image = UIImage(named: "Cancel Filled-100")!
          
        // CHANGE COLORS ON TO MUCH NUMBERS
        if(historyCountBeer > numberOfBeerCount){
            antallOlLabel.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(historyCountWine > numberOfWineCount){
            antallVinLabel.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(historyCountDrink > numberOfDrinkCount){
            antallDrinkLabel.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(historyCountShot > numberOfShotCount){
            antallShotLabel.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        planPartyUtils.setTextQuote(sumOnArray)
        planPartyUtils.setTextQuoteColor(sumOnArray)
    
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -70.0, -45.0)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -70.0, -30.0)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -70.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -70.0, 0.0)
        }
    }
    
    func updateVisualUnitsWhenDayAfterIsRunning(){
        self.antallOlLabel.text = "-"
        self.antallVinLabel.text = "-"
        self.antallDrinkLabel.text = "-"
        self.antallShotLabel.text = "-"
        self.oppdaterPromilleLabel.text = "0.00"
        self.clearButtonOutlet.enabled = false
        self.minusBeerBtnOutlet.enabled = false
        self.minusBeerBtnOutlet.setTitle("-", forState: UIControlState.Normal)
        self.addUnitsBtnOutlet.enabled = false
        self.addUnitsBtnOutlet.setTitle("-", forState: UIControlState.Normal)
        self.startEndPartyBtn.enabled = false
        self.startEndPartyBtn.setTitle("Dagen Derpå Pågår", forState: UIControlState.Normal)
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(10)
        self.startEndImage.image = UIImage(named: "Ok Filled-100")!
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.textViewQuotes.text = "Dagen Derpå Pågår"
        self.oppdaterPromilleLabel.textColor = UIColor.whiteColor()
        self.textViewQuotes.textColor = UIColor.whiteColor()
        
        // SET CONSTRAINTS TILBAKE
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -45.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        }
    }
    
    // FØRSTE GANGEN SKAL TEXTVIEWET VISE : (swipe for å velge enhet )
    func isPlanPartyViewLunchedBefore()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isViewLunchedBefore = defaults.stringForKey("isPlanPartyViewLunchedBefore"){
            print("View already launched")
            // HVIS REGISTRATION ER FULLFØRT:
            return true
        }else{
            defaults.setBool(true, forKey: "isPlanPartyViewLunchedBefore")
            print("View first time")
            self.textViewQuotes.text = "Swipe for å velge enhet"
            return false
        }
    }

    ////////////////////////////////////////////////////////////////////////
    //                      NULLSTILL ENHETER (0006)                      //
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func clearProps(sender: AnyObject) {
        numberOfBeerCount = 0
        numberOfWineCount = 0
        numberOfDrinkCount = 0
        numberOfShotCount = 0
        counter = 0.0
        updateVisualUnits()
        storeBoolValue()
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    //                        DEFAULT VERDIER (0007)                      //
    ////////////////////////////////////////////////////////////////////////
    
    enum defaultKeys {
        static let keyOne = "wineArrayKey"
        static let keyBool = "boolKey"
        static let beerKey = "beerKey"
        static let wineKey = "wineKey"
        static let drinkKey = "drinkKey"
        static let shotKey = "shotKey"
        static let histBeerKey = "histBeerKey"
        static let histWineKey = "histWineKey"
        static let histDrinkKey = "histDrinkKey"
        static let histShotKey = "histShotKey"
        static let endOfSessionKey = "endOfSessionKey"
        static let startOfSessionKey = "startOfSessionKey"
        static let tempHighPromilleKey = "highPromilleKey"
        static let numberOfSessions = "numOfSes"
        static let saveUnitAlco = "unitAlcokey"
        static let totalNrOfUnits = "totalUnits"
        static let overGoalProm = "overGoalPromilleReached"
        static let fetchUnitType = "fetchUnitTypeKey"
        static let firstUnitAdded = "fetchFirstUnitAddedKey"
        static let storeFirstUnitAddedDate = "dateFirstUnitKey"
        static let keyForPlannedCounter = "plannedCounterKey"
    }
     
     func storedPlannedCounter(){
          let defaults = NSUserDefaults.standardUserDefaults()
          defaults.setDouble(plannedCounter, forKey: defaultKeys.keyForPlannedCounter)
          defaults.synchronize()
     }
     
     func getPlannedCounter() -> Double {
          var tempPlanCounter : Double = 0.0
          let defaults = NSUserDefaults.standardUserDefaults()
          // ANTALL SESJONER ( NR PÅ SESJON )
          if let planCount : Double = defaults.doubleForKey(defaultKeys.keyForPlannedCounter) {
               tempPlanCounter = planCount
          }
          return tempPlanCounter
     }
    
    func storeIfSesStartedBool(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(isPlanPartyNotGoing, forKey: defaultKeys.keyBool)
        defaults.synchronize()
    }
    
    // HAR FØRSTE ENHET BLITT LAGT TIL:
    func storeIsFirstUnitAdded(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(hasFirstUnitBeenAdded, forKey: defaultKeys.firstUnitAdded)
        defaults.setObject(setDateOnFirstUnitAdded, forKey: defaultKeys.storeFirstUnitAddedDate)
        defaults.synchronize()
    }
    
    func getIfFirstUnitHasBeenAdded(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let firstUnitAdded : Bool = defaults.boolForKey(defaultKeys.firstUnitAdded) {
            hasFirstUnitBeenAdded = firstUnitAdded
            print("Is first unit added: \(hasFirstUnitBeenAdded)")
        }
        if let dateFirstUnit : AnyObject = defaults.objectForKey(defaultKeys.storeFirstUnitAddedDate) {
            setDateOnFirstUnitAdded = dateFirstUnit as! NSDate
            print("Date First Unit: \( setDateOnFirstUnitAdded)")
        }
    }
    
    func storeBoolValue(){ // SETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(numberOfBeerCount, forKey: defaultKeys.beerKey)
        defaults.setInteger(numberOfWineCount, forKey: defaultKeys.wineKey)
        defaults.setInteger(numberOfDrinkCount, forKey: defaultKeys.drinkKey)
        defaults.setInteger(numberOfShotCount, forKey: defaultKeys.shotKey)
        defaults.setInteger(historyCountBeer, forKey: defaultKeys.histBeerKey)
        defaults.setInteger(historyCountWine, forKey: defaultKeys.histWineKey)
        defaults.setInteger(historyCountDrink, forKey: defaultKeys.histDrinkKey)
        defaults.setInteger(historyCountShot, forKey: defaultKeys.histShotKey)
        defaults.setObject(highestPromille, forKey: defaultKeys.tempHighPromilleKey)
        defaults.setInteger(numberOfSessionPlanParty, forKey: defaultKeys.numberOfSessions)
        defaults.setObject(unitAlcohol, forKey: defaultKeys.saveUnitAlco)
        defaults.setDouble(counter, forKey: defaultKeys.totalNrOfUnits)
        defaults.setBool(overGoalPromille, forKey: defaultKeys.overGoalProm)
        defaults.synchronize()
        print("storeBoolValue() runned...")
    }
    
    func getPrevSessionNumber(){
        let defaults = NSUserDefaults.standardUserDefaults()
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let sessions : Int = defaults.integerForKey(defaultKeys.numberOfSessions) {
            numberOfSessionPlanParty = sessions
            print("Get prevSes: \(numberOfSessionPlanParty)")
        }
    }
    
    func getIfDayAfterIsRunning(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isRunning : Bool = defaults.boolForKey(SkallMenyBrain.defKeyBool.isDayAfterRun) {
            isDayAfterOnGoing = isRunning
            print("Is day after running: \(isDayAfterOnGoing)")
        }
    }
    
    // LAGRE VALUE TYPES
    func storeFetchValueType(){ // SETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(fetchUnitTypeFromSwipe, forKey: defaultKeys.fetchUnitType)
        defaults.synchronize()
    }
    
    func getFetchedValue(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let fetchedValue : AnyObject = defaults.objectForKey(defaultKeys.fetchUnitType) {
            fetchUnitTypeFromSwipe = fetchedValue as! String
        }
        print("Type hentet: \(fetchUnitTypeFromSwipe)")
    }
    
    func getDefaultCheckSessionBool(){
        let defaults = NSUserDefaults.standardUserDefaults()
        // SESJON START
        if let bool : Bool = defaults.boolForKey(defaultKeys.keyBool) {
            isPlanPartyNotGoing = bool
        }
        print("Is Plan Party NOT on going (false = going): \(isPlanPartyNotGoing)")
    }
    
    func getDefaultOverGoal(){
        let defaults = NSUserDefaults.standardUserDefaults()
        // SESJON START
        if let bool : Bool = defaults.boolForKey(defaultKeys.overGoalProm) {
            overGoalPromille = bool
        }
        print("Over Goal gotten! ")
    }
    
    func getDefaultBool(){ // GETTING
        let defaults = NSUserDefaults.standardUserDefaults()
        // VISUELLE ENHET VERDIER
        if let beer : Int = defaults.integerForKey(defaultKeys.beerKey) {
            numberOfBeerCount = beer
        }
        if let wine : Int = defaults.integerForKey(defaultKeys.wineKey) {
            numberOfWineCount = wine
        }
        if let drink : Int = defaults.integerForKey(defaultKeys.drinkKey) {
            numberOfDrinkCount = drink
        }
        if let shot : Int = defaults.integerForKey(defaultKeys.shotKey) {
            numberOfShotCount = shot
        }
        // ENHET VERDIER SOM FAKTISK BLIR DRUKKET OG DERMED LAGRES
        if let histBeer : Int = defaults.integerForKey(defaultKeys.histBeerKey) {
            historyCountBeer = histBeer
        }
        if let histWine : Int = defaults.integerForKey(defaultKeys.histWineKey) {
            historyCountWine = histWine
        }
        if let histDrink : Int = defaults.integerForKey(defaultKeys.histDrinkKey) {
            historyCountDrink = histDrink
        }
        if let histShot : Int = defaults.integerForKey(defaultKeys.histShotKey) {
            historyCountShot = histShot
        }
        // HØYESTE PROMILLE
        if let theHighestPromille : Double = defaults.doubleForKey(defaultKeys.tempHighPromilleKey) {
            highestPromille = theHighestPromille
            print("GetDefaultBool highProm: \(highestPromille)")
        }
        // ANTALL SESJONER ( NR PÅ SESJON )
        if let sessions : Int = defaults.integerForKey(defaultKeys.numberOfSessions) {
            numberOfSessionPlanParty = sessions
        }
        // TYPE ALKOHOL
        if let alcoUnit : AnyObject = defaults.objectForKey(defaultKeys.saveUnitAlco) {
            unitAlcohol = alcoUnit as! String
        }
        if let totUnitsCount : Double = defaults.doubleForKey(defaultKeys.totalNrOfUnits) {
            counter = totUnitsCount
        }
        print("DefaultBool FIRST gotten...")
    }
    
    ////////////////////////////////////////////////////////////////////////
    //        CORE DATA - SAMHANDLING MED DATABASEN (0008)                //
    ////////////////////////////////////////////////////////////////////////
    
    func seedTimeStamp(currentTimeStamp: NSDate) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("TimeStamp2", inManagedObjectContext: moc) as! TimeStamp2
        
        entity.setValue(currentTimeStamp, forKey: "timeStamp")
        entity.setValue(unitAlcohol, forKey: "unitAlkohol")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func seedUnitTimeStamp(currentTimeStamp: NSDate, typeOfUnit: String) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("TimeStamp2", inManagedObjectContext: moc) as! TimeStamp2
        print("INSIDE SEED UNIT TIME STAMP: ")
        print("Time stamp added: \(currentTimeStamp)")
        print("Type of unit added: \(typeOfUnit)")
        
        entity.setValue(currentTimeStamp, forKey: "timeStamp")
        entity.setValue(typeOfUnit, forKey: "unitAlkohol")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
    
    func populateArrays() {
        print("POPULATE ARRAYS()")
        var timeStamps = [TimeStamp2]()
        
        universalWineArray.removeAll()
        universalBeerArray.removeAll()
        universalDrinkArray.removeAll()
        universalShotArray.removeAll()
        
        let timeStampFetch = NSFetchRequest(entityName: "TimeStamp2")
        do {
            timeStamps = try moc.executeFetchRequest(timeStampFetch) as! [TimeStamp2]
            
            for unitOfAlcohol in timeStamps {
                if (unitOfAlcohol.unitAlkohol! == "Beer"){
                    let beerItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    universalBeerArray.append(beerItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Wine"){
                    let wineItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    universalWineArray.append(wineItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Drink"){
                    let drinkItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    universalDrinkArray.append(drinkItem)
                }
                if (unitOfAlcohol.unitAlkohol! == "Shot"){
                    let shotItem : NSDate = unitOfAlcohol.timeStamp! as NSDate
                    universalDrinkArray.append(shotItem)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func calcualteTotalCosts(beer: Int, wine: Int, drink: Int, shot: Int) -> Int{
        var totalCost = 0
        totalCost = (beer * getBeerCost) + (wine * getWineCost) + (drink * getDrinkCost) + (shot * getShotCost)
        return totalCost
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            
            for item in userData {
                getGender = item.gender! as Bool
                print("get gender from user data: \(getGender)")
                getWeight = item.weight! as Double
                print("get weight from user data: \(getWeight)")
                getBeerCost = item.costsBeer! as Int
                getWineCost = item.costsWine! as Int
                getDrinkCost = item.costsDrink! as Int
                getShotCost = item.costsShot! as Int
                print("Fetched UserData...")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, -124.0)
            
            // BUTTONS
            self.minusBeerBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -45.0)
            self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -45.0)
            
            // STATS-NUMBERS
            self.antallOlLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -60.0)
            self.antallVinLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -60.0)
            self.antallDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -60.0)
            self.antallShotLabel.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -60.0)
            
            // STATS-TITLES
            self.titleBeer.transform = CGAffineTransformTranslate(self.view.transform, 25.0, -70.0)
            self.titleWine.transform = CGAffineTransformTranslate(self.view.transform, 10.0, -70.0)
            self.titleDrink.transform = CGAffineTransformTranslate(self.view.transform, -10.0, -70.0)
            self.titleShot.transform = CGAffineTransformTranslate(self.view.transform, -25.0, -70.0)
            
            // TEXT QUOTES
            self.textViewQuotes.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -24.0)
            self.oppdaterPromilleLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -12.0)

            
            // SLIDER OG SLIDER TEXT
            self.startEndPartyBtn.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            self.startEndImage.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            
            // FONTS
            // TITLE AND QUOTE
            self.textViewQuotes.font = setAppColors.setTextQuoteFont(12)
            self.oppdaterPromilleLabel.font = setAppColors.textHeadlinesFonts(60)
            
            // STATS:
            self.antallOlLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.antallVinLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.antallDrinkLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.antallShotLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            // TITLE STATS:
            self.titleBeer.font = setAppColors.textHeadlinesFonts(12)
            self.titleWine.font = setAppColors.textHeadlinesFonts(12)
            self.titleDrink.font = setAppColors.textHeadlinesFonts(12)
            self.titleShot.font = setAppColors.textHeadlinesFonts(12)

        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
          self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, -90.0)
          
          // BUTTONS
          self.minusBeerBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
          self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -30.0)
          
          // STATS-NUMBERS
          let statsNumbersYVal : CGFloat = -33.0
          self.antallOlLabel.transform = CGAffineTransformTranslate(self.view.transform, 25.0, statsNumbersYVal)
          self.antallVinLabel.transform = CGAffineTransformTranslate(self.view.transform, 10.0, statsNumbersYVal)
          self.antallDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, -10.0, statsNumbersYVal)
          self.antallShotLabel.transform = CGAffineTransformTranslate(self.view.transform, -25.0, statsNumbersYVal)
          
          // STATS-TITLES
          let statsTitlesYVal : CGFloat = -40.0
          self.titleBeer.transform = CGAffineTransformTranslate(self.view.transform, 25.0, statsTitlesYVal)
          self.titleWine.transform = CGAffineTransformTranslate(self.view.transform, 10.0, statsTitlesYVal)
          self.titleDrink.transform = CGAffineTransformTranslate(self.view.transform, -10.0, statsTitlesYVal)
          self.titleShot.transform = CGAffineTransformTranslate(self.view.transform, -25.0, statsTitlesYVal)
          
          // SLIDER OG SLIDER TEXT
          self.startEndPartyBtn.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
          self.startEndImage.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
          
          // FONTS
            
          // STATS:
          self.antallOlLabel.font = setAppColors.textUnderHeadlinesFonts(25)
          self.antallVinLabel.font = setAppColors.textUnderHeadlinesFonts(25)
          self.antallDrinkLabel.font = setAppColors.textUnderHeadlinesFonts(25)
          self.antallShotLabel.font = setAppColors.textUnderHeadlinesFonts(25)
          // TITLE STATS:
          self.titleBeer.font = setAppColors.textHeadlinesFonts(15)
          self.titleWine.font = setAppColors.textHeadlinesFonts(15)
          self.titleDrink.font = setAppColors.textHeadlinesFonts(15)
          self.titleShot.font = setAppColors.textHeadlinesFonts(15)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, -66.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, -32.0)
        }
    }
}