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
    
    var history:Historikk?
    let userDataDao = UserDataDao()
    let graphHistoryDao = GraphHistoryDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if history == nil {return}
        setTitle(date: history!.dato!)
        
        let selected = graphHistoryDao.getBySessionNumber(sessionNumber: history!.sessionNumber!)
        if selected.isEmpty {return}
        fillLineChart(selected: selected as! [GraphHistorikk])
        styleLineChart()
        
        costLabel.text = String(describing: history!.forbruk!) + ",-"
        bacLabel.text = String(describing: Double(history!.hoyestePromille!).roundTo(places: 2))
        setEnergyLabel()
        
        beerAmount.text = String(describing: history!.antallOl!)
        wineAmount.text = String(describing: history!.antallVin!)
        drinkAmount.text = String(describing: history!.antallDrink!)
        shotAmount.text = String(describing: history!.antallShot!)
        
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
        let beerUnits = Double(history?.antallOl ?? 0.0)
        let wineUnits = Double(history?.antallVin ?? 0.0)
        let drinkUnits = Double(history?.antallDrink ?? 0.0)
        let shotUnits = Double(history?.antallShot ?? 0.0)
        
        let kiloCalories = calculateAlcoholKiloCalories(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits).roundTo(places: 1)
        let kiloJoules = calculateAlcoholKiloJoules(beerUnits: beerUnits, wineUnits: wineUnits, drinkUnits: drinkUnits, shotUnits: shotUnits).roundTo(places: 1)
    
        energyLabel.text = "\(kiloCalories)/\(kiloJoules)"
    }
    
    func fillLineChart(selected:[GraphHistorikk]) {
        var dataPoints = [Date]()
        var lineDataEntry = [ChartDataEntry]()
        
        for i in 0..<selected.count {
            dataPoints.append(selected[i].timeStampAdded!)  //x axis
            lineDataEntry.append(ChartDataEntry(x: Double(i), y: selected[i].currentPromille as! Double))   //y axis
        }
        
        let userGoal = userDataDao.fetchUserData()!.goalPromille!
        let highestBac = getHighestBac(selected: selected)
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
    
    func getHighestBac(selected:[GraphHistorikk]) -> Double{
        var highestBac = 0.0
        for graphHistory in selected {
            if Double(graphHistory.currentPromille!) > highestBac {
                highestBac = graphHistory.currentPromille as! Double
            }
        }
        return highestBac
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
