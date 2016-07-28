//  DateUtil.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 28.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import Foundation

class DateUtil
{
    func getDayOfWeekAsString(today: NSDate?) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalender.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Søndag"
            case 2:
                return "Mandag"
            case 3:
                return "Tirsdag"
            case 4:
                return "Onsdag"
            case 5:
                return "Torsdag"
            case 6:
                return "Fredag"
            case 7:
                return "Lørdag"
            default:
                print("error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
    func getDateOfMonth(today: NSDate?)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Day, fromDate: todayDate)
            let weekDay = myComponents.day
            switch weekDay {
            case 1:
                return "1"
            case 2:
                return "2"
            case 3:
                return "3"
            case 4:
                return "4"
            case 5:
                return "5"
            case 6:
                return "6"
            case 7:
                return "7"
            case 8:
                return "8"
            case 9:
                return "9"
            case 10:
                return "10"
            case 11:
                return "11"
            case 12:
                return "12"
            case 13:
                return "13"
            case 14:
                return "14"
            case 15:
                return "15"
            case 16:
                return "16"
            case 17:
                return "17"
            case 18:
                return "18"
            case 19:
                return "19"
            case 20:
                return "20"
            case 21:
                return "21"
            case 22:
                return "22"
            case 23:
                return "23"
            case 24:
                return "24"
            case 25:
                return "25"
            case 26:
                return "26"
            case 27:
                return "27"
            case 28:
                return "28"
            case 29:
                return "29"
            case 30:
                return "30"
            case 31:
                return "31"
            default:
                print("Error fetching Date Of Month")
                return "Dag"
            }
        } else {
            return nil
        }
    }
    
    func getMonthOfYear(today:NSDate?)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = today {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Month, fromDate: todayDate)
            let month = myComponents.month
            switch month {
            case 1:
                return "Januar"
            case 2:
                return "Februar"
            case 3:
                return "Mars"
            case 4:
                return "April"
            case 5:
                return "Mai"
            case 6:
                return "Juni"
            case 7:
                return "Juli"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "Oktober"
            case 11:
                return "November"
            case 12:
                return "Desember"
            default:
                print("Error fetching months")
                return "Month"
            }
        } else {
            return nil
        }
    }
}