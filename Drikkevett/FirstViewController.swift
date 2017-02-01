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
    let dateUtil = DateUtil()
    var brainCoreData = CoreDataMethods()
    let moc = DataController().managedObjectContext
    var setAppColors = AppColors()
    var forgotViewCont = GlemteEnheterViewController()
    let planPartyUtils = PlanPartyUtil()
    let userDefaultUtils = UserDefaultUtils()
    let statusUtils = StatusUtils()
    
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
    var timeStampTerminated : Date = Date()
    
    // Start/End av sesjon timestamps og updateStamp som er tidspunktet nå
    var startOfSessionStamp : Date = Date()
    var setEndOfSessionStamp : Date = Date()
    var updateStamp : Date = Date()
    
    // Nåværende promille ( blir vist i oppdaterlabel )
    var sumOnArray : Double = 0.0
    
    // ANTALL GANGER STARTTIMER HAR KJØRT
    var countCounter : Int = 0
    
    // SESJONSNUMMER
    var numberOfSessionPlanParty = 0
    
    // TESTING SEGUE
    var someText = ""
    
    // FETCH UNIT TYPE FROM SWIPE
    var fetchUnitTypeFromSwipe = ""
    
    // Har første enhet blitt lagt til
    var hasFirstUnitBeenAdded = false
    var setDateOnFirstUnitAdded = Date()
    
    // TOTAL COSTS VARIABLE
    var costsVariable = 0
    
    //  TIMER VISUALS
    var visualsTimer = Timer()
     
    var plannedCounter : Double = 0
    
    var status : AnyObject = Status.DEFAULT as AnyObject
    
    // GET IF NOTIFICATIONS IS TURNED ON OR OFF
    let instMenu = InnstillingerMenyViewController()
    
    var promilleBAC : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsFirstView()
        setConstraints()
        isPlanPartyViewLunchedBefore()
        
        status = isSessionOver()
        statusHandler(status)
        
        // TIMERS
        checkSessionTimer()
        
        
    }
    
    func isGoalDateReached() -> Bool {
        let coreData = CoreDataMethods()
        return Date().compare(coreData.fetchGoalDate() as Date) == ComparisonResult.orderedDescending
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        status = isSessionOver()
        statusHandler(status)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.isHidden = false
        
        status = isSessionOver()
        statusHandler(status)
        
        if(status as! String == Status.DA_RUNNING){
            dayAfterIsRunningPopUp("Dagen Derpå Pågår", msg: "Avslutt Dagen Derpå for å starte en ny kveld. Klikk på \"Avslutt\" nederst på Dagen Derpå siden.", buttonTitle: "OK")
        }
    }
    
    @IBAction func startKveld(_ sender: AnyObject) {
        if (isGoalDateReached()){
            let alert = UIAlertController(title: "Du har nådd målet ditt", message: "For å kunne starte kvelder må du oppdatere måldato.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Oppdater måldato", style: .default) { action in
                self.performSegue(withIdentifier: "goalDateSegue2", sender: self)
            })
            alert.addAction(UIAlertAction(title: "Sett senere", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let titleValueString = startEndPartyBtn.currentTitle!
        if(titleValueString == "Start Kvelden"){
            startBtnHandler()
        }
        if(titleValueString == "Avslutt Kvelden"){
            endBtnHandler()
        }
        statusHandler(status)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goalDateSegue2" {
            let vc = segue.destination
            if vc is GratulasjonsViewController {
                let grat = vc as! GratulasjonsViewController
                grat.cameFrom = "plan"
            }
        }
    }*/
    
    @IBAction func minusUnitButton(_ sender: AnyObject) {
        fetchUnitTypeFromSwipe = userDefaultUtils.getFetchedValue()
        if(status as! String == Status.NOT_RUNNING){
            minusBtnNotRunning()
        }
        if(status as! String == Status.RUNNING){
            minusBtnRunning()
        }
        status = statusUtils.getState()
        statusHandler(status)
    }
    
    @IBAction func addUnitButton(_ sender: AnyObject) {
        fetchUnitTypeFromSwipe = userDefaultUtils.getFetchedValue()
        if(status as! String == Status.NOT_RUNNING){
            numberOfBeerCount += checkWhichSession("Beer", numValue: numberOfBeerCount, histValue: historyCountBeer)
            numberOfWineCount += checkWhichSession("Wine", numValue: numberOfWineCount, histValue: historyCountWine)
            numberOfDrinkCount += checkWhichSession("Drink", numValue: numberOfDrinkCount, histValue: historyCountDrink)
            numberOfShotCount += checkWhichSession("Shot", numValue: numberOfShotCount, histValue: historyCountShot)
            storePlannedUnits()
        }
        if(status as! String == Status.RUNNING){
            historyCountBeer += checkWhichSession("Beer", numValue: numberOfBeerCount, histValue: historyCountBeer)
            historyCountWine += checkWhichSession("Wine", numValue: numberOfWineCount, histValue: historyCountWine)
            historyCountDrink += checkWhichSession("Drink", numValue: numberOfDrinkCount, histValue: historyCountDrink)
            historyCountShot += checkWhichSession("Shot", numValue: numberOfShotCount, histValue: historyCountShot)
            storeConsumedUnits()
        }
        status = statusUtils.getState()
        statusHandler(status)
    }
    
    @IBAction func clearProps(_ sender: AnyObject) {
        numberOfBeerCount = 0
        numberOfWineCount = 0
        numberOfDrinkCount = 0
        numberOfShotCount = 0
        counter = 0.0
        storePlannedUnits()
        statusHandler(status)
    }
    
    /*
     START/END BUTTON
     */
    
    func startBtnHandler(){
        if (numberOfShotCount == 0 && numberOfBeerCount == 0 && numberOfWineCount == 0 && numberOfDrinkCount == 0) {
            let refreshAlert = UIAlertView()
            refreshAlert.title = "Ingen enhet lagt til"
            refreshAlert.message = "Klikk på enhet for å legge til"
            refreshAlert.addButton(withTitle: "OK")
            refreshAlert.backgroundColor = UIColor.red
            refreshAlert.show()
        } else {
            // Clear database slik at den skal ta inn nye timeStamp
            brainCoreData.clearCoreData("TimeStamp2")
            brainCoreData.clearCoreData("StartEndTimeStamps")
            
            // Setter start av session
            startOfSessionStamp = Date()
            
            // Setter slutt tidspunkt på session // .Hour, 12 timer
            setEndOfSessionStamp = (Calendar.current as NSCalendar).date(byAdding: .hour, value: 12, to: startOfSessionStamp, options: NSCalendar.Options(rawValue: 0))!
            
            numberOfSessionPlanParty = userDefaultUtils.getPrevSessionNumber()
            print("Prev sessionNumber: \(numberOfSessionPlanParty)")
            numberOfSessionPlanParty += 1
            print("New sessionNumber: \(numberOfSessionPlanParty)")
            storePlannedUnits()
            userDefaultUtils.storeSessionNumber(numberOfSessionPlanParty)
            
            brainCoreData.seedStartEndTimeStamp(startOfSessionStamp, endStamp: setEndOfSessionStamp)
            
            plannedCounter = counter
            userDefaultUtils.storedPlannedCounter(plannedCounter)
            
            unitAddedAlertController("Kvelden er startet", message: "Ha det gøy og drikk med måte!", delayTime: 3.0)
            
            startEndPartyBtn.setTitle("Avslutt Kvelden", for: UIControlState())
            clearButtonOutlet.isEnabled = false
            
            status = Status.RUNNING as AnyObject
            statusUtils.setState(status)
        }
    }
    
    func endBtnHandler(){
        var title = ""
        var msg = ""
        var cnclTitle = ""
        var confTitle = ""
        
        let sesPlanKveldIntervall = Date().timeIntervalSince(startOfSessionStamp)
        if(sesPlanKveldIntervall < 900){
            title = "Avslutt Kvelden"
            msg = "Avslutter du kvelden før 15 minutter vil ingen historikk lagres!"
            cnclTitle = "Avbryt"
            confTitle = "Avslutt Kvelden"
            endPartyAlert(title, msg: msg, cancelTitle: cnclTitle, confirmTitle: confTitle)
            print("Kvelden var mindre enn 15 minutter")
        } else {
            print("Kvelden var mer enn 15 minutter")
            title = "Avslutt Kvelden"
            msg = "Er du sikker på at du vil ende kvelden?"
            cnclTitle = "Avbryt"
            confTitle = "Avslutt Kvelden"
            endPartyAlert(title, msg: msg, cancelTitle: cnclTitle, confirmTitle: confTitle)
        }
    }
    
    func endPartyAlert(_ titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.default, handler:  { action in
            let sesPlanKveldIntervall = Date().timeIntervalSince(self.startOfSessionStamp)
            if(sesPlanKveldIntervall < 900){
                self.lessThanFifteenEndMethod()
            } else {
                self.endPartyMethod()
            }
        }))
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.destructive, handler:{ (action: UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func endPartyMethod(){
        self.setEndOfSessionStamp = Date()
        self.brainCoreData.clearCoreData("StartEndTimeStamps")
        self.endParty(self.setEndOfSessionStamp)
        self.brainCoreData.seedStartEndTimeStamp(self.startOfSessionStamp, endStamp: self.setEndOfSessionStamp)
        self.status = Status.DA_RUNNING as AnyObject
        self.statusUtils.setState(self.status)
        self.dayAfterIsRunningAlertController("Dagen Derpå i gang", message: "Sjekk Dagen Derpå", delayTime: 2.5)
        statusHandler(status)
    }
    
    func lessThanFifteenEndMethod(){
        status = Status.NOT_RUNNING as AnyObject
        statusUtils.setState(status)
        brainCoreData.clearCoreData("StartEndTimeStamps")
        brainCoreData.clearCoreData("TimeStamp2")
        clearAllValues()
        statusHandler(status)
    }
    
    /*
     MINUS BTN
     */
    
    func minusBtnNotRunning(){
        if(fetchUnitTypeFromSwipe == "Beer"){
            if(counter > 0 && numberOfBeerCount > 0){
                counter -= 1
                numberOfBeerCount -= 1
            } else {
                counter = 0
                numberOfBeerCount = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Wine"){
            if(counter > 0 && numberOfWineCount > 0){
                counter -= 1
                numberOfWineCount -= 1
            } else {
                counter = 0
                numberOfWineCount = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Drink"){
            if(counter > 0  && numberOfDrinkCount > 0){
                counter -= 1
                numberOfDrinkCount -= 1
            } else {
                counter = 0
                numberOfDrinkCount = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Shot"){
            if(counter > 0  && numberOfShotCount > 0){
                counter -= 1
                numberOfShotCount -= 1
            } else {
                counter = 0
                numberOfShotCount = 0
            }
        }
        storePlannedUnits()
    }
    
    func minusBtnRunning(){
        if(fetchUnitTypeFromSwipe == "Beer"){
            if(historyCountBeer > 0){
                historyCountBeer -= 1
                brainCoreData.deleteLastUnitAdded("Beer")
            } else {
                historyCountBeer = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Wine"){
            if(historyCountWine > 0){
                historyCountWine -= 1
                brainCoreData.deleteLastUnitAdded("Wine")
            } else {
                historyCountWine = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Drink"){
            if(historyCountDrink > 0){
                historyCountDrink -= 1
                brainCoreData.deleteLastUnitAdded("Drink")
            } else {
                historyCountDrink = 0
            }
        }
        if(fetchUnitTypeFromSwipe == "Shot"){
            if(historyCountShot > 0){
                historyCountShot -= 1
                brainCoreData.deleteLastUnitAdded("Shot")
            } else {
                historyCountShot = 0
            }
        }
        if((historyCountBeer + historyCountWine + historyCountDrink + historyCountShot) == 0){
            promilleBAC = 0.0
            hasFirstUnitBeenAdded = false
            setDateOnFirstUnitAdded = Date()
            storeIsFirstUnitAdded()
        }
        storeConsumedUnits()
    }
    
    /*
     ADD BTN
     */
    
    func addNumUnit(_ unit: String) -> Int{
        let maxPlanUnitValue = 30.0
        var unitCount = 0
        
        if(counter < maxPlanUnitValue){
            counter += 1
            print("counter: \(counter)")
            unitCount += 1
            print("\(unitCount)")
        }
        popUpPlanParty()
        return unitCount
    }
    
    func addHistUnit(_ unit: String, numVal: Int, historyValue: Int) -> Int{
        var histUnitCount = 0
        let maxUnitsOverGoal = 5
        
        if(historyValue < (numVal + maxUnitsOverGoal)){
            let todaysTimeStamp = Date()
            brainCoreData.seedTimeStamp(todaysTimeStamp, unitAlcohol: unit)
            histUnitCount += 1
            getIfFirstUnitHasBeenAdded()
            if(hasFirstUnitBeenAdded == false){
                print("First unit added again! ")
                setDateOnFirstUnitAdded = Date()
                hasFirstUnitBeenAdded = true
                storeIsFirstUnitAdded()
            }
            // ENDRE FRA BEER OG WINE TIL ( ØL OG VIN ) ---- >>
            var tempUnit = ""
            if unit == "Beer" {
                tempUnit = "Øl"
            }
            if unit == "Wine" {
                tempUnit = "Vin"
            }
            if unit == "Drink" {
                tempUnit = "Drink"
            }
            if unit == "Shot" {
                tempUnit = "Shot"
            }
            
            unitAddedAlertController("\(tempUnit) drukket!", message: "", delayTime: 0.8)
        }
        return histUnitCount
    }
    
    func checkWhichSession(_ type: String, numValue: Int, histValue: Int) -> Int {
        var tempValue = 0
        
        if(fetchUnitTypeFromSwipe == type){
            if(status as! String == Status.NOT_RUNNING){
                tempValue = addNumUnit(type)
            }
            if(status as! String == Status.RUNNING){
                tempValue = addHistUnit(type, numVal: numValue, historyValue: histValue)
            }
        }
        return tempValue
    }
    
    func popUpPlanParty(){
        if(counter == 15){
            unitsAddedPopUp("Høyt Antall", msg: "Er du sikker på dette?", buttonTitle: "OK")
        }
        if(counter >= 30){
            unitsAddedPopUp("Ikke tillatt", msg: "Drikkevett tillater ikke flere enheter\nEndre eller start kvelden", buttonTitle: "OK")
        }
    }
    
    func unitsAddedPopUp(_ titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.destructive, handler:{ (action: UIAlertAction!) in
            print("TUILL")
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
     STATUS
     */
    
    func statusHandler(_ status : AnyObject){
        fetchUser()
        getUnit_userDefaults()
        
        if(status as! String == Status.NOT_RUNNING){
            partyNotRunning()
        }
        if(status as! String == Status.RUNNING){
            partyRunning()
        }
        if(status as! String == Status.DA_RUNNING){
            dayAfterRunning()
        }
    }
    
    func partyNotRunning(){
        visuals_PP_not_running()
    }
    
    func partyRunning(){
        currentBAC()
        visuals_PP_running()
    }
    
    func dayAfterRunning(){
        visuals_DA_running()
        let currentTime = Date()
        if(!checkIfHistValueExists()){
            endParty(setEndOfSessionStamp)
        }
    }
    
    func checkIfHistValueExists() -> Bool{
        var itExists = false
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for row in historikk {
                if(row.dato! as Date == startOfSessionStamp){
                    itExists = true
                } else {
                    itExists = false
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return itExists
    }
    
    func checkSessionTimer(){
        var timeTimer = Timer()
        timeTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(FirstViewController.updateSession), userInfo: nil, repeats: true)
    }
    
    func updateSession(){
        print("THIS RUNS")
        status = isSessionOver()
        statusHandler(status)
        print("THIS DONT")
    }
    
    func isSessionOver() -> AnyObject{
        let isStartEndEmpty = brainCoreData.entityIsEmpty("StartEndTimeStamps")
        if(isStartEndEmpty == true){
            status = Status.NOT_RUNNING as AnyObject
        } else {
            getSessionStamps()
            let currentTimeStamp = Date()
            let distance = setEndOfSessionStamp.timeIntervalSince(currentTimeStamp)
            let secToMin = distance / 60
            let minToHour = secToMin / 60
            if(minToHour < 0.0) {
                status = Status.DA_RUNNING as AnyObject
            } else {
                status = Status.RUNNING as AnyObject
            }
        }
        statusUtils.setState(status)
        print("Status: \(status)")
        return status
    }
    
    func getSessionStamps(){
        var getPlanPartyStamps : [Date] = [Date]()
        getPlanPartyStamps = brainCoreData.getPlanPartySession() as [Date]
        startOfSessionStamp = getPlanPartyStamps[0]
        setEndOfSessionStamp = getPlanPartyStamps[1]
    }
    
    func currentBAC(){
        getIfFirstUnitHasBeenAdded()
        if(hasFirstUnitBeenAdded == true){
            promilleBAC = brain.liveUpdatePromille(fetchUser().weight, gender: fetchUser().gender, firstUnitAddedTimeS: setDateOnFirstUnitAdded)
            print("Promille BAC: \(promilleBAC)")
        }
    }
    
    func endParty(_ endedPartyStamp: Date){
        var totalCosts : Int = 0
        getIfFirstUnitHasBeenAdded()
        fetchUser()
        
        let printDay = dateUtil.getDayOfWeekAsString(startOfSessionStamp)
        let printDate = dateUtil.getDateOfMonth(startOfSessionStamp)
        let printMonth = dateUtil.getMonthOfYear(startOfSessionStamp)
        let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
        totalCosts = calcualteTotalCosts(historyCountBeer, wine: historyCountWine, drink: historyCountDrink, shot: historyCountShot)
        
        brainCoreData.seedHistoryValuesPlanParty(startOfSessionStamp, forbruk: totalCosts, hoyestePromille: 0.0, antallOl: historyCountBeer, antallVin: historyCountWine, antallDrink: historyCountDrink, antallShot: historyCountShot, stringDato: fullDate, endOfSesDate: endedPartyStamp, sessionNumber: numberOfSessionPlanParty, firstUnitStamp: setDateOnFirstUnitAdded, plannedNrOfUnits: userDefaultUtils.getPlannedCounter())
        // KJØR POPULATE GRAPH
        brain.populateGraphValues(fetchUser().gender, weight: fetchUser().weight, startPlanStamp: startOfSessionStamp, endPlanStamp: endedPartyStamp, sessionNumber: numberOfSessionPlanParty)
        
        // Nulle ut alle verdiene hvis session er over
        clearAllValues()
    }
    
    func clearAllValues(){
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
        promilleBAC = 0.0
        plannedCounter = 0.0
        hasFirstUnitBeenAdded = false
        storeIsFirstUnitAdded()
        //storePlannedUnits()
        storeConsumedUnits()
        userDefaultUtils.storedPlannedCounter(plannedCounter)
    }
    
    func calcualteTotalCosts(_ beer: Int, wine: Int, drink: Int, shot: Int) -> Int{
        var totalCost = 0
        totalCost = (beer * fetchUser().beerCost) + (wine * fetchUser().wineCost) + (drink * fetchUser().drinkCost) + (shot * fetchUser().shotCost)
        return totalCost
    }
    
    /*
     POP UPS
     */
    
    func unitAddedAlertController(_ title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func dayAfterIsRunningAlertController(_ title: String, message: String, delayTime: Double){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func dayAfterIsRunningPopUp(_ titleMsg: String, msg: String, buttonTitle:String){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            print("Dagen Derpå Kjører Pop Up")
            self.tabBarController?.selectedIndex = 3
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
     USER DEFAULTS
     */
    
    func storeIsFirstUnitAdded(){
        let defaults = UserDefaults.standard
        defaults.set(hasFirstUnitBeenAdded, forKey: defaultKeys.firstUnitAdded)
        defaults.set(setDateOnFirstUnitAdded, forKey: defaultKeys.storeFirstUnitAddedDate)
        defaults.synchronize()
    }
    
    func storePlannedUnits(){
        let defaults = UserDefaults.standard
        defaults.set(numberOfBeerCount, forKey: defaultKeys.beerKey)
        defaults.set(numberOfWineCount, forKey: defaultKeys.wineKey)
        defaults.set(numberOfDrinkCount, forKey: defaultKeys.drinkKey)
        defaults.set(numberOfShotCount, forKey: defaultKeys.shotKey)
        defaults.set(counter, forKey: defaultKeys.totalNrOfUnits)
        defaults.synchronize()
    }
    
    func storeConsumedUnits(){
        let defaults = UserDefaults.standard
        defaults.set(historyCountBeer, forKey: defaultKeys.histBeerKey)
        defaults.set(historyCountWine, forKey: defaultKeys.histWineKey)
        defaults.set(historyCountDrink, forKey: defaultKeys.histDrinkKey)
        defaults.set(historyCountShot, forKey: defaultKeys.histShotKey)
        defaults.synchronize()
    }
    
    func storeFetchValueType(){ // SETTING
        let defaults = UserDefaults.standard
        defaults.set(fetchUnitTypeFromSwipe, forKey: defaultKeys.fetchUnitType)
        defaults.synchronize()
    }
    
    func getIfFirstUnitHasBeenAdded(){
        let defaults = UserDefaults.standard
        if let firstUnitAdded : Bool = defaults.bool(forKey: defaultKeys.firstUnitAdded) {
            hasFirstUnitBeenAdded = firstUnitAdded
        }
        if let dateFirstUnit : AnyObject = defaults.object(forKey: defaultKeys.storeFirstUnitAddedDate) as AnyObject? {
            setDateOnFirstUnitAdded = dateFirstUnit as! Date
        }
    }
    
    func getUnit_userDefaults(){ // GETTING
        let defaults = UserDefaults.standard
        // VISUELLE ENHET VERDIER
        if let beer : Int = defaults.integer(forKey: defaultKeys.beerKey) {
            numberOfBeerCount = beer
        }
        if let wine : Int = defaults.integer(forKey: defaultKeys.wineKey) {
            numberOfWineCount = wine
        }
        if let drink : Int = defaults.integer(forKey: defaultKeys.drinkKey) {
            numberOfDrinkCount = drink
        }
        if let shot : Int = defaults.integer(forKey: defaultKeys.shotKey) {
            numberOfShotCount = shot
        }
        if let histBeer : Int = defaults.integer(forKey: defaultKeys.histBeerKey) {
            historyCountBeer = histBeer
        }
        if let histWine : Int = defaults.integer(forKey: defaultKeys.histWineKey) {
            historyCountWine = histWine
        }
        if let histDrink : Int = defaults.integer(forKey: defaultKeys.histDrinkKey) {
            historyCountDrink = histDrink
        }
        if let histShot : Int = defaults.integer(forKey: defaultKeys.histShotKey) {
            historyCountShot = histShot
        }
        if let sessions : Int = defaults.integer(forKey: defaultKeys.numberOfSessions) {
            numberOfSessionPlanParty = sessions
        }
        if let totUnitsCount : Double = defaults.double(forKey: defaultKeys.totalNrOfUnits) {
            counter = totUnitsCount
        }
    }
    
    /*
     GET USER VALUES
     */
    
    func fetchUser() -> User{
        var userData = [UserData]()
        var user : User!
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            for item in userData {
                let tempUuser = User(gender: item.gender! as Bool, weight: item.weight! as Double, beerCost: item.costsBeer! as Int, wineCost: item.costsWine! as Int, drinkCost: item.costsDrink! as Int, shotCost: item.costsShot! as Int)
                user = tempUuser
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return user
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isPlanPartyViewLunchedBefore()->Bool{
        let defaults = UserDefaults.standard
        if let isViewLunchedBefore = defaults.string(forKey: "isPlanPartyViewLunchedBefore"){
            return true
        }else{
            defaults.set(true, forKey: "isPlanPartyViewLunchedBefore")
            self.textViewQuotes.text = "Swipe for å velge enhet"
            return false
        }
    }
    
    /*
     VISUALS
     */
    
    func visuals_PP_not_running(){
        self.antallOlLabel.text = "\(numberOfBeerCount)"
        self.antallVinLabel.text = "\(numberOfWineCount)"
        self.antallDrinkLabel.text = "\(numberOfDrinkCount)"
        self.antallShotLabel.text = "\(numberOfShotCount)"
        self.oppdaterPromilleLabel.text = "0.00"
        self.clearButtonOutlet.isEnabled = true
        self.minusBeerBtnOutlet.isEnabled = true
        self.minusBeerBtnOutlet.setTitle("Fjern", for: UIControlState())
        self.addUnitsBtnOutlet.isEnabled = true
        self.addUnitsBtnOutlet.setTitle("Legg til", for: UIControlState())
        self.startEndPartyBtn.isEnabled = true
        self.startEndPartyBtn.setTitle("Start Kvelden", for: UIControlState())
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(14)
        self.startEndImage.image = UIImage(named: "Ok Filled-100")!
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        
        hideOutlets(false)
        
        self.textViewQuotes.text = "Planlegg kvelden din!"
        self.oppdaterPromilleLabel.textColor = UIColor.white
        self.textViewQuotes.textColor = UIColor.white
        
        // SET CONSTRAINTS TILBAKE
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: -10.0, y: -45.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -30.0)
            //self.addUnitsBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 0.0)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: 0.0)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: 0.0)
        }
    }
    
    func visuals_PP_running(){
        self.antallOlLabel.text = "\(historyCountBeer)/\(numberOfBeerCount)"
        self.antallVinLabel.text = "\(historyCountWine)/\(numberOfWineCount)"
        self.antallDrinkLabel.text = "\(historyCountDrink)/\(numberOfDrinkCount)"
        self.antallShotLabel.text = "\(historyCountShot)/\(numberOfShotCount)"
        let formatBAC = String(format: "%.2f", promilleBAC)
        self.oppdaterPromilleLabel.text = "\(formatBAC)"
        self.clearButtonOutlet.isEnabled = false
        self.minusBeerBtnOutlet.isEnabled = true
        self.minusBeerBtnOutlet.setTitle("Fjern", for: UIControlState())
        self.addUnitsBtnOutlet.isEnabled = true
        self.addUnitsBtnOutlet.setTitle("Drikk", for: UIControlState())
        self.startEndPartyBtn.isEnabled = true
        self.startEndPartyBtn.setTitle("Avslutt Kvelden", for: UIControlState())
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(14)
        self.startEndImage.image = UIImage(named: "Cancel Filled-100")!
        
        hideOutlets(false)
        
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
    }
    
    func visuals_DA_running(){
        hideOutlets(true)
        
        self.clearButtonOutlet.isEnabled = false
        
        self.startEndPartyBtn.setTitle("Dagen Derpå Pågår", for: UIControlState())
        self.startEndPartyBtn.titleLabel?.font = setAppColors.buttonFonts(10)
        self.startEndImage.image = UIImage(named: "Ok Filled-100")!
        
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.oppdaterPromilleLabel.textColor = UIColor.white
        self.textViewQuotes.textColor = UIColor.white
    }
    
    func hideOutlets(_ isOutletHidden: Bool){
        self.antallOlLabel.isHidden = isOutletHidden
        self.antallVinLabel.isHidden = isOutletHidden
        self.antallDrinkLabel.isHidden = isOutletHidden
        self.antallShotLabel.isHidden = isOutletHidden
        self.oppdaterPromilleLabel.isHidden = isOutletHidden
        self.minusBeerBtnOutlet.isHidden = isOutletHidden
        self.addUnitsBtnOutlet.isHidden = isOutletHidden
        self.startEndPartyBtn.isHidden = isOutletHidden
        self.startEndImage.isHidden = isOutletHidden
        self.containerView.isHidden = isOutletHidden
        self.titleBeer.isHidden = isOutletHidden
        self.titleWine.isHidden = isOutletHidden
        self.titleDrink.isHidden = isOutletHidden
        self.titleShot.isHidden = isOutletHidden
        self.textViewQuotes.isHidden = isOutletHidden
    }
    
    func setColorsFirstView(){
        // COLORS OG FONTS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
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
        startEndPartyBtn.titleLabel?.textAlignment = NSTextAlignment.center
        addUnitsBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(20)
        minusBeerBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(20)
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.containerView.transform = self.containerView.transform.translatedBy(x: 0.0, y: -124.0)
            
            // BUTTONS
            self.minusBeerBtnOutlet.transform = self.view.transform.translatedBy(x: 10.0, y: -45.0)
            self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: -10.0, y: -45.0)
            
            // STATS-NUMBERS
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: 25.0, y: -60.0)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: 10.0, y: -60.0)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: -10.0, y: -60.0)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: -25.0, y: -60.0)
            
            // STATS-TITLES
            self.titleBeer.transform = self.view.transform.translatedBy(x: 25.0, y: -70.0)
            self.titleWine.transform = self.view.transform.translatedBy(x: 10.0, y: -70.0)
            self.titleDrink.transform = self.view.transform.translatedBy(x: -10.0, y: -70.0)
            self.titleShot.transform = self.view.transform.translatedBy(x: -25.0, y: -70.0)
            
            // TEXT QUOTES
            self.textViewQuotes.transform = self.view.transform.translatedBy(x: 0.0, y: -24.0)
            self.oppdaterPromilleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: -12.0)

            
            // SLIDER OG SLIDER TEXT
            self.startEndPartyBtn.transform = self.view.transform.translatedBy(x: 0.0, y: 12.0)
            self.startEndImage.transform = self.view.transform.translatedBy(x: 0.0, y: 12.0)
            
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

        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
          self.containerView.transform = self.containerView.transform.translatedBy(x: 0.0, y: -90.0)
          
          // BUTTONS
          self.minusBeerBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -30.0)
          self.addUnitsBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: -30.0)
          
          // STATS-NUMBERS
          let statsNumbersYVal : CGFloat = -33.0
          self.antallOlLabel.transform = self.view.transform.translatedBy(x: 25.0, y: statsNumbersYVal)
          self.antallVinLabel.transform = self.view.transform.translatedBy(x: 10.0, y: statsNumbersYVal)
          self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: -10.0, y: statsNumbersYVal)
          self.antallShotLabel.transform = self.view.transform.translatedBy(x: -25.0, y: statsNumbersYVal)
          
          // STATS-TITLES
          let statsTitlesYVal : CGFloat = -40.0
          self.titleBeer.transform = self.view.transform.translatedBy(x: 25.0, y: statsTitlesYVal)
          self.titleWine.transform = self.view.transform.translatedBy(x: 10.0, y: statsTitlesYVal)
          self.titleDrink.transform = self.view.transform.translatedBy(x: -10.0, y: statsTitlesYVal)
          self.titleShot.transform = self.view.transform.translatedBy(x: -25.0, y: statsTitlesYVal)
          
          // SLIDER OG SLIDER TEXT
          self.startEndPartyBtn.transform = self.view.transform.translatedBy(x: 0.0, y: 12.0)
          self.startEndImage.transform = self.view.transform.translatedBy(x: 0.0, y: 12.0)
          
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
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            self.containerView.transform = self.containerView.transform.translatedBy(x: 0.0, y: -66.0)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            self.containerView.transform = self.containerView.transform.translatedBy(x: 0.0, y: -32.0)
        }
    }
}

