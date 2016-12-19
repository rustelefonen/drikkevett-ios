//
//  HistoryFormatter.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 19.12.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(HistoryFormatter)
public class HistoryFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let myDate = Date(timeIntervalSince1970: value)
        
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
}
