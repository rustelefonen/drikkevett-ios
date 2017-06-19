//
//  HomeBarChartView.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.01.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class HomeBarChartView {
    
    let barChartView:BarChartView
    let userData:UserData
    let historyList:[Historikk]
    
    init(barChartView:BarChartView, userData:UserData, historyList:[Historikk]) {
        self.barChartView = barChartView
        self.userData = userData
        self.historyList = historyList
    }
    
    func styleBarChart(){
        barChartView.xAxis.labelPosition = .bottom
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.noDataText = "ingen graf."
        barChartView.rightAxis.drawTopYLabelEntryEnabled = false
        barChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        barChartView.leftAxis.labelTextColor = UIColor.white
        barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.chartDescription?.text = ""
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.chartDescription?.textColor = UIColor.red
        barChartView.isUserInteractionEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        let limitLine = ChartLimitLine(limit: userData.goalPromille as! Double)
        limitLine.lineColor = UIColor.white
        limitLine.lineDashLengths = [8.5, 8.5, 6.5]
        barChartView.rightAxis.addLimitLine(limitLine)
    }

    func getDataSet() {
        var dataEntries = [BarChartDataEntry]()
        var colors = [NSUIColor]()
        
        let redColor = NSUIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let greenColor = NSUIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        
        var days = [String]()
        
        for i in 0..<historyList.count{
            let history = historyList[i]
            let historyHighesetBAC = Double(history.hoyestePromille!)
            let day = Calendar.current.component(.day, from: history.dato! as Date)
            let month = DateUtil().getMonthOfYear(history.dato as Date?)!
            
            days.append("\(String(day)). \(month)")
            dataEntries.append(BarChartDataEntry(x: Double(i), y: historyHighesetBAC))
            
            if historyHighesetBAC > Double(userData.goalPromille!) { colors.append(redColor) }
            else { colors.append(greenColor) }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Brand 1")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = colors
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        //YVals
        barChartView.data = chartData
        
        //XVals
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
            return days[Int(index)]
        })
    }
}

