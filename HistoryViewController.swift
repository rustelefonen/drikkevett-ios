//
//  HistoryViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController :UIViewController {
    
    static let segueId = "showCellSegue"
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var history:Historikk?
    
    override func viewDidLoad() {
        title = String(describing: history?.dato)
    }
}
