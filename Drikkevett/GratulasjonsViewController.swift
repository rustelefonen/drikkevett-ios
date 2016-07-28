//
//  GratulasjonsViewController.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 09.05.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts
import CoreData

class GratulasjonsViewController: UIViewController, ChartViewDelegate {

    // Talk with core data
    let moc = DataController().managedObjectContext
    
    // funksjonelle metoder
    let brain = SkallMenyBrain()
    let dateUtil = DateUtil()
    
    // BAR CHART
    @IBOutlet weak var barChartView: BarChartView!
    var XAxis: [String]! = [String]()
    var YAxis: [Double]! = [Double]()
    
    var getGoalPromille : Double = 0.0
    var getGoalDate : NSDate = NSDate()
    
    // hente core data metoder
    let brainCoreData = CoreDataMethods()
    
    // set Colors
    let setAppColors = AppColors()
    
    // gratulasjons tittel
    @IBOutlet weak var titleOfAward: UILabel!
    
    // info textView
    @IBOutlet weak var infoTextView: UITextView!
    
    // Knapper (Start på nytt, fortsett)
    @IBOutlet weak var restartBtnOutlet: UIButton!
    @IBOutlet weak var restartBtnImageView: UIImageView!
    @IBOutlet weak var continueBtnOutlet: UIButton!
    @IBOutlet weak var continueBtnImageView: UIImageView!
    @IBOutlet weak var screenshotBtnOutlet: UIButton!
    @IBOutlet weak var screenshotBtnImageView: UIImageView!
    
    // STATS
    @IBOutlet weak var costsStatsLabel: UILabel!
    @IBOutlet weak var highestPromilleStatsLabel: UILabel!
    @IBOutlet weak var averageHighestPromilleStatsLabel: UILabel!
    
    // TITLE - STATS
    @IBOutlet weak var costsTitleStatsLabel: UILabel!
    @IBOutlet weak var highestPromilleTitleStatsLabel: UILabel!
    @IBOutlet weak var averageHighestPromilleTitleStatsLabel: UILabel!
    
    // GOAL
    var overGoal : Int = 0
    var underGoal : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsFonts()
        setConstraints()
        initaiteBarChart()
        setTotalStats()
        
        if(didUserReachGoal() == true){
            self.titleOfAward.text = "Gratulerer!"
            self.infoTextView.text = "Hvis du ønsker å fortsette med de samme statistikkene som før klikk på \"Fortsett\".\n\nHvis ikke kan du starte applikasjonen helt på nytt ved å klikke på \"Start på nytt\"."
        } else {
            self.titleOfAward.text = "Perioden er over!"
            self.infoTextView.text = "Du hadde flere kvelder hvor du var over målet ditt enn under!"
        }
    }
    
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func continueApplicationBtn(sender: AnyObject) {
        // SETT NYTT MÅL
        self.performSegueWithIdentifier("gratulationSegue", sender: self)
    }
    
    @IBAction func resetApplicationBtn(sender: AnyObject) {
        // TØM HISTORIKK
        brainCoreData.clearCoreData("Historikk")
        brainCoreData.clearCoreData("GraphHistorikk")
        
        // HVIS SESJON PÅGÅR TØM DE OGSÅ
        brainCoreData.clearCoreData("StartEndTimeStamps")
        brainCoreData.clearCoreData("TimeStamp2")
        
        // SETT NYTT MÅL
        self.performSegueWithIdentifier("gratulationSegue", sender: self)
    }
    
    @IBAction func screenshotBtn(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(captureScreen(), nil, nil, nil)
        
        if let wnd = self.view{
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.whiteColor()
            v.alpha = 1
            
            wnd.addSubview(v)
            UIView.animateWithDuration(1, animations: {
                v.alpha = 0.0
                }, completion: {(finished:Bool) in
                    v.removeFromSuperview()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gratulationSegue") {
            let upcoming: OppdaterMalViewController = segue.destinationViewController as! OppdaterMalViewController
            upcoming.isGratulationViewRunned = true
        }
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.titleOfAward.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -20.0)
            self.barChartView.transform = CGAffineTransformTranslate(self.barChartView.transform, 0.0, -40.0)
            
            let xValueStats : CGFloat = -45
            self.costsTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -60.0)
            self.highestPromilleTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -60.0)
            self.averageHighestPromilleTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -60.0)
            self.costsStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -50.0)
            self.highestPromilleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -50.0)
            self.averageHighestPromilleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, xValueStats, -50.0)
            
            self.infoTextView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -89.0)
            
            // BUTTONS
            let btnYValue : CGFloat = -175.0
            self.screenshotBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            self.screenshotBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            self.restartBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            self.restartBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            self.continueBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            self.continueBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYValue)
            
            // FONTS
            // STATS AND TITLES
            setFontsOnStats(10, statsFontSize: 18)
            
            // TITLE AND INFO
            self.titleOfAward.font = setAppColors.welcomeTextHeadlinesFonts(28)
            self.infoTextView.font = setAppColors.textViewFont(9.2)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.titleOfAward.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -20.0)
            self.barChartView.transform = CGAffineTransformTranslate(self.barChartView.transform, 0.0, -40.0)
            
            // STATS AND TITLES
            self.costsTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -30, -60.0)
            self.highestPromilleTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -45.0, -60.0)
            self.averageHighestPromilleTitleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -55, -60.0)
            self.costsStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -30, -50.0)
            self.highestPromilleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -45, -50.0)
            self.averageHighestPromilleStatsLabel.transform = CGAffineTransformTranslate(self.view.transform, -55, -50.0)
            
            self.infoTextView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -70.0)
            
            // BUTTONS
            let btnYvalue : CGFloat = -90.0
            self.screenshotBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            self.screenshotBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            self.restartBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            self.restartBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            self.continueBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            self.continueBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, btnYvalue)
            
            // FONTS
            setFontsOnStats(12, statsFontSize: 22)
            self.infoTextView.font = setAppColors.textViewFont(13.5)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            // BUTTONS
            self.screenshotBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
            self.screenshotBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
            self.restartBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
            self.restartBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
            self.continueBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
            self.continueBtnImageView.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 50.0)
        }
    }
    
    func setFontsOnStats(titleFontSize: CGFloat, statsFontSize: CGFloat){
        // FONTS
        self.costsTitleStatsLabel.font = setAppColors.textHeadlinesFonts(titleFontSize)
        self.costsStatsLabel.font = setAppColors.textUnderHeadlinesFonts(statsFontSize)
        self.highestPromilleTitleStatsLabel.font = setAppColors.textHeadlinesFonts(titleFontSize)
        self.highestPromilleStatsLabel.font = setAppColors.textUnderHeadlinesFonts(statsFontSize)
        self.averageHighestPromilleTitleStatsLabel.font = setAppColors.textHeadlinesFonts(titleFontSize)
        self.averageHighestPromilleStatsLabel.font = setAppColors.textUnderHeadlinesFonts(statsFontSize)
    }
    
    func setColorsFonts(){
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.titleOfAward.font = setAppColors.welcomeTextHeadlinesFonts(35)
        self.titleOfAward.textColor = setAppColors.textHeadlinesColors()
        self.infoTextView.font = setAppColors.textViewFont(16)
        self.infoTextView.textColor = setAppColors.textViewsColors()
        
        // STATS AND TITLES
        self.costsTitleStatsLabel.font = setAppColors.textHeadlinesFonts(15)
        self.costsStatsLabel.font = setAppColors.textUnderHeadlinesFonts(27)
        
        self.highestPromilleTitleStatsLabel.font = setAppColors.textHeadlinesFonts(15)
        self.highestPromilleStatsLabel.font = setAppColors.textUnderHeadlinesFonts(27)
        
        self.averageHighestPromilleTitleStatsLabel.font = setAppColors.textHeadlinesFonts(15)
        self.averageHighestPromilleStatsLabel.font = setAppColors.textUnderHeadlinesFonts(27)
        
        self.costsTitleStatsLabel.textColor = setAppColors.textHeadlinesColors()
        self.costsStatsLabel.textColor = setAppColors.textUnderHeadlinesColors()
        
        self.highestPromilleTitleStatsLabel.textColor = setAppColors.textHeadlinesColors()
        self.highestPromilleStatsLabel.textColor = setAppColors.textUnderHeadlinesColors()
        
        self.averageHighestPromilleTitleStatsLabel.textColor = setAppColors.textHeadlinesColors()
        self.averageHighestPromilleStatsLabel.textColor = setAppColors.textUnderHeadlinesColors()
        
        self.restartBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        self.continueBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        self.screenshotBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
    }
    
    // BARCHART
    func initaiteBarChart(){
        fetchUserData()
        barChartView.noDataTextDescription = "Ingen data på graf"
        populateAxises()
        designChart()
        setChart(XAxis, values: YAxis)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "Statistikk over kveldene dine vil vises her."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Høyeste Promille Kvelder")
        let chartData = BarChartData(xVals: XAxis, dataSet: chartDataSet)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter
        
        if(XAxis.isEmpty && YAxis.isEmpty){
        } else {
            barChartView.data = chartData
        }
        chartDataSet.drawValuesEnabled = false
        barChartView.descriptionText = ""
        
        var colors: [UIColor] = []
        
        for items in values {
            if(items > getGoalPromille){
                overGoal += 1
                
                colors.append(UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)) // RED
            } else {
                underGoal += 1
                
                colors.append(UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)) // GREEN
            }
        }
        
        chartDataSet.colors = colors
        barChartView.rightAxis.removeAllLimitLines()
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        let ll = ChartLimitLine(limit: getGoalPromille, label: "")
        ll.lineColor = UIColor.whiteColor()
        ll.lineDashLengths = [8.5]
        barChartView.rightAxis.addLimitLine(ll)
    }
    
    func designChart(){
        self.barChartView.noDataText = "ingen graf"
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.labelPosition = .Bottom
        self.barChartView.rightAxis.drawTopYLabelEntryEnabled = false
        self.barChartView.leftAxis.labelTextColor = UIColor.whiteColor()
        self.barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        self.barChartView.rightAxis.enabled = false
        self.barChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.barChartView.legend.enabled = false
        self.barChartView.descriptionTextColor = UIColor.redColor()
        self.barChartView.userInteractionEnabled = false
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.doubleTapToZoomEnabled = false
    }
    
    func populateAxises() {
        XAxis.removeAll()
        YAxis.removeAll()
        
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                print("Start Time PlanKveld: \(timeStampItem.dato!)")
                let tempStartDate = timeStampItem.dato! as NSDate
                
                let date = dateUtil.getDateOfMonth(tempStartDate)!
                let month = dateUtil.getMonthOfYear(tempStartDate)!
                let formatOfDate = "\(date).\(month)"
                
                XAxis.append(formatOfDate)
                for items in XAxis{
                    print("Array X: \(items)")
                }
            }
            for hoyesteProm in historikk {
                print("Høyeste Prom siste verdi: \(hoyesteProm.hoyestePromille!)")
                var tempHighProm = hoyesteProm.hoyestePromille! as Double
                let infinity = Double.infinity
                print("Infinity: \(infinity)")
                if(tempHighProm >= infinity){
                    tempHighProm = infinity
                    print(tempHighProm)
                }
                
                let tempStringHighProm = String(format: "%.2f", tempHighProm)
                String(format:"%.2f", tempStringHighProm)
                let formatHighProm = Double(tempStringHighProm)
                
                YAxis.append(formatHighProm!)
            }
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
                getGoalPromille = item.goalPromille! as Double
                getGoalDate = item.goalDate! as NSDate
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    // TOTALT STATS
    func setTotalStats(){
        let checkTotalForbruk : Double = 0.0
        let checkTotalHighestPromille : Double = 0.0
        var formatTotalHighestPromille = ""
        let checkTotalAverageHighestPromille : Double = 0.0
        var formatTotalAverageHighestPromille = ""
        
        let isEntityEmpty = brainCoreData.entityIsEmpty("Historikk")
        
        if(isEntityEmpty == false){
            let whatIsTotalForbruk = brainCoreData.updateTotalForbruk(checkTotalForbruk)
            let forceInteger = Int(whatIsTotalForbruk)
            self.costsStatsLabel.text = "\(forceInteger),-"
            
            let whatIsTotalHighPromille = brainCoreData.updateTotalHighestPromille(checkTotalHighestPromille)
            formatTotalHighestPromille = String(format: "%.2f", whatIsTotalHighPromille)
            self.highestPromilleStatsLabel.text = "\(formatTotalHighestPromille)"
            
            let whatIsTotalAverageHighPromille = brainCoreData.updateTotalAverageHighestPromille(checkTotalAverageHighestPromille)
            formatTotalAverageHighestPromille = String(format: "%.2f", whatIsTotalAverageHighPromille)
            self.averageHighestPromilleStatsLabel.text = "\(formatTotalAverageHighestPromille)"
        } else {}
    }
    
    func didUserReachGoal() -> Bool {
        var didUserAvergeAboveGoal = false
        if(overGoal <= underGoal){
            didUserAvergeAboveGoal = true
        } else {
            didUserAvergeAboveGoal = false
        }
        return didUserAvergeAboveGoal
    }
}

public extension UIWindow {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
