//
//  HomeViewControllerNew.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 28.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class HomeViewControllerNew: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var defaultImage: UIImageView!
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var goalPieChartView: PieChartView!
    
    @IBOutlet weak var historyBarChartView: BarChartView!
    
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var totalHighestBac: UILabel!
    @IBOutlet weak var totalHighestAvgBac: UILabel!
    
    @IBOutlet weak var lastMonthCost: UILabel!
    @IBOutlet weak var lastMonthHighestBac: UILabel!
    @IBOutlet weak var lastMonthHighestAvgBac: UILabel!
    
    let userDataDao = UserDataDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTopCard()
        initPieCard()
        initBarCard()
        initCostCard()
    }
    
    func initTopCard() {
        greetingLabel.text = ResourceList.greetingArray[Int(arc4random_uniform(UInt32(ResourceList.greetingArray.count)))]
        nicknameLabel.text = userDataDao.fetchUserData()?.height
        quoteTextView.text = ResourceList.quoteArray[Int(arc4random_uniform(UInt32(ResourceList.quoteArray.count)))]
    }
    
    func initPieCard() {
        goalPieChartView.delegate = self
        let allHistories = HistoryDao().getAll()
        
        guard let goalBac = userDataDao.fetchUserData()?.goalPromille as? Double else {return}
        
        var overGoal = 0.0
        var underGoal = 0.0
        
        for history in allHistories {
            guard let historyHighestBac = history.hoyestePromille as? Double else {continue}
            if historyHighestBac > goalBac {overGoal += 1.0}
            else {underGoal += 1.0}
        }
        var dataEntries = [ChartDataEntry]()
        dataEntries.append(ChartDataEntry(x: 0.0, y: underGoal))
        dataEntries.append(ChartDataEntry(x: 1.0, y: overGoal))
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.colors = [AppColors.graphRed, AppColors.graphGreen]
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        goalPieChartView.data = pieChartData
        pieChartData.setDrawValues(false)
        
        styleGoalPieChart(goalBac: goalBac)
    }
    
    func styleGoalPieChart(goalBac:Double) {
        goalPieChartView.drawHoleEnabled = true
        goalPieChartView.holeRadiusPercent = CGFloat(0.80)
        goalPieChartView.holeColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        goalPieChartView.centerTextRadiusPercent = CGFloat(1.0)
        goalPieChartView.transparentCircleRadiusPercent = 0.85
        goalPieChartView.animate(yAxisDuration: 1.0)
        goalPieChartView.chartDescription?.text = ""
        goalPieChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        goalPieChartView.drawEntryLabelsEnabled = false
        goalPieChartView.legend.enabled = false
        goalPieChartView.isUserInteractionEnabled = false
        goalPieChartView.isUserInteractionEnabled = true
        
        let centerText = String(describing: goalBac)
        let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 27.0), NSForegroundColorAttributeName: UIColor.white]
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        goalPieChartView.centerAttributedText = attriButedString
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        goalTextView.text = ResourceList.pieChartTexts[Int(entry.x)]
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        goalTextView.text = ResourceList.pieChartTexts[2]
    }
    
    func initBarCard() {
        let historyList = HistoryDao().getAll()
        
        guard let goalBac = userDataDao.fetchUserData()?.goalPromille as? Double else {return}
        styleBarChart(goalBac: goalBac)
        
        var dataEntries = [BarChartDataEntry]()
        var colors = [NSUIColor]()
        
        var days = [String]()
        
        for i in 0..<historyList.count{
            let history = historyList[i]
            let historyHighesetBAC = Double(history.hoyestePromille!)
            let day = Calendar.current.component(.day, from: history.dato! as Date)
            let month = DateUtil().getMonthOfYear(history.dato as Date?)!
            
            days.append("\(String(day)). \(month)")
            dataEntries.append(BarChartDataEntry(x: Double(i), y: historyHighesetBAC))
            
            if historyHighesetBAC > goalBac { colors.append(AppColors.graphRed) }
            else { colors.append(AppColors.graphGreen) }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Brand 1")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = colors
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        //YVals
        historyBarChartView.data = chartData
        
        //XVals
        historyBarChartView.xAxis.granularity = 1
        historyBarChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
            return days[Int(index)]
        })
    }
    
    func styleBarChart(goalBac:Double){
        historyBarChartView.xAxis.labelPosition = .bottom
        historyBarChartView.leftAxis.drawGridLinesEnabled = false
        historyBarChartView.rightAxis.drawGridLinesEnabled = false
        historyBarChartView.xAxis.drawGridLinesEnabled = false
        historyBarChartView.noDataText = "ingen graf."
        historyBarChartView.rightAxis.drawTopYLabelEntryEnabled = false
        historyBarChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        historyBarChartView.leftAxis.labelTextColor = UIColor.white
        historyBarChartView.xAxis.labelTextColor = UIColor.white
        historyBarChartView.chartDescription?.text = ""
        historyBarChartView.leftAxis.axisMinimum = 0.0
        historyBarChartView.rightAxis.enabled = false
        historyBarChartView.legend.enabled = false
        historyBarChartView.chartDescription?.textColor = UIColor.red
        historyBarChartView.isUserInteractionEnabled = false
        historyBarChartView.pinchZoomEnabled = false
        historyBarChartView.doubleTapToZoomEnabled = false
        
        let limitLine = ChartLimitLine(limit: goalBac)
        limitLine.lineColor = UIColor.white
        limitLine.lineDashLengths = [8.5, 8.5, 6.5]
        historyBarChartView.rightAxis.addLimitLine(limitLine)
    }
    
    func initCostCard() {
        var totalCostValue = 0
        var totalHighestBacValue = 0.0
        var totalHighestBacSumValue = 0.0
        
        var lastMonthTotalCostValue = 0
        var lastMonthTotalHighestBacValue = 0.0
        var lastMonthTotalHighestBacSumValue = 0.0
        var lastMonthCount = 0.0
        
        let allHistories = HistoryDao().getAll()
        
        for history in allHistories {
            if let historyCost = history.forbruk as? Int {
                totalCostValue += historyCost
                if dateIsWithinThePastMonth(date: history.dato!) {lastMonthTotalCostValue += historyCost}
            }
            if let historyHighestBac = history.hoyestePromille as? Double {
                totalHighestBacSumValue += historyHighestBac
                if historyHighestBac > totalHighestBacValue {totalHighestBacValue = historyHighestBac}
                
                if dateIsWithinThePastMonth(date: history.dato!) {
                    lastMonthTotalHighestBacSumValue += historyHighestBac
                    if historyHighestBac > lastMonthTotalHighestBacValue {
                        lastMonthTotalHighestBacValue = historyHighestBac
                        lastMonthCount += 1.0
                    }
                }
            }
        }
        totalCost.text = String(describing: totalCostValue)
        totalHighestBac.text = String(describing: totalHighestBacValue.roundTo(places: 2))
        let totalHighestBacAvgValue = totalHighestBacSumValue / Double(allHistories.count)
        totalHighestAvgBac.text = String(describing: totalHighestBacAvgValue.roundTo(places: 2))
        
        lastMonthCost.text = String(describing: lastMonthTotalCostValue)
        lastMonthHighestBac.text = String(describing: lastMonthTotalHighestBacValue.roundTo(places: 2))
        let lastMonthTotalHighestBacAvgValue = lastMonthTotalHighestBacSumValue / lastMonthCount
        lastMonthHighestAvgBac.text = String(describing: lastMonthTotalHighestBacAvgValue.roundTo(places: 2))
    }
    
    func dateIsWithinThePastMonth(date:Date) -> Bool {
        guard let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return false
        }
        return date > oneMonthAgo
    }
}
