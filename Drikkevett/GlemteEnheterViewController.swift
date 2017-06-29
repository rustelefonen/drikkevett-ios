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
    @IBOutlet weak var costsTitleLabel: UILabel!
    @IBOutlet weak var yestHighestPromTitleLabel: UILabel!
    @IBOutlet weak var currPromTitleLabel: UILabel!
    @IBOutlet weak var endDayAfterButtonOutlet: UIButton!
    @IBOutlet weak var overallTitle: UILabel!
    @IBOutlet weak var overallSubtitle: UILabel!
    @IBOutlet weak var xImageBtn: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    let moc = AppDelegate.getManagedObjectContext()
    let brainCoreData = CoreDataMethods()
    let dateUtil = DateUtil()
    let brain = SkallMenyBrain()
    var setAppColors = AppColors()
    let statusUtils = StatusUtils()
    let dayAfterUtils = DayAfterUtils()
    
    // endOf og startOf Planlegg kvelden sesjon
    var startOfPlanPartyStamp : Date = Date()
    var endOfPlanPartyStamp : Date = Date()
    
    // hente sessionsnummer
    var fetchSessionNumber : Int = 0
    
    // STORE DEFAULT VALUES
    var consumedBeers = 0
    var consumedWines = 0
    var consumedDrinks = 0
    var consumedShots = 0
    var plannedBeers = 0
    var plannedWines = 0
    var plannedDrink = 0
    var plannedShots = 0
    
    var costs = 0
    var yestHighProm = 0.0
    var currentBAC = 0.0
    var totalUnits = 0
    var totalPlannedUnits = 0
    
    // pluss / minus
    var goalReached = 6
    var overGoal = 3
    
    let pieChartValue = [String]()
    
    // SLICE COLORS
    var beerSliceColor = UIColor()
    var wineSliceColor = UIColor()
    var drinkSliceColor = UIColor()
    var shotSliceColor = UIColor()
    
    // planlagte enheter
    var plannedNumberOfUnits = 0
    
    var status : AnyObject = Status.DEFAULT as AnyObject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsAndFontsDagenDerpa()
        
        status = statusUtils.getState()
        stateHandler(status)
        fillPieChart()
        
        checkSessionTimer()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.isHidden = false
        
        status = statusUtils.getState()
        stateHandler(status)
        fillPieChart()
    }
    
    /*
     STATUS
     */
    
    func checkSessionTimer(){
        var timeTimer = Timer()
        timeTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(GlemteEnheterViewController.updateStatus), userInfo: nil, repeats: true)
    }
    
    func updateStatus(){
        status = statusUtils.getState()
        stateHandler(status)
    }
    
    func stateHandler(_ status : AnyObject){
        brainCoreData.fetchUserData()
        getUnits()
        getPlannedUnits()
        
        if(status as! String == Status.DA_RUNNING){
            dayAfterRunning()
        }
        if(status as! String == Status.DEFAULT || status as! String == Status.RUNNING || status as! String == Status.NOT_RUNNING){
            notRunning()
        }
    }
    
    func dayAfterRunning(){
        setStats()
        visuals_DA_running()
    }
    
    func notRunning(){
        visuals_not_running()
    }
    
    func setStats(){
        totalUnits = consumedBeers + consumedWines + consumedDrinks + consumedShots
        totalPlannedUnits = plannedBeers + plannedWines + plannedDrink + plannedShots
        currentBAC = calculateCurrentBAC()
        yestHighProm = dayAfterUtils.getHighestBAC()
        costs = calculateCosts(consumedBeers, w: consumedWines, d: consumedDrinks, s: consumedShots)
    }
    
    func calculateCurrentBAC() -> Double{
        return brain.liveUpdatePromille(brainCoreData.fetchUserData().weight, gender: brainCoreData.fetchUserData().gender, firstUnitAddedTimeS: brainCoreData.getFirstUnitAddedTimeStamp())
    }
    
    func getUnits(){
        var historikk = [Historikk]()
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        timeStampFetch.sortDescriptors = [NSSortDescriptor(key: "dato", ascending: false)]
        timeStampFetch.fetchLimit = 1
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for antOlLoop in historikk {
                consumedBeers = antOlLoop.antallOl! as Int
            }
            for antWineLoop in historikk {
                consumedWines = antWineLoop.antallVin! as Int
            }
            for antDriLoop in historikk {
                consumedDrinks = antDriLoop.antallDrink! as Int
            }
            for antShoLoop in historikk {
                consumedShots = antShoLoop.antallShot! as Int
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func calculateCosts(_ b:Int, w:Int, d:Int, s:Int) -> Int{
        return ((b * brainCoreData.fetchUserData().beerCost) + (w * brainCoreData.fetchUserData().wineCost) + (d * brainCoreData.fetchUserData().drinkCost) + (s * brainCoreData.fetchUserData().shotCost))
    }
    
    /*
     ADD UNITS DAY AFTER
    */
    
    @IBAction func addBeerDayAfter(_ sender: AnyObject) {
        addUnitPopUp("Legg til Øl", messageAlCon: "Glemt av øl? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt", unit: "Beer")
    }
    
    @IBAction func addWineDayAfter(_ sender: AnyObject) {
        addUnitPopUp("Legg til Vin", messageAlCon: "Glemt av vin? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt", unit: "Wine")
    }
    
    @IBAction func addDrinkDayAfter(_ sender: AnyObject) {
        addUnitPopUp("Legg til Drink", messageAlCon: "Glemt av drink? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt", unit: "Drink")
    }
    
    @IBAction func addShotDayAfter(_ sender: AnyObject) {
        addUnitPopUp("Legg til Shot", messageAlCon: "Glemt av shot? Det er ikke for sent", titleActionOne: "Legg til", titleActionTwo: "Avbryt", unit: "Shot")
    }
    
    func addUnitPopUp(_ titleAlCon: String, messageAlCon: String, titleActionOne: String, titleActionTwo: String, unit: String){
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .dateAndTime
        var getPlanPartyStamps : [Date] = [Date]()
        getPlanPartyStamps = brainCoreData.getPlanPartySession() as [Date]
        startOfPlanPartyStamp = getPlanPartyStamps[0]
        endOfPlanPartyStamp = getPlanPartyStamps[1]
        
        datepicker.minimumDate = startOfPlanPartyStamp
        datepicker.maximumDate = endOfPlanPartyStamp
        datepicker.setDate(endOfPlanPartyStamp, animated: true)
        datepicker.backgroundColor = UIColor.darkGray
        datepicker.setValue(setAppColors.datePickerTextColor(), forKey: "textColor")
        
        let vc = UIAlertController(title: titleAlCon, message: messageAlCon, preferredStyle: .alert)
        vc.addTextField(configurationHandler: { (textField) -> Void in
            textField.delegate = self
            textField.inputView = datepicker
            textField.placeholder = "Dato"
        })
        vc.addAction(UIAlertAction(title: titleActionOne, style: .default, handler: { (action) -> Void in
            self.datePickValueChangedUnit(datepicker, unit: unit)
            self.resetHistoryValues(unit)
            self.status = self.statusUtils.getState()
            self.stateHandler(self.status)
            self.fillPieChart()
        }))
        vc.addAction(UIAlertAction(title: titleActionTwo, style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    func datePickValueChangedUnit(_ sender:UIDatePicker, unit: String){
        let pickerTime = sender.date
        
        brainCoreData.seedTimeStamp(pickerTime, unitAlcohol: unit)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
    }
    
    func resetHistoryValues(_ unit: String){
        self.brainCoreData.fetchUserData()
        self.getUnits()
        
        let tempPlanPartSesNr = self.brainCoreData.fetchPlanPartySessionNr()
        
        if(unit == "Beer"){
            consumedBeers += 1
        }
        if(unit == "Wine"){
            consumedWines += 1
        }
        if(unit == "Drink"){
            consumedDrinks += 1
        }
        if(unit == "Shot"){
            consumedShots += 1
        }
        
        let calculateCosts = self.brain.calcualteTotalCosts(consumedBeers, wine: consumedWines, drink: consumedDrinks, shot: consumedShots, bPrice: brainCoreData.fetchUserData().beerCost, wPrice: brainCoreData.fetchUserData().wineCost, dPrice: brainCoreData.fetchUserData().drinkCost, sPrice: brainCoreData.fetchUserData().shotCost)
        let printDay = self.dateUtil.getDayOfWeekAsString(self.startOfPlanPartyStamp)
        let printDate = self.dateUtil.getDateOfMonth(self.startOfPlanPartyStamp)
        let printMonth = self.dateUtil.getMonthOfYear(self.startOfPlanPartyStamp)
        let fullDate = "\(printDay!) \(printDate!). \(printMonth!)"
        let tempFirstUnitAdded = self.brainCoreData.getFirstUnitAddedTimeStamp()
        
        self.brainCoreData.deleteLastItemAdded(tempPlanPartSesNr)
        self.brainCoreData.deleteLastGraphValue(tempPlanPartSesNr)
        
        self.brainCoreData.seedHistoryValues(self.startOfPlanPartyStamp, forbruk: calculateCosts, hoyestePromille: 0.0, antallOl: consumedBeers, antallVin: consumedWines, antallDrink: consumedDrinks, antallShot: consumedShots, stringDato: fullDate, endOfSesDate: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr, firstUnitStamp: tempFirstUnitAdded)
        
        self.brain.populateGraphValues(self.brainCoreData.fetchUserData().gender, weight: self.brainCoreData.fetchUserData().weight, startPlanStamp: self.startOfPlanPartyStamp, endPlanStamp: self.endOfPlanPartyStamp, sessionNumber: tempPlanPartSesNr)
    }
    
    /*
     END DAY-AFTER BTN
     */
    
    @IBAction func endDayAfterBtn(_ sender: UIButton) {
        endDayAfterAlert("Avslutt Dagen Derpå?", msg: "Du vil ikke kunne gå tilbake", cancelTitle: "Avbryt", confirmTitle: "Bekreft")
    }
    
    func endDayAfterAlert(_ titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.destructive, handler:{ (action: UIAlertAction!) in
        }))
        
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.default, handler:  { action in
            self.consumedBeers = 0
            self.consumedWines = 0
            self.consumedDrinks = 0
            self.consumedShots = 0
            self.totalUnits = 0
            self.costs = 0
            self.yestHighProm = 0.0
            self.currentBAC = 0.0
            self.brainCoreData.clearCoreData("TimeStamp2")
            self.brainCoreData.clearCoreData("StartEndTimeStamps")
            self.brainCoreData.clearCoreData("TerminatedTimeStamp")
            self.clearPlannedUserDefaults()
            let pieChartValue = ["", "", "", ""]
            let unitsSold = [Double(self.consumedBeers), Double(self.consumedWines), Double(self.consumedDrinks), Double(self.consumedShots)]
            self.setChart(pieChartValue, values: unitsSold)
            self.visuals_not_running()
            self.statusUtils.setState(Status.NOT_RUNNING as AnyObject)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
     PIE CHART
     */
    
    func fillPieChart(){
        pieChartView.delegate = self
        let pieChartValue = ["", "", "", ""]
        let unitsSold = [Double(consumedBeers), Double(consumedWines), Double(consumedDrinks), Double(consumedShots)]
        
        // DUMMY PIECHART DATA
        // unitsSold = [12.6, 4.6, 2.9, 10.0]
        
        setChart(pieChartValue, values: unitsSold)
    }
    
    func setSliceColors(){
        // SLICE COLORS
        beerSliceColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0)
        wineSliceColor = UIColor(red: 157/255, green: 9/255, blue: 9/255, alpha: 1.0)
        drinkSliceColor = UIColor(red: 38/255, green: 207/255, blue: 86/255, alpha: 1.0)
        shotSliceColor = UIColor(red: 139/255, green: 65/255, blue: 232/255, alpha: 1.0) // BLÅ: 0, 170, 255
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        setSliceColors()
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "???")
        let kek = PieChartData(dataSet: pieChartDataSet)
        //let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        kek.setDrawValues(false)
        
        pieChartView.data = kek
        
        
        
        var colors: [UIColor] = []
        
        colors.append(beerSliceColor)
        colors.append(wineSliceColor)
        colors.append(drinkSliceColor)
        colors.append(shotSliceColor)
        
        pieChartDataSet.colors = colors
        
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
        centerText = "\(totalUnits)"
        
        var fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 30.0), NSForegroundColorAttributeName: UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)]
        
        if(totalUnits > totalPlannedUnits){
            fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 30.0), NSForegroundColorAttributeName: UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)]
            yesterdaysCosts.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 30.0), NSForegroundColorAttributeName: UIColor.white]
            yesterdaysCosts.textColor = UIColor.white
        }
        
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        pieChartView.centerAttributedText = attriButedString
        pieChartView.isUserInteractionEnabled = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        setSliceColors()
        if(entry.x == 0){
            beerLabel.textColor = beerSliceColor
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.x == 1){
            wineLabel.textColor = wineSliceColor
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.x == 2){
            drinkLabel.textColor = drinkSliceColor
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
        if(entry.x == 3){
            shotLabel.textColor = shotSliceColor
            beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
            wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
            drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.beerLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.wineLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.drinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        self.shotLabel.textColor = setAppColors.textUnderHeadlinesColors()
    }
    
    /*
     USER DEFAULTS
     */
    
    func getPlannedUnits(){ // GETTING
        let defaults = UserDefaults.standard
        // VISUELLE ENHET VERDIER
        if let beer : Int = defaults.integer(forKey: defaultKeys.beerKey) {
            plannedBeers = beer
        }
        if let wine : Int = defaults.integer(forKey: defaultKeys.wineKey) {
            plannedWines = wine
        }
        if let drink : Int = defaults.integer(forKey: defaultKeys.drinkKey) {
            plannedDrink = drink
        }
        if let shot : Int = defaults.integer(forKey: defaultKeys.shotKey) {
            plannedShots = shot
        }
    }
    
    func clearPlannedUserDefaults(){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: defaultKeys.beerKey)
        defaults.set(0, forKey: defaultKeys.wineKey)
        defaults.set(0, forKey: defaultKeys.drinkKey)
        defaults.set(0, forKey: defaultKeys.shotKey)
        defaults.set(0, forKey: defaultKeys.totalNrOfUnits)
        defaults.synchronize()
    }
    
    
    /*
     VISUALS
     */
    
    func visuals_DA_running(){
        let formatCurrentBAC = String(format: "%.2f", currentBAC)
        let formatYestHighPromille = String(format: "%.2f", yestHighProm)
        
        self.currentPromille.text = "\(formatCurrentBAC)"
        self.beerLabel.text = "\(consumedBeers)"
        self.wineLabel.text = "\(consumedWines)"
        self.drinkLabel.text = "\(consumedDrinks)"
        self.shotLabel.text = "\(consumedShots)"
        self.yesterdaysCosts.text = "\(costs),-"
        self.yesterdaysHighestProm.text = "\(formatYestHighPromille)"
        self.overallTitle.text = "Drakk du mer enn planlagt?"
        self.overallSubtitle.text = "Klikk på enhetene for å legge til"
        hideVisuals(false)
        
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.xImageBtn.isHidden = true
            self.endDayAfterButtonOutlet.isHidden = false
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.xImageBtn.isHidden = false
            self.endDayAfterButtonOutlet.isHidden = false
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            self.xImageBtn.isHidden = false
            self.endDayAfterButtonOutlet.isHidden = false
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            self.xImageBtn.isHidden = false
            self.endDayAfterButtonOutlet.isHidden = false
        }
        
        checkIfUserWentOverPlanned()
    }
    
    func checkIfUserWentOverPlanned(){
        // UNITS
        if(consumedBeers > plannedBeers){
            self.beerLabel.textColor = UIColor.red
        } else {
            self.beerLabel.textColor = UIColor.white
        }
        if(consumedWines > plannedWines){
            self.wineLabel.textColor = UIColor.red
        } else {
            self.beerLabel.textColor = UIColor.white
        }
        if(consumedDrinks > plannedDrink){
            self.drinkLabel.textColor = UIColor.red
        } else {
            self.drinkLabel.textColor = UIColor.white
        }
        if(consumedShots > plannedShots){
            self.shotLabel.textColor = UIColor.red
        } else {
            self.shotLabel.textColor = UIColor.white
        }
        
        // COSTS
        if(totalUnits > totalPlannedUnits){
            self.yesterdaysCosts.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            self.yesterdaysCosts.textColor = UIColor.white
        }
        if(brainCoreData.fetchGoal() < yestHighProm){
            yesterdaysHighestProm.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            yesterdaysHighestProm.textColor = setAppColors.textUnderHeadlinesColors()
        }
    }
    
    func visuals_not_running(){
        hideVisuals(true)
        self.overallTitle.text = "Planlegg Kvelden pågår"
        self.overallSubtitle.text = "Her vil du se statistikk over den siste kvelden du har registrert"
    }
    
    func hideVisuals(_ isHidden:Bool){
        self.pieChartView.isHidden = isHidden
        self.beerOutletButton.isHidden = isHidden
        self.wineOutletButton.isHidden = isHidden
        self.drinkOutletButton.isHidden = isHidden
        self.shotOutletButton.isHidden = isHidden
        self.beerLabel.isHidden = isHidden
        self.wineLabel.isHidden = isHidden
        self.drinkLabel.isHidden = isHidden
        self.shotLabel.isHidden = isHidden
        self.yesterdaysCosts.isHidden = isHidden
        self.currentPromille.isHidden = isHidden
        self.yesterdaysHighestProm.isHidden = isHidden
        self.costsTitleLabel.isHidden = isHidden
        self.currPromTitleLabel.isHidden = isHidden
        self.yestHighestPromTitleLabel.isHidden = isHidden
        self.endDayAfterButtonOutlet.isHidden = isHidden
        self.xImageBtn.isHidden = isHidden
    }
    
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
        self.beerOutletButton.titleLabel?.textAlignment = NSTextAlignment.center
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
        costsTitleLabel.text = "Forbruk"
        costsTitleLabel.textColor = setAppColors.textHeadlinesColors()
        costsTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        yestHighestPromTitleLabel.text = "Høyeste Promille"
        yestHighestPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        yestHighestPromTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        currPromTitleLabel.text = "Nåværende Promille"
        currPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        currPromTitleLabel.font = setAppColors.textHeadlinesFonts(14)
        
        // BUTTONS
        endDayAfterButtonOutlet.titleLabel?.font = setAppColors.buttonFonts(14)
        endDayAfterButtonOutlet.setTitle("Avslutt", for: UIControlState())
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            print("iphone 4 - GlemteEnheter")
            let unitLabButHeight : CGFloat = -50.0
            let unitLabButWidthBeerWine : CGFloat = 18.0
            let unitLabButWidthDrinkShot : CGFloat = -18.0
            // PIE CHART
            self.pieChartView.transform = self.view.transform.translatedBy(x: 0.0, y: -50.0)
            
            // TITLE AND SUBTITLE
            self.overallTitle.font = setAppColors.textHeadlinesFonts(18)
            self.overallSubtitle.font = setAppColors.textUnderHeadlinesFonts(11)
            self.overallTitle.transform = self.view.transform.translatedBy(x: 0.0, y: -17.0)
            self.overallSubtitle.transform = self.view.transform.translatedBy(x: 0.0, y: -32.0)
            
            // TOTAL RESULTS LABELS
            self.beerLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.wineLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.drinkLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.shotLabel.font = setAppColors.textUnderHeadlinesFonts(20)
            self.beerLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.wineLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.drinkLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            self.shotLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            
            // BUTTONS
            beerOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            wineOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            drinkOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            shotOutletButton.titleLabel?.font = setAppColors.buttonFonts(11)
            self.beerOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.wineOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.drinkOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            self.shotOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            
            let statsHeight : CGFloat = -85.0
            let titleStatsHeight : CGFloat = -95.0
            
            // RESULTS GÅRSDAGENS ERFARINGER
            yesterdaysCosts.font = setAppColors.textUnderHeadlinesFonts(20)
            yesterdaysHighestProm.font = setAppColors.textUnderHeadlinesFonts(20)
            currentPromille.font = setAppColors.textUnderHeadlinesFonts(20)
            self.yesterdaysCosts.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            self.yesterdaysHighestProm.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            self.currentPromille.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            
            // TITLES GÅRSDAGENS ERFARINGER
            costsTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            yestHighestPromTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            currPromTitleLabel.font = setAppColors.textHeadlinesFonts(11)
            self.costsTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
            self.yestHighestPromTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
            self.currPromTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
            
            self.xImageBtn.isHidden = true
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            let unitLabButHeight : CGFloat = -37.0
            let unitLabButWidthBeerWine : CGFloat = 18.0
            let unitLabButWidthDrinkShot : CGFloat = -18.0
            // PIE CHART
            self.pieChartView.transform = self.view.transform.translatedBy(x: 0.0, y: -37.0)
            
            // TITLE AND SUBTITLE
            self.overallTitle.transform = self.view.transform.translatedBy(x: 0.0, y: -10.0)
            self.overallSubtitle.transform = self.view.transform.translatedBy(x: 0.0, y: -18.0)
            
            // TOTAL RESULTS LABELS
            self.beerLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.wineLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.drinkLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            self.shotLabel.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            
            // BUTTONS
            self.beerOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.wineOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthBeerWine, y: unitLabButHeight)
            self.drinkOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            self.shotOutletButton.transform = self.view.transform.translatedBy(x: unitLabButWidthDrinkShot, y: unitLabButHeight)
            
            let statsHeight : CGFloat = -65.0
            let titleStatsHeight : CGFloat = -75.0
            
            // RESULTS GÅRSDAGENS ERFARINGER
            self.yesterdaysCosts.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            self.yesterdaysHighestProm.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            self.currentPromille.transform = self.view.transform.translatedBy(x: 0.0, y: statsHeight)
            
            // TITLES GÅRSDAGENS ERFARINGER
            self.costsTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
            self.yestHighestPromTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
            self.currPromTitleLabel.transform = self.view.transform.translatedBy(x: 0.0, y: titleStatsHeight)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
