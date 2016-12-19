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

    var xAxis: [String]! = [String]()
    var YAxis: [Double]! = [Double]()
    var newXAxis : [Double] = [Double]()
    
    var getGoalPromille : Double = 0.0
    var getGoalDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        //self.view.layer.cornerRadius = 10
        //self.view.layer.shadowRadius = 10.0
        fetchUserData()
        
        lineGraph.noDataText = "Ingen data på graf."
        
        /* DETTE SKAL BRUKES I "EKTE" VERSJON*/
        populateAxises()
        
        // ADDING DUMMY DATA IF EDITING DESIGN:
        //XAxis = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J"]
        //YAxis = [0.6, 1.3, 1.1, 0.4, 0.9, 1.2, 2.2, 0.83, 0.98, 1.0, 1.9, 1.6, 1.1, 0.9, 1.0, 1.1, 1.3, 0.66, 0.9, 0.3, 2.1, 0.6, 0.2, 0.4, 1.1, 0.2, 1.8, 0.6, 0.33, 2.0]
        designChart()
        
        setChart(xAxis, values: YAxis)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
        lineGraph.noDataText = "Ingen data på graf."
        
        /* DETTE SKAL BRUKES I "EKTE" VERSJON*/
        populateAxises()
        
        // ADDING DUMMY DATA IF EDITING DESIGN:
        //XAxis = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J", "G", "H", "I", "J", "I", "J", "G", "H", "I", "J"]
        //YAxis = [0.6, 1.3, 1.1, 0.4, 0.9, 1.2, 2.2, 0.83, 0.98, 1.0, 1.9, 1.6, 1.1, 0.9, 1.0, 1.1, 1.3, 0.66, 0.9, 0.3, 2.1, 0.6, 0.2, 0.4, 1.1, 0.2, 1.8, 0.6, 0.33, 2.0]
        
        designChart()
        setChart(xAxis, values: YAxis)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        lineGraph.noDataText = "Statistikk over kveldene dine vil vises her."
        
        
        
        let formato = HomeFormatter()
        let xaxis:XAxis = XAxis()
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        print("count: \(newXAxis.count)")
        
        
        //lineGraph.xAxis.axisMinimum = Double(newXAxis.count) //max(0.0, lineChart.data!.yMin - 1.0)
        //lineGraph.xAxis.axisMaximum = Double(newXAxis.count) //min(10.0, lineChart.data!.yMax + 1.0)
        
        for i in 0..<newXAxis.count {
            
            formato.stringForValue(newXAxis[i], axis: xaxis)    //This is needed
            
            let dataEntry = BarChartDataEntry(x: newXAxis[i], y: values[i])
            dataEntries.append(dataEntry)
        }
        
        xaxis.valueFormatter = formato
        lineGraph.xAxis.valueFormatter = xaxis.valueFormatter
        
        
        
        
        print("\n\n\n")
        print(dataEntries)
        print("\n\n\n")
        
        /*let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2*/
        
        //let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Høyeste Promille Kvelder")
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Høyeste Promille Kvelder")
        
        //let chartData = BarChartData(xVals: XAxis, dataSet: chartDataSet) //gammel
        let chartData = BarChartData(dataSet: chartDataSet) //ny
        
        
        if(xAxis.isEmpty && YAxis.isEmpty){
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
        ll.lineColor = UIColor.white
        ll.lineDashLengths = [8.5]
        lineGraph.rightAxis.addLimitLine(ll)
    }
    
    func designChart(){
        self.lineGraph.noDataText = "ingen graf."
        self.lineGraph.leftAxis.drawGridLinesEnabled = false
        self.lineGraph.rightAxis.drawGridLinesEnabled = false
        self.lineGraph.xAxis.drawGridLinesEnabled = false
        self.lineGraph.xAxis.labelPosition = .bottom
        self.lineGraph.rightAxis.drawTopYLabelEntryEnabled = false
        self.lineGraph.leftAxis.labelTextColor = UIColor.white
        self.lineGraph.xAxis.labelTextColor = UIColor.white
        self.lineGraph.rightAxis.enabled = false
        self.lineGraph.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        self.lineGraph.legend.enabled = false
        self.lineGraph.descriptionTextColor = UIColor.red
        self.lineGraph.isUserInteractionEnabled = false
        self.lineGraph.pinchZoomEnabled = false
        self.lineGraph.doubleTapToZoomEnabled = false
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        
        let timeStampFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
            
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
                getGoalDate = item.goalDate! as Date
                print("UserData Home Fetched...")
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func populateAxises() {
        xAxis.removeAll()
        YAxis.removeAll()
        newXAxis.removeAll()
        
        var historikk = [Historikk]()
        let timeStampFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Historikk")
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
            for timeStampItem in historikk {
                print("Start Time PlanKveld: \(timeStampItem.dato!)")
                let tempStartDate = timeStampItem.dato! as Date
                
                print("MONTH: \(getDayOfWeek(tempStartDate))")
                
                let date = dateUtil.getDateOfMonth(tempStartDate)!
                let month = dateUtil.getMonthOfYear(tempStartDate)!
                let formatOfDate = "\(date).\(month)"
                
                xAxis.append(formatOfDate)
                newXAxis.append(Double(tempStartDate.timeIntervalSince1970))
                for items in xAxis{
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
                let formatHighProm = Double(tempHighProm)
                YAxis.append(formatHighProm)
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    func getDayOfWeek(_ today:Date) -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.month, from: today)
        return weekDay
    }
}
