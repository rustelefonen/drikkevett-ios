//
//  ChartFormatter.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class ChartFormatter : NSObject, IAxisValueFormatter {
    
    var drinkTimestamps = [Date]()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let myDate = drinkTimestamps[Int(value)]
        
        var formatHour = ""
        var formatMinute = ""
        
        let hour = (Calendar.current as NSCalendar).component(.hour, from: myDate)
        let minute = (Calendar.current as NSCalendar).component(.minute, from: myDate)
        
        if(hour < 10) {formatHour = "0\(hour)"}
        else {formatHour = "\(hour)"}
        
        if(minute < 10) {formatMinute = "0\(minute)"}
        else {formatMinute = "\(minute)"}
        
        return "\(formatHour).\(formatMinute)"
    }
    
    func setValues(values: [Date]) {
        drinkTimestamps = values
    }
}
