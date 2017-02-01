//
//  BarChartView.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 25.01.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts
import CoreData

class BarChartComponent: UIViewController {
    
    let moc = DataController().managedObjectContext
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        let userData = getUserData()
        let historyList = getHistoryList()
        
        let homeBarChartView = HomeBarChartView(barChartView: barChartView, userData:userData, historyList: historyList)
        homeBarChartView.styleBarChart()
        homeBarChartView.getDataSet()
    }
    
    func getUserData() -> UserData{
        var userData = [UserData]()
        
        let timeStampFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.fetch(timeStampFetch) as! [UserData]
        } catch {
            fatalError("bad things happened \(error)")
        }
        return userData.first!
    }
    
    func getHistoryList() -> [Historikk]{
        var historikk = [Historikk]()
        let timeStampFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Historikk")
        
        do {
            historikk = try moc.fetch(timeStampFetch) as! [Historikk]
        } catch {
            fatalError("bad things happened \(error)")
        }
        return historikk
        
    }
}
