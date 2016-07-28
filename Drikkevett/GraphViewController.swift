//  GraphViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 02.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import Charts
import CoreData

class GraphViewController: UIViewController, ChartViewDelegate {
    
    // Talk with core data
    let moc = DataController().managedObjectContext
    
    // Get Brain
    var brain = SkallMenyBrain()
    var dateUtil = DateUtil()
    
    // Get Colors
    var setAppColors = AppColors()
    
    @IBOutlet weak var lineGraph: LineChartView!

    var XAxis: [String]! = [String]()
    var YAxis: [Double]! = [Double]()
    
    var getGoalPromille : Double = 0.0
    var getGoalDate : NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        //self.view.layer.cornerRadius = 10
        //self.view.layer.shadowRadius = 10.0
        fetchUserData()
        
        lineGraph.noDataTextDescription = "Ingen data på graf."
        
        /* DETTE SKAL BRUKES I "EKTE" VERSJON*/
        populateAxises()
        
        // ADDING DUMMY DATA IF EDITING DESIGN:
        //XAxis = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J"]
        //YAxis = [0.6, 1.3, 1.1, 0.4, 0.9, 1.2, 2.2, 0.83, 0.98, 1.0, 1.9, 1.6, 1.1, 0.9, 1.0, 1.1, 1.3, 0.66, 0.9, 0.3, 2.1, 0.6, 0.2, 0.4, 1.1, 0.2, 1.8, 0.6, 0.33, 2.0]
        designChart()
        
        setChart(XAxis, values: YAxis)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
        lineGraph.noDataTextDescription = "Ingen data på graf."
        
        /* DETTE SKAL BRUKES I "EKTE" VERSJON*/
        populateAxises()
        
        // ADDING DUMMY DATA IF EDITING DESIGN:
        //XAxis = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J"]
        //YAxis = [0.6, 1.3, 1.1, 0.4, 0.9, 1.2, 2.2, 0.83, 0.98, 1.0, 1.9, 1.6, 1.1, 0.9, 1.0, 1.1, 1.3, 0.66, 0.9, 0.3, 2.1, 0.6, 0.2, 0.4, 1.1, 0.2, 1.8, 0.6, 0.33, 2.0]
        
        designChart()
        setChart(XAxis, values: YAxis)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineGraph.noDataText = "Statistikk over kveldene dine vil vises her."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Høyeste Promille Kvelder")
        let chartData = BarChartData(xVals: XAxis, dataSet: chartDataSet)
    
        //chartDataSet.valueFormatter?.maximumFractionDigits = 3
        //chartDataSet.valueFormatter?.minimumFractionDigits = 0
        //chartData.setValueFormatter(formatter)
        
        if(XAxis.isEmpty && YAxis.isEmpty){
        } else {
            lineGraph.data = chartData
        }
        chartDataSet.drawValuesEnabled = false
        lineGraph.descriptionText = ""
        
        var colors: [UIColor] = []
        
        for items in values {
            if(items > getGoalPromille){
                colors.append(UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)) // RED
            } else {
                colors.append(UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)) // GREEN
            }
        }
        
        chartDataSet.colors = colors
        lineGraph.rightAxis.removeAllLimitLines()
        lineGraph.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        let ll = ChartLimitLine(limit: getGoalPromille, label: "")
        ll.lineColor = UIColor.whiteColor()
        ll.lineDashLengths = [8.5]
        lineGraph.rightAxis.addLimitLine(ll)
    }
    
    func designChart(){
        self.lineGraph.noDataText = "ingen graf."
        self.lineGraph.leftAxis.drawGridLinesEnabled = false
        self.lineGraph.rightAxis.drawGridLinesEnabled = false
        self.lineGraph.xAxis.drawGridLinesEnabled = false
        self.lineGraph.xAxis.labelPosition = .Bottom
        self.lineGraph.rightAxis.drawTopYLabelEntryEnabled = false
        self.lineGraph.leftAxis.labelTextColor = UIColor.whiteColor()
        self.lineGraph.xAxis.labelTextColor = UIColor.whiteColor()
        self.lineGraph.rightAxis.enabled = false
        self.lineGraph.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.lineGraph.legend.enabled = false
        self.lineGraph.descriptionTextColor = UIColor.redColor()
        self.lineGraph.userInteractionEnabled = false
        self.lineGraph.pinchZoomEnabled = false
        self.lineGraph.doubleTapToZoomEnabled = false
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
                getGoalDate = item.goalDate! as NSDate
                print("UserData Home Fetched...")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
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
                //String(format:"%.2f", tempStringHighProm)
                let formatHighProm = Double(tempStringHighProm)
                
                let nf2 = NSNumberFormatter()
                nf2.numberStyle = .DecimalStyle
                nf2.minimumFractionDigits = 0
                nf2.maximumFractionDigits = 2
                print("Formatted From nf2: \(nf2.stringFromNumber(tempHighProm))")
                let formattedValue : Double = Double(nf2.stringFromNumber(tempHighProm)!)!
                print("Double Value = \(formattedValue)")
                
                print("FormattedHighProm: \(formatHighProm)")
                
                YAxis.append(formattedValue)
                
                for items in YAxis{
                    print("Array Y: \(items)")
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
}
