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
    let moc = AppDelegate.getManagedObjectContext()
    
    // funksjonelle metoder
    let brain = SkallMenyBrain()
    let dateUtil = DateUtil()
    
    // BAR CHART
    @IBOutlet weak var barChartView: BarChartView!
    var XAxis: [String]! = [String]()
    var YAxis: [Double]! = [Double]()
    
    var getGoalPromille : Double = 0.0
    var getGoalDate : Date = Date()
    
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
    
    //var cameFrom:String?
    
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
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func continueApplicationBtn(_ sender: AnyObject) {
        // SETT NYTT MÅL
        self.performSegue(withIdentifier: "gratulationSegue", sender: self)
    }
    
    @IBAction func resetApplicationBtn(_ sender: AnyObject) {
        // TØM HISTORIKK
        brainCoreData.clearCoreData("Historikk")
        brainCoreData.clearCoreData("GraphHistorikk")
        
        // HVIS SESJON PÅGÅR TØM DE OGSÅ
        brainCoreData.clearCoreData("StartEndTimeStamps")
        brainCoreData.clearCoreData("TimeStamp2")
        
        // SETT NYTT MÅL
        self.performSegue(withIdentifier: "gratulationSegue", sender: self)
    }
    
    @IBAction func screenshotBtn(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(captureScreen(), nil, nil, nil)
        
        if let wnd = self.view{
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.white
            v.alpha = 1
            
            wnd.addSubview(v)
            UIView.animate(withDuration: 1, animations: {
                v.alpha = 0.0
                }, completion: {(finished:Bool) in
                    v.removeFromSuperview()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gratulationSegue") {
            let upcoming: OppdaterMalViewController = segue.destination as! OppdaterMalViewController
            upcoming.isGratulationViewRunned = true
            //upcoming.cameFrom = cameFrom
        }
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            self.titleOfAward.transform = self.view.transform.translatedBy(x: 0.0, y: -20.0)
            self.barChartView.transform = self.barChartView.transform.translatedBy(x: 0.0, y: -40.0)
            
            let xValueStats : CGFloat = -45
            self.costsTitleStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -60.0)
            self.highestPromilleTitleStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -60.0)
            self.averageHighestPromilleTitleStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -60.0)
            self.costsStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -50.0)
            self.highestPromilleStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -50.0)
            self.averageHighestPromilleStatsLabel.transform = self.view.transform.translatedBy(x: xValueStats, y: -50.0)
            
            self.infoTextView.transform = self.view.transform.translatedBy(x: 0.0, y: -89.0)
            
            // BUTTONS
            let btnYValue : CGFloat = -175.0
            self.screenshotBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            self.screenshotBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            self.restartBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            self.restartBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            self.continueBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            self.continueBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYValue)
            
            // FONTS
            // STATS AND TITLES
            setFontsOnStats(10, statsFontSize: 18)
            
            // TITLE AND INFO
            self.titleOfAward.font = setAppColors.welcomeTextHeadlinesFonts(28)
            self.infoTextView.font = setAppColors.textViewFont(9.2)
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.titleOfAward.transform = self.view.transform.translatedBy(x: 0.0, y: -20.0)
            self.barChartView.transform = self.barChartView.transform.translatedBy(x: 0.0, y: -40.0)
            
            // STATS AND TITLES
            self.costsTitleStatsLabel.transform = self.view.transform.translatedBy(x: -30, y: -60.0)
            self.highestPromilleTitleStatsLabel.transform = self.view.transform.translatedBy(x: -45.0, y: -60.0)
            self.averageHighestPromilleTitleStatsLabel.transform = self.view.transform.translatedBy(x: -55, y: -60.0)
            self.costsStatsLabel.transform = self.view.transform.translatedBy(x: -30, y: -50.0)
            self.highestPromilleStatsLabel.transform = self.view.transform.translatedBy(x: -45, y: -50.0)
            self.averageHighestPromilleStatsLabel.transform = self.view.transform.translatedBy(x: -55, y: -50.0)
            
            self.infoTextView.transform = self.view.transform.translatedBy(x: 0.0, y: -70.0)
            
            // BUTTONS
            let btnYvalue : CGFloat = -90.0
            self.screenshotBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            self.screenshotBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            self.restartBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            self.restartBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            self.continueBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            self.continueBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: btnYvalue)
            
            // FONTS
            setFontsOnStats(12, statsFontSize: 22)
            self.infoTextView.font = setAppColors.textViewFont(13.5)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            // BUTTONS
            self.screenshotBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
            self.screenshotBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
            self.restartBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
            self.restartBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
            self.continueBtnOutlet.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
            self.continueBtnImageView.transform = self.view.transform.translatedBy(x: 0.0, y: 50.0)
        }
    }
    
    func setFontsOnStats(_ titleFontSize: CGFloat, statsFontSize: CGFloat){
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
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
        barChartView.noDataText = "Ingen data på graf"
        populateAxises()
        designChart()
        setChart(XAxis, values: YAxis)
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "Statistikk over kveldene dine vil vises her."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Høyeste Promille Kvelder")
        //let chartData = BarChartData(xVals: XAxis, dataSet: chartDataSet)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter as? IValueFormatter
        
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
        ll.lineColor = UIColor.white
        ll.lineDashLengths = [8.5]
        barChartView.rightAxis.addLimitLine(ll)
    }
    
    func designChart(){
        self.barChartView.noDataText = "ingen graf"
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.rightAxis.drawTopYLabelEntryEnabled = false
        self.barChartView.leftAxis.labelTextColor = UIColor.white
        self.barChartView.xAxis.labelTextColor = UIColor.white
        self.barChartView.rightAxis.enabled = false
        self.barChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.barChartView.legend.enabled = false
        self.barChartView.descriptionTextColor = UIColor.red
        self.barChartView.isUserInteractionEnabled = false
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.doubleTapToZoomEnabled = false
    }
    
    func populateAxises() {
        XAxis.removeAll()
        YAxis.removeAll()
        
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                print("Start Time PlanKveld: \(timeStampItem.dato!)")
                let tempStartDate = timeStampItem.dato! as Date
                
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
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
                getGoalDate = item.goalDate! as Date
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
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
