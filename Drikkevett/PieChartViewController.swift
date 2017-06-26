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

    let moc = DataController().managedObjectContext
    var brain = SkallMenyBrain()
    
    @IBOutlet weak var pieChartTextVuew: UITextView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var goalReached = 0
    var overGoal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        
        pieChartView.delegate = self
        
        let months = ["", ""]
        populatePieChart()
        let unitsSold = [Double(goalReached), Double(overGoal)]
        
        setChart(months, values: unitsSold)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let months = ["", ""]
        populatePieChart()
        let unitsSold = [Double(goalReached), Double(overGoal)]
        
        setChart(months, values: unitsSold)
        
    }

    func setChart(_ dataPoints: [String], values: [Double]) {
        //Creating Chart
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            //let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        //let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "???")
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "???")
        
        //let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
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
        pieChartView.chartDescription?.text = ""
        pieChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        //pieChartView.transparentCircleColor?.cgColor
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.isUserInteractionEnabled = false
        
        let centerText = "\(fetchGoal())"
        let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 27.0), NSForegroundColorAttributeName: UIColor.white]
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        pieChartView.centerAttributedText = attriButedString
        pieChartView.isUserInteractionEnabled = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        pieChartTextVuew.text = ResourceList.homeChartTexts[Int(entry.x)]
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.pieChartTextVuew.text = "Målet ditt vises i diagrammet til høyre. Fargene illustrerer hvordan det står til med makspromillen din."
    }
    
    func populatePieChart() {
        // CLEAR VARIABLES
        overGoal = 0
        goalReached = 0
        
        var historikk = [Historikk]()
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        let goalProm = fetchGoal()
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
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
        return UserDataDao().fetchUserData()?.goalPromille as! Double
    }
}
