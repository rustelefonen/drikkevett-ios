//
//  HomeFormatter.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 19.12.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(HomeFormatter)
public class HomeFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let myDate = Date(timeIntervalSince1970: value)
        
        let norwegianMonth = getNorwegianMonthName(date: myDate)
        return "\((Calendar.current as NSCalendar).component(.day, from: myDate)).\(norwegianMonth)"
        
    }
    
    private func getNorwegianMonthName(date:Date) -> String{
        let month = (Calendar.current as NSCalendar).component(.month, from: date)
        print(month)
        if month == 1 {return "Januar"}
        else if month == 2 {return "Februar"}
        else if month == 3 {return "Mars"}
        else if month == 4 {return "April"}
        else if month == 5 {return "Mai"}
        else if month == 6 {return "Juni"}
        else if month == 7 {return "Juli"}
        else if month == 8 {return "August"}
        else if month == 9 {return "September"}
        else if month == 10 {return "Oktober"}
        else if month == 11 {return "November"}
        else if month == 12 {return "Desember"}
        return ""
    }
}
