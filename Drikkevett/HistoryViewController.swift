//
//  HistoryViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController, ChartViewDelegate {
    
    static let segueId = "showCellSegue"
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var beerAmount: UILabel!
    @IBOutlet weak var wineAmount: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBOutlet weak var shotAmount: UILabel!
    
    var history:History?
    let userDataDao = UserDataDao()
    let graphHistoryDao = GraphHistoryDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if history == nil {return}
        setTitle(date: (history?.beginDate)!)
        
        fillLineChart(units: history?.units?.allObjects as! [Unit])
        styleLineChart()
        costLabel.text = String(describing: calculateTotalCostBy(history: history!)) + ",-"
        
        bacLabel.text = String(describing: Double(getHighestBac(history: history!)).roundTo(places: 2))
        setEnergyLabel()
        
        
        setUnitAmounts()
        
    }
    
    func setUnitAmounts() {
        var beerCount = 0
        var wineCount = 0
        var drinkCount = 0
        var shotCount = 0
        
        for unit in history!.units!.allObjects as! [Unit] {
            if unit.unitType == "Beer" {beerCount += 1}
            else if unit.unitType == "Wine" {wineCount += 1}
            else if unit.unitType == "Drink" {drinkCount += 1}
            else if unit.unitType == "Shot" {shotCount += 1}
        }
        
        beerAmount.text = String(describing: beerCount)
        wineAmount.text = String(describing: wineCount)
        drinkAmount.text = String(describing: drinkCount)
        shotAmount.text = String(describing: shotCount)
    }
    
    func getHighestBac(history:History) ->Double {
        var addedBeerUnits = 0.0
        var addedWineUnits = 0.0
        var addedDrinkUnits = 0.0
        var addedShotUnits = 0.0
        
        if let units = history.units {
            for unit in units.allObjects as! [Unit] {
                if unit.unitType == "Beer" {
                    addedBeerUnits += 1.0
                } else if unit.unitType == "Wine" {
                    addedWineUnits += 1.0
                } else if unit.unitType == "Drink" {
                    addedDrinkUnits += 1.0
                } else if unit.unitType == "Shot" {
                    addedShotUnits += 1.0
                }
            }
        }
        
        let totalGrams = (addedBeerUnits * Double(history.beerGrams ?? 0.0)) + (addedWineUnits * Double(history.wineGrams ?? 0.0)) + (addedDrinkUnits * Double(history.drinkGrams ?? 0.0)) + (addedShotUnits * Double(history.shotGrams ?? 0.0))
        
        let genderScore = Bool(history.gender ?? 1) ? 0.7 : 0.6
        
        var highestBac = (totalGrams/(Double(history.weight ?? 0.0) * genderScore)).roundTo(places: 2)
        if highestBac < 0.0 {highestBac = 0.0}
        
        return highestBac
    }

    func styleLineChart() {
        lineChartView.delegate = self
        lineChartView.chartDescription?.text = ""
        lineChartView.leftAxis.drawGridLinesEnabled = true
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.forceLabelsEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawTopYLabelEntryEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.noDataText = "No data provided"
        lineChartView.isUserInteractionEnabled = false
        lineChartView.chartDescription?.textColor = UIColor.white
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.legend.enabled = false
        lineChartView.backgroundColor = AppColors().lineChartBackgroundColor()
    }
    
    func setEnergyLabel() {
        var beerUnits = 0.0
        var wineUnits = 0.0
        var drinkUnits = 0.0
        var shotUnits = 0.0
        
        for unit in history!.units!.allObjects as! [Unit] {
            if unit.unitType == "Beer" {beerUnits += 1.0}
            else if unit.unitType == "Wine" {wineUnits += 1.0}
            else if unit.unitType == "Drink" {drinkUnits += 1.0}
            else if unit.unitType == "Shot" {shotUnits += 1.0}
        }
        
        let beerGrams = Double(history?.beerGrams ?? 0.0)
        let wineGrams = Double(history?.wineGrams ?? 0.0)
        let drinkGrams = Double(history?.drinkGrams ?? 0.0)
        let shotGrams = Double(history?.shotGrams ?? 0.0)
        
        let kiloCalories = calculateAlcoholKiloCalories(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits, beerGrams: beerGrams, wineGrams: wineGrams, drinkGrams: drinkGrams, shotGrams: shotGrams)
        let kiloJoules = calculateAlcoholKiloJoules(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits, beerGrams: beerGrams, wineGrams: wineGrams, drinkGrams: drinkGrams, shotGrams: shotGrams)
    
        energyLabel.text = "\(kiloCalories)/\(kiloJoules)"
    }
    
    func fillLineChart(units:[Unit]) {
        var dataPoints = [Date]()
        var lineDataEntry = [ChartDataEntry]()
        
        var beerUnits = 0.0
        var wineUnits = 0.0
        var drinkUnits = 0.0
        var shotUnits = 0.0
        
        var i = 0
        
        for unit in units.sorted(by: { $0.timeStamp! < $1.timeStamp! }) {
            dataPoints.append(unit.timeStamp!)  //x axis
            
            let hours = unit.timeStamp!.timeIntervalSince(history!.beginDate!) / 3600.0
            
            if unit.unitType == "Beer" {beerUnits += 1.0}
            else if unit.unitType == "Wine" {wineUnits += 1.0}
            else if unit.unitType == "Drink" {drinkUnits += 1.0}
            else if unit.unitType == "Shot" {shotUnits += 1.0}
            
            guard let userData = AppDelegate.getUserData() else {continue}
            
            let bac = calculateBac(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits, hours: hours, weight: Double(userData.weight ?? 0.0), gender: Bool(userData.gender ?? 1), beerGrams: Double(history?.beerGrams ?? 0.0), wineGrams: Double(history?.wineGrams ?? 0.0), drinkGrams: Double(history?.drinkGrams ?? 0.0), shotGrams: Double(history?.shotGrams ?? 0.0))
            
            lineDataEntry.append(ChartDataEntry(x: Double(i), y: bac))   //y axis
            
            i += 1
        }
        
        let userGoal = AppDelegate.getUserData()!.goalPromille!
        let highestBac = getHighestBac(history: history!)
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: "")
        
        if Double(userGoal) <= highestBac{setLineChartDataProperties(dataSet: chartDataSet, color: AppColors.graphRed)}
        else {setLineChartDataProperties(dataSet: chartDataSet, color: AppColors.graphGreen)}
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        
        let formatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter
        
        lineChartView.xAxis.valueFormatter = xAxis.valueFormatter
        lineChartView.data = chartData
    }
    
    func setLineChartDataProperties(dataSet: LineChartDataSet, color:UIColor){
        dataSet.axisDependency = .left
        dataSet.setColor(AppColors().setLineColor().withAlphaComponent(1.0))
        dataSet.setCircleColor(AppColors().setLineSircleColor())
        dataSet.lineWidth = 0.9
        dataSet.circleRadius = 6.0
        dataSet.fillAlpha = 65 / 255.0
        dataSet.fillColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        dataSet.highlightColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        dataSet.drawCubicEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawValuesEnabled = false
        
        let gradColors = [color.cgColor, UIColor.black.cgColor]
        let colorLocations:[CGFloat] = [0.5, 0.1]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            dataSet.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
    }
    
    func setTitle(date:Date) {
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let monthNumber = calendar.component(.month, from: date)
        let month = ResourceList.norwegianMonths[monthNumber - 1]
        let americanWeekDay = calendar.component(.weekday, from: date)
        
        if americanWeekDay == 1 {
            title = ResourceList.norwegianWeekDays[6] + " " + String(describing: day) + ". " + month
        }
        else {
            title = ResourceList.norwegianWeekDays[americanWeekDay - 2] + " " + String(describing: day) + ". " + month
        }
    }
    
    @IBAction func editHistory(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: AfterRegisterViewController.segueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AfterRegisterViewController.segueId {
            if let destination = segue.destination as? AfterRegisterViewController {
                destination.history = history
            }
        }
    }
    
}
