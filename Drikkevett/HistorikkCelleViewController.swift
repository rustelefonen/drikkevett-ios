//
//  HistorikkCelleViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 12.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts
import CoreData

class HistorikkCelleViewController: UIViewController, ChartViewDelegate {
    
    // Talk with core data
    let moc = AppDelegate.getManagedObjectContext()
    
    // Get Brain
    //let brain = SkallMenyBrain()
    let coreDataBrain = CoreDataMethods()
    
    // Set colors
    let setAppColors = AppColors()
    
    // GRAPH
    @IBOutlet weak var lineGraph: LineChartView!
    
    //Necessary attributes: (Arrayene med verdiene)
    var xAxis : [String] = [String]()
    var yAxis : [Double] = [Double]()
    
    var newXAxis : [Double] = [Double]()
    
    // LABELS
    @IBOutlet weak var forbrukLabel: UILabel!
    @IBOutlet weak var hoyestePromilleLabel: UILabel!
    @IBOutlet weak var antallOlLabel: UILabel!
    @IBOutlet weak var antallVinLabel: UILabel!
    @IBOutlet weak var antallDrinkLabel: UILabel!
    @IBOutlet weak var antallShotLabel: UILabel!
    @IBOutlet weak var costTitleLabel: UILabel!
    @IBOutlet weak var highPromTitleLabel: UILabel!
    
    // UNIT IMAGE VIEWS
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageVIew: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    // VARIABELS
    var dato: String = ""
    var forbruk: Int = 0
    var hoyestePromille: Double = 0.0
    var antallOl: Int = 0
    var antallVin: Int = 0
    var antallDrink: Int = 0
    var antallShot: Int = 0
    var tidspunktDato: Date = Date()
    var sessionNumber: Int = 0
    var helvete : String = ""
    
    
    
    
    //var history:Historikk!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(history)
        
        
        // FONTS AND COLORS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        // TITLE ON COST AND HIGH PROM
        costTitleLabel.textColor = setAppColors.textHeadlinesColors()
        costTitleLabel.font = setAppColors.textHeadlinesFonts(16)
        highPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        highPromTitleLabel.font = setAppColors.textHeadlinesFonts(16)
        
        // ANTALL LABELS
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallOlLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        
        // STATISTIKK
        hoyestePromilleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        hoyestePromilleLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        forbrukLabel.textColor = setAppColors.textUnderHeadlinesColors()
        forbrukLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        
        self.navigationItem.title = "\(dato)"
        self.forbrukLabel.text =      "\(forbruk),-"
        let formatHighPromille =  String(format: "%.2f", hoyestePromille)
        self.hoyestePromilleLabel.text =      "\(formatHighPromille)"
        self.antallOlLabel.text =      "\(antallOl)"
        self.antallVinLabel.text =      "\(antallVin)"
        self.antallDrinkLabel.text =      "\(antallDrink)"
        self.antallShotLabel.text =      "\(antallShot)"
        
        testSessionNumber()
        
        initLineChart()
        setChartData(xAxis)
        
        setConstraints()
    }
    
    func initLineChart(){
        lineGraph.delegate = self
        lineGraph.chartDescription?.text = ""
        lineGraph.leftAxis.drawGridLinesEnabled = true
        lineGraph.rightAxis.drawGridLinesEnabled = false
        lineGraph.leftAxis.forceLabelsEnabled = true
        lineGraph.xAxis.drawGridLinesEnabled = false
        lineGraph.rightAxis.drawLabelsEnabled = false
        lineGraph.rightAxis.drawTopYLabelEntryEnabled = false
        lineGraph.rightAxis.drawAxisLineEnabled = false
        lineGraph.xAxis.labelPosition = .bottom
        lineGraph.noDataText = "No data provided"
        lineGraph.isUserInteractionEnabled = false
        lineGraph.chartDescription?.textColor = UIColor.white
        lineGraph.leftAxis.labelTextColor = UIColor.white
        lineGraph.xAxis.labelTextColor = UIColor.white
        lineGraph.legend.enabled = false
        lineGraph.backgroundColor = setAppColors.lineChartBackgroundColor()
    }
    
    func setLineChartDataProperties(set1: LineChartDataSet){
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(setAppColors.setLineColor().withAlphaComponent(1.0)) // our line's opacity is 0%
        set1.setCircleColor(setAppColors.setLineSircleColor()) // our circle will be blue
        set1.lineWidth = 0.9
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        set1.highlightColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        set1.drawCubicEnabled = false
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
    }
    
    func setChartData(_ months: [String]) {
        let formato = HistoryFormatter()
        let xaxis:XAxis = XAxis()
        
        var yValues1 = [ChartDataEntry]()
        for i in 0 ..< months.count {
            formato.stringForValue(newXAxis[i], axis: xaxis)    //This is needed
            yValues1.append(ChartDataEntry(x: newXAxis[i], y: yAxis[i]))
        }
        
        xaxis.valueFormatter = formato
        lineGraph.xAxis.valueFormatter = xaxis.valueFormatter
        
        
        let set1 = LineChartDataSet(values: yValues1, label: "")
        setLineChartDataProperties(set1: set1)
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(setAppColors.setTitleColorTextOnCircles())
        
        /*let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = 0
         formatter.maximumFractionDigits = 3*/
        
        lineGraph.data = data
        
        var graphGradiantColor = UIColor.white
        
        let userGoal = coreDataBrain.fetchGoal()
        if(userGoal <= hoyestePromille){
            graphGradiantColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            graphGradiantColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        }
        
        let gradColors = [graphGradiantColor.cgColor, UIColor.black.cgColor]
        let colorLocations:[CGFloat] = [0.5, 0.1]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set1.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
    }
    
    func testSessionNumber(){
        var graphHistorikk = [GraphHistorikk]()
        
        xAxis.removeAll()
        yAxis.removeAll()
        
        let timeStampFetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GraphHistorikk")
        
        do {
            graphHistorikk = try moc.fetch(timeStampFetch) as! [GraphHistorikk]
            for timeStampItem in graphHistorikk {
                let graphHistorikkSession = timeStampItem.sessionNumber!
                
                if(NSNumber(value: sessionNumber) == graphHistorikkSession){
                    
                    
                    
                    // populate x and y values with these values
                    let something = timeStampItem.timeStampAdded! as Date
                    
                    newXAxis.append(Double(something.timeIntervalSince1970))
                    
                    var formatHour = ""
                    var formatMinute = ""
                    
                    let hour = (Calendar.current as NSCalendar).component(.hour, from: something)
                    let minute = (Calendar.current as NSCalendar).component(.minute, from: something)
                    
                    if(hour < 10) {formatHour = "0\(hour)"}
                    else {formatHour = "\(hour)"}
                    
                    if(minute < 10) {formatMinute = "0\(minute)"}
                    else {formatMinute = "\(minute)"}
                    
                    
                    
                    let formatOfDate = "\(formatHour).\(formatMinute)"
                    
                    print("\n\n\n\n")
                    print("hour: \(formatHour), minute: \(formatMinute), formatOfDate: \(formatOfDate)")
                    print("\n\n\n\n")
                    
                    print("Array X: \(formatOfDate)")
                    xAxis.append(formatOfDate)
                    
                    let promilleCurrent = timeStampItem.currentPromille! as Double
                    yAxis.append(promilleCurrent)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = -20.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            
            
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = 0.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            let transformLeft : CGFloat = 10.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = 10.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
        }
    }
    
}









/*import UIKit
import Charts
import CoreData

class HistorikkCelleViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var forbrukLabel: UILabel!
    @IBOutlet weak var hoyestePromilleLabel: UILabel!
    @IBOutlet weak var antallOlLabel: UILabel!
    @IBOutlet weak var antallVinLabel: UILabel!
    @IBOutlet weak var antallDrinkLabel: UILabel!
    @IBOutlet weak var antallShotLabel: UILabel!
    @IBOutlet weak var costTitleLabel: UILabel!
    @IBOutlet weak var highPromTitleLabel: UILabel!
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var drinkImageVIew: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    
    @IBOutlet weak var lineGraph: LineChartView!
    
    // Set colors
    let setAppColors = AppColors()
    
    var history:Historikk!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        /*let graphHistoryDao = GraphHistoryDao()
        let graphHistory = graphHistoryDao.getBySessionNumber(sessionNumber: history.sessionNumber!)
        
        print(history)
        
        print(graphHistory)*/
        
        
        // FONTS AND COLORS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        // TITLE ON COST AND HIGH PROM
        costTitleLabel.textColor = setAppColors.textHeadlinesColors()
        costTitleLabel.font = setAppColors.textHeadlinesFonts(16)
        highPromTitleLabel.textColor = setAppColors.textHeadlinesColors()
        highPromTitleLabel.font = setAppColors.textHeadlinesFonts(16)
        
        // ANTALL LABELS
        antallOlLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallOlLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallVinLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallVinLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallDrinkLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallDrinkLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        antallShotLabel.textColor = setAppColors.textUnderHeadlinesColors()
        antallShotLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        
        // STATISTIKK
        hoyestePromilleLabel.textColor = setAppColors.textUnderHeadlinesColors()
        hoyestePromilleLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        forbrukLabel.textColor = setAppColors.textUnderHeadlinesColors()
        forbrukLabel.font = setAppColors.textUnderHeadlinesFonts(25)
        
        /*self.navigationItem.title = "\(dato)"
        self.forbrukLabel.text =      "\(forbruk),-"
        let formatHighPromille =  String(format: "%.2f", hoyestePromille)
        self.hoyestePromilleLabel.text =      "\(formatHighPromille)"
        self.antallOlLabel.text =      "\(antallOl)"
        self.antallVinLabel.text =      "\(antallVin)"
        self.antallDrinkLabel.text =      "\(antallDrink)"
        self.antallShotLabel.text =      "\(antallShot)"
        
        testSessionNumber()*/
        
        initLineChart()
        //setChartData(xAxis)
        
        setConstraints()
    }
    
    func initLineChart(){
        lineGraph.delegate = self
        lineGraph.chartDescription?.text = ""
        lineGraph.leftAxis.drawGridLinesEnabled = true
        lineGraph.rightAxis.drawGridLinesEnabled = false
        lineGraph.leftAxis.forceLabelsEnabled = true
        lineGraph.xAxis.drawGridLinesEnabled = false
        lineGraph.rightAxis.drawLabelsEnabled = false
        lineGraph.rightAxis.drawTopYLabelEntryEnabled = false
        lineGraph.rightAxis.drawAxisLineEnabled = false
        lineGraph.xAxis.labelPosition = .bottom
        lineGraph.noDataText = "No data provided"
        lineGraph.isUserInteractionEnabled = false
        lineGraph.chartDescription?.textColor = UIColor.white
        lineGraph.leftAxis.labelTextColor = UIColor.white
        lineGraph.xAxis.labelTextColor = UIColor.white
        lineGraph.legend.enabled = false
        lineGraph.backgroundColor = setAppColors.lineChartBackgroundColor()
    }
    
    func setLineChartDataProperties(set1: LineChartDataSet){
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(setAppColors.setLineColor().withAlphaComponent(1.0)) // our line's opacity is 0%
        set1.setCircleColor(setAppColors.setLineSircleColor()) // our circle will be blue
        set1.lineWidth = 0.9
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        set1.highlightColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        set1.drawCubicEnabled = false
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
    }
    
    func setConstraints(){
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = -20.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            
            
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = 0.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            let transformLeft : CGFloat = 10.0
            
            // OVERSIKT
            self.forbrukLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.costTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.hoyestePromilleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            self.highPromTitleLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: 0.0)
            
            let yValueUnits : CGFloat = 10.0
            self.beerImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallOlLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.wineImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallVinLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.drinkImageVIew.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallDrinkLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.shotImageView.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
            self.antallShotLabel.transform = self.view.transform.translatedBy(x: transformLeft, y: yValueUnits)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Talk with core data
    let moc = DataController().managedObjectContext
    
    // Get Brain
    //let brain = SkallMenyBrain()
    let coreDataBrain = CoreDataMethods()
    
    //Necessary attributes: (Arrayene med verdiene) 
    var xAxis : [String] = [String]()
    var yAxis : [Double] = [Double]()
    
    var newXAxis : [Double] = [Double]()
    
    
    
    // VARIABELS
    var dato: String = ""
    var forbruk: Int = 0
    var hoyestePromille: Double = 0.0
    var antallOl: Int = 0
    var antallVin: Int = 0
    var antallDrink: Int = 0
    var antallShot: Int = 0
    var tidspunktDato: Date = Date()
    var sessionNumber: Int = 0
    var helvete : String = ""
    
    
    func setChartData(_ months: [String]) {
        let formato = HistoryFormatter()
        let xaxis:XAxis = XAxis()
        
        var yValues1 = [ChartDataEntry]()
        for i in 0 ..< months.count {
            formato.stringForValue(newXAxis[i], axis: xaxis)    //This is needed
            yValues1.append(ChartDataEntry(x: newXAxis[i], y: yAxis[i]))
        }
        
        xaxis.valueFormatter = formato
        lineGraph.xAxis.valueFormatter = xaxis.valueFormatter
        
        
        let set1 = LineChartDataSet(values: yValues1, label: "")
        setLineChartDataProperties(set1: set1)
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(setAppColors.setTitleColorTextOnCircles())
        
        /*let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3*/
        
        lineGraph.data = data
        
        var graphGradiantColor = UIColor.white
        
        let userGoal = coreDataBrain.fetchGoal()
        if(userGoal <= hoyestePromille){
            graphGradiantColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            graphGradiantColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        }
        
        let gradColors = [graphGradiantColor.cgColor, UIColor.black.cgColor]
        let colorLocations:[CGFloat] = [0.5, 0.1]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set1.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
    }
    
    func testSessionNumber(){
        var graphHistorikk = [GraphHistorikk]()
        
        xAxis.removeAll()
        yAxis.removeAll()
        
        let timeStampFetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GraphHistorikk")
        
        do {
            graphHistorikk = try moc.fetch(timeStampFetch) as! [GraphHistorikk]
            for timeStampItem in graphHistorikk {
                let graphHistorikkSession = timeStampItem.sessionNumber!
     
                if(NSNumber(value: sessionNumber) == graphHistorikkSession){
                    
                    
                    
                    // populate x and y values with these values
                    let something = timeStampItem.timeStampAdded! as Date
                    
                    newXAxis.append(Double(something.timeIntervalSince1970))
                    
                    var formatHour = ""
                    var formatMinute = ""
                    
                    let hour = (Calendar.current as NSCalendar).component(.hour, from: something)
                    let minute = (Calendar.current as NSCalendar).component(.minute, from: something)
                    
                    if(hour < 10) {formatHour = "0\(hour)"}
                    else {formatHour = "\(hour)"}
                    
                    if(minute < 10) {formatMinute = "0\(minute)"}
                    else {formatMinute = "\(minute)"}
                    
                    
                    
                    let formatOfDate = "\(formatHour).\(formatMinute)"
                    
                    print("\n\n\n\n")
                    print("hour: \(formatHour), minute: \(formatMinute), formatOfDate: \(formatOfDate)")
                    print("\n\n\n\n")
                    
                    print("Array X: \(formatOfDate)")
                    xAxis.append(formatOfDate)
                    
                    let promilleCurrent = timeStampItem.currentPromille! as Double
                    yAxis.append(promilleCurrent)
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    */
}*/
