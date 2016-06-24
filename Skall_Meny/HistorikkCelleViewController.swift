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
    let moc = DataController().managedObjectContext
    
    // Get Brain
    let brain = SkallMenyBrain()
    let coreDataBrain = CoreDataMethods()
    
    // Set colors
    let setAppColors = AppColors()
    
    // GRAPH
    @IBOutlet weak var lineGraph: LineChartView!
    
    //Necessary attributes: (Arrayene med verdiene) 
    var months : [String] = [String]()
    var dollars1 : [Double] = [Double]()
    
    //let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August", "Sept", "Oct", "Nov", "Dec"]
    //let dollars1 = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]
    
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
    var tidspunktDato: NSDate = NSDate()
    var sessionNumber: Int = 0
    var helvete : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FONTS AND COLORS
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
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
        print(dato)
        print(forbruk)
        print(hoyestePromille)
        print(antallOl)
        print(antallVin)
        print(antallDrink)
        print(antallShot)
        print(tidspunktDato)
        print("Session Number: \(sessionNumber)")
        print("Helvete: \(helvete)")
        
        testSessionNumber()
        
        // GRAPH
        self.lineGraph.delegate = self
        // Set descriptionText
        self.lineGraph.descriptionText = ""
        //Removing background grid
        self.lineGraph.leftAxis.drawGridLinesEnabled = true
        self.lineGraph.rightAxis.drawGridLinesEnabled = false
        self.lineGraph.xAxis.drawGridLinesEnabled = false
        //Removing frame:
        self.lineGraph.rightAxis.drawLabelsEnabled = false
        self.lineGraph.rightAxis.drawTopYLabelEntryEnabled = false
        self.lineGraph.rightAxis.drawAxisLineEnabled = false
        self.lineGraph.xAxis.labelPosition = .Bottom
        // Set color of descriptionText
        self.lineGraph.descriptionTextColor = setAppColors.descriptTextColor()
        // Set default text if there exists no data
        self.lineGraph.noDataText = "No data provided"
        self.lineGraph.userInteractionEnabled = false
        self.lineGraph.descriptionTextColor = UIColor.whiteColor()
        self.lineGraph.leftAxis.labelTextColor = UIColor.whiteColor()
        self.lineGraph.xAxis.labelTextColor = UIColor.whiteColor()
        
        //Experimentation
        self.lineGraph.backgroundColor = setAppColors.lineChartBackgroundColor()
        
        // add data to Chart
        setChartData(months)
        
        // set constraints
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChartData(months: [String]) {
        // Creating an array of data entries
        var yValues1 : [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < months.count; i++ {
            yValues1.append(ChartDataEntry(value: dollars1[i], xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yValues1, label: "")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(setAppColors.setLineColor().colorWithAlphaComponent(1.0)) // our line's opacity is 0%
        set1.setCircleColor(setAppColors.setLineSircleColor()) // our circle will be blue
        set1.lineWidth = 0.9
        set1.circleRadius = 6.0 // the radius of the node circle
        //set1.fillAlpha = 65 / 255.0
        //set1.fillColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        
        set1.highlightColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        set1.drawCubicEnabled = false
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
        
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(setAppColors.setTitleColorTextOnCircles())
        
        //5 - finally set our data
        self.lineGraph.data = data
        self.lineGraph.legend.enabled = false
        
        var graphGradiantColor = UIColor.whiteColor()
        
        let userGoal = coreDataBrain.fetchGoal()
        if(userGoal <= hoyestePromille){
            graphGradiantColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        } else {
            graphGradiantColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        }
        
        let gradColors = [graphGradiantColor.CGColor, UIColor.blackColor().CGColor]
        let colorLocations:[CGFloat] = [0.5, 0.1]
        if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocations) {
            set1.fill = ChartFill(linearGradient: gradient, angle: 90.0)
        }
    }
    
    func testSessionNumber(){
        var graphHistorikk = [GraphHistorikk]()
        
        months.removeAll()
        dollars1.removeAll()
        
        let timeStampFetch = NSFetchRequest(entityName: "GraphHistorikk")
        
        do {
            graphHistorikk = try moc.executeFetchRequest(timeStampFetch) as! [GraphHistorikk]
            for timeStampItem in graphHistorikk {
                let graphHistorikkSession = timeStampItem.sessionNumber!
                print("Alle sesjonsNummer: \(graphHistorikkSession)")
                print("if graphHistorikkSession(\(graphHistorikkSession)) == sessionNumber(\(sessionNumber))")
                if(sessionNumber == graphHistorikkSession){
                    print("sessionNumber iffen slo til!")
                    // populate x and y values with these values
                    let something = timeStampItem.timeStampAdded! as NSDate
                    var formatHour = ""
                    var formatMinute = ""
                    
                    let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: something)
                    let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: something)
                    
                    if(hour < 10){
                        formatHour = "0\(hour)"
                    } else {
                        formatHour = "\(hour)"
                    }
                    if(minute < 10){
                        formatMinute = "0\(minute)"
                    } else {
                        formatMinute = "\(minute)"
                    }
                    let formatOfDate = "\(formatHour).\(formatMinute)"
                    
                    months.append(formatOfDate)
                    for items in months{
                        print("Array X: \(items)")
                    }
                    
                    let promilleCurrent = timeStampItem.currentPromille! as Double
                    
                    dollars1.append(promilleCurrent)
                    for items in dollars1 {
                        print("Array Y: (dollars1) \(items)")
                    }
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.costTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.hoyestePromilleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.highPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            
            let yValueUnits : CGFloat = -20.0
            self.beerImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallOlLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.wineImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallVinLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.drinkImageVIew.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.shotImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallShotLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            let transformLeft : CGFloat = -35.0
            
            // OVERSIKT
            self.forbrukLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.costTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.hoyestePromilleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.highPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            
            let yValueUnits : CGFloat = 0.0
            self.beerImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallOlLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.wineImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallVinLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.drinkImageVIew.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.shotImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallShotLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            let transformLeft : CGFloat = 10.0
            
            // OVERSIKT
            self.forbrukLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.costTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.hoyestePromilleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            self.highPromTitleLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, 0.0)
            
            let yValueUnits : CGFloat = 10.0
            self.beerImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallOlLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.wineImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallVinLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.drinkImageVIew.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallDrinkLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.shotImageView.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
            self.antallShotLabel.transform = CGAffineTransformTranslate(self.view.transform, transformLeft, yValueUnits)
        }
    }
    
}
