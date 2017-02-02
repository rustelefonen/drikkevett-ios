//  GraphViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 02.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import Charts
import CoreData

class GraphViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    let moc = DataController().managedObjectContext
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        
        let userDataDao = UserDataDao()
        let userData = userDataDao.fetchUserData()! //Skummelt?
        
        let historyDao = HistoryDao()
        let historyList = historyDao.getAll()
        
        let homeBarChartView = HomeBarChartView(barChartView: barChartView, userData:userData, historyList: historyList)
        homeBarChartView.styleBarChart()
        homeBarChartView.getDataSet()
    }
}
