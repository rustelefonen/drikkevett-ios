//
//  PieChartViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 07.04.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts
import CoreData

class PieChartViewController: UIViewController, ChartViewDelegate {

    // Talk with core data
    let moc = DataController().managedObjectContext
    
    // Get Brain
    var brain = SkallMenyBrain()
    
    // LABEL
    @IBOutlet weak var pieChartTextVuew: UITextView!
    
    // pluss / minus
    var goalReached = 0
    var overGoal = 0
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        
        // DELEGATE
        pieChartView.delegate = self
        
        //Values:
        let months = ["", ""]
        populatePieChart()
        let unitsSold = [Double(goalReached), Double(overGoal)]
        
        //DUMMY DATA:
        //unitsSold = [10.0, 15.0]
        
        setChart(months, values: unitsSold)
        
        // Constraints
        setConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Values:
        
        let months = ["", ""]
        populatePieChart()
        let unitsSold = [Double(goalReached), Double(overGoal)]
        
        setChart(months, values: unitsSold)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
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
        
        //Styling chart:
        pieChartDataSet.colors = [UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0), UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.3)]
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = CGFloat(0.80)
        pieChartView.holeColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        pieChartView.centerTextRadiusPercent = CGFloat(1.0)
        pieChartView.transparentCircleRadiusPercent = 0.85
        pieChartView.animate(yAxisDuration: 1.0)
        pieChartView.descriptionText = ""
        pieChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        pieChartView.transparentCircleColor?.CGColor
        pieChartView.drawSliceTextEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.userInteractionEnabled = false
        
        let centerText = "\(fetchGoal())"
        let fontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(27.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        pieChartView.centerAttributedText = attriButedString
        pieChartView.userInteractionEnabled = true
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        if(entry.xIndex == 0){
            self.pieChartTextVuew.text = "Målet ditt er her rødt fordi du har gjort det dårlig!!"
            
        }
        if(entry.xIndex == 1){
            self.pieChartTextVuew.text = "Målet ditt er her grønt fordi du har gjort det bra!"
        }
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        self.pieChartTextVuew.text = "Denne grafikken viser hvordan det står til med målet ditt. Ønsker du å vite mer klikk på fargene"
    }
    
    func populatePieChart() {
        // CLEAR VARIABLES
        overGoal = 0
        goalReached = 0
        
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest(entityName: "Historikk")
        let goalProm = fetchGoal()
        do {
            historikk = try moc.executeFetchRequest(timeStampFetch) as! [Historikk]
            for hoyesteProm in historikk {
                let tempHighProm = hoyesteProm.hoyestePromille! as Double
                if(goalProm >= tempHighProm){
                    overGoal += 1
                }
                if(goalProm < tempHighProm){
                    goalReached += 1
                }
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }

    func fetchGoal() -> Double{
        var userData = [UserData]()
        var getGoalPromille = 0.0
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalPromille
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.pieChartTextVuew.transform = CGAffineTransformTranslate(self.view.transform, -35.0, 0.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.pieChartTextVuew.transform = CGAffineTransformTranslate(self.view.transform, -50.0, 0.0)
        }
    }
}