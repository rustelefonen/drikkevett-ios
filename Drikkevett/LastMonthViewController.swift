//  LastMonthViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 07.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class LastMonthViewController: UIViewController {

    // LABELS
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highestPromLastMonth: UILabel!
    @IBOutlet weak var averageHighPromLastMonth: UILabel!
    @IBOutlet weak var costsLastMonth: UILabel!
    @IBOutlet weak var totalCosts: UILabel!
    @IBOutlet weak var totalHighestPromille: UILabel!
    @IBOutlet weak var averageHighestPromille: UILabel!
    
    // TITLES
    @IBOutlet weak var titleTotalCosts: UILabel!
    @IBOutlet weak var titleHighestProm: UILabel!
    @IBOutlet weak var titleAvgProm: UILabel!
    @IBOutlet weak var lastMonthTitleCost: UILabel!
    @IBOutlet weak var lastMonthHighProm: UILabel!
    @IBOutlet weak var lastMonthAvgProm: UILabel!
    
    let calendar = NSCalendar.currentCalendar()
    
    var getGoalPromille = 0.0
    var getGoalDate = NSDate()
    
    //
    let brainCoreData = CoreDataMethods()
    let moc = DataController().managedObjectContext
    
    // set colors
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let comps2 = NSDateComponents()
        
        // DATOER SOM SKAL SJEKKES
        comps2.day = -23
        
        let dueDate = calendar.dateByAddingComponents(comps2, toDate: NSDate(), options: NSCalendarOptions())
        print("Dato som skal sjekkes: \(dueDate!)")
        
        setValues()
        //checkDatesOneMonth(dueDate!)
        
        // COLORS AND FONTS
        // (235 - 235 - 235)
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        //self.view.layer.cornerRadius = 10
        //self.view.layer.shadowRadius = 10.0
        
        // START UP FUNCTIONS
        fetchUserData()
        updateHomeViewDidLoad()
        
        // TITLES
        titleLabel.textColor = setAppColors.textHeadlinesColors()
        titleLabel.font = setAppColors.textHeadlinesFonts(15)
        totalTitleLabel.textColor = setAppColors.textHeadlinesColors()
        totalTitleLabel.font = setAppColors.textHeadlinesFonts(15)
        
        // VALUES
        highestPromLastMonth.textColor = setAppColors.textUnderHeadlinesColors()
        highestPromLastMonth.font = setAppColors.textUnderHeadlinesFonts(27)
        averageHighPromLastMonth.textColor = setAppColors.textUnderHeadlinesColors()
        averageHighPromLastMonth.font = setAppColors.textUnderHeadlinesFonts(27)
        costsLastMonth.textColor = setAppColors.textUnderHeadlinesColors()
        costsLastMonth.font = setAppColors.textUnderHeadlinesFonts(27)
        
        totalHighestPromille.textColor = setAppColors.textUnderHeadlinesColors()
        totalHighestPromille.font = setAppColors.textUnderHeadlinesFonts(27)
        averageHighestPromille.textColor = setAppColors.textUnderHeadlinesColors()
        averageHighestPromille.font = setAppColors.textUnderHeadlinesFonts(27)
        totalCosts.textColor = setAppColors.textUnderHeadlinesColors()
        totalCosts.font = setAppColors.textUnderHeadlinesFonts(27)
        
        setConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // START UP FUNCTIONS
        fetchUserData()
        updateHomeViewDidLoad()
        setValues()
    }

    func checkDatesOneMonth(checkDate: NSDate){
        // SJEKK DATOER INNEFOR 1 MÅNED
        let comps = NSDateComponents()
        comps.day = -30
        
        let date2 = calendar.dateByAddingComponents(comps, toDate: NSDate(), options: NSCalendarOptions())
        print("DATOE FOR 30 DAGER SIDEN: \(date2!)")
        if checkDate.compare(date2!) == NSComparisonResult.OrderedDescending
        {
            print("DATOEN ER INNENFOR 1 MÅNED")
        } else if checkDate.compare(date2!) == NSComparisonResult.OrderedAscending
        {
            print("DATOEN ER LENGER UNNA ENN 1 MÅNED")
        } else
        {
            print("due in exactly a week (to the second, this will rarely happen in practice)")
        }
    }
    
    func setValues(){
        let checkTotalForbruk : Double = 0.0
        let checkTotalHighestPromille : Double = 0.0
        var formatTotalHighestPromille = ""
        let checkTotalAverageHighestPromille : Double = 0.0
        var formatTotalAverageHighestPromille = ""
        
        let isEntityEmpty = brainCoreData.entityIsEmpty("Historikk")
        
        if(isEntityEmpty == false){
            let whatIsTotalForbruk = brainCoreData.lastMonthTotalForbruk(checkTotalForbruk)
            let yestValuesToInt = Int(whatIsTotalForbruk)
            self.costsLastMonth.text = "\(yestValuesToInt),-"
            
            let whatIsTotalHighPromille = brainCoreData.lastMonthHighestPromille(checkTotalHighestPromille)
            formatTotalHighestPromille = String(format: "%.2f", whatIsTotalHighPromille)
            self.highestPromLastMonth.text = "\(formatTotalHighestPromille)"
            
            //let whatIsTotalAverageHighPromille = brainCoreData.updateTotalAverageHighestPromille(checkTotalAverageHighestPromille)
            let whatIsTotalAverageHighPromille = brainCoreData.lastMonthTotAvgHighProm(checkTotalAverageHighestPromille)
            formatTotalAverageHighestPromille = String(format: "%.2f", whatIsTotalAverageHighPromille)
            self.averageHighPromLastMonth.text = "\(formatTotalAverageHighestPromille)"
        } else {}
    }
    
    func updateHomeViewDidLoad(){
        let checkTotalForbruk : Double = 0.0
        let checkTotalHighestPromille : Double = 0.0
        var formatTotalHighestPromille = ""
        let checkTotalAverageHighestPromille : Double = 0.0
        var formatTotalAverageHighestPromille = ""
        
        let isEntityEmpty = brainCoreData.entityIsEmpty("Historikk")
        
        if(isEntityEmpty == false){
            let whatIsTotalForbruk = brainCoreData.updateTotalForbruk(checkTotalForbruk)
            let forceInteger = Int(whatIsTotalForbruk)
            self.totalCosts.text = "\(forceInteger),-"
            
            let whatIsTotalHighPromille = brainCoreData.updateTotalHighestPromille(checkTotalHighestPromille)
            formatTotalHighestPromille = String(format: "%.2f", whatIsTotalHighPromille)
            self.totalHighestPromille.text = "\(formatTotalHighestPromille)"
            
            let whatIsTotalAverageHighPromille = brainCoreData.updateTotalAverageHighestPromille(checkTotalAverageHighestPromille)
            formatTotalAverageHighestPromille = String(format: "%.2f", whatIsTotalAverageHighPromille)
            self.averageHighestPromille.text = "\(formatTotalAverageHighestPromille)"
        } else {}
    }
    
    func fetchUserData() {
        var userData = [UserData]()
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
                getGoalDate = item.goalDate! as NSDate
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // CONSTRAINTS
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.titleTotalCosts.font = setAppColors.textUnderHeadlinesFonts(13)
            self.titleHighestProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.titleAvgProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthTitleCost.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthHighProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthAvgProm.font = setAppColors.textUnderHeadlinesFonts(13)
            
            // TRANSFORM
            self.titleTotalCosts.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.titleHighestProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.titleAvgProm.transform = CGAffineTransformTranslate(self.view.transform, -4.0, -17.0)
            self.averageHighestPromille.transform = CGAffineTransformTranslate(self.view.transform, -4.0, 0.0)
            
            self.lastMonthTitleCost.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.lastMonthHighProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.lastMonthAvgProm.transform = CGAffineTransformTranslate(self.view.transform, -4.0, -17.0)
            self.averageHighPromLastMonth.transform = CGAffineTransformTranslate(self.view.transform, -4.0, 0.0)
            
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            // FONT
            self.titleTotalCosts.font = setAppColors.textUnderHeadlinesFonts(13)
            self.titleHighestProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.titleAvgProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthTitleCost.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthHighProm.font = setAppColors.textUnderHeadlinesFonts(13)
            self.lastMonthAvgProm.font = setAppColors.textUnderHeadlinesFonts(13)
            
            // TRANSFORM
            self.titleTotalCosts.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.titleHighestProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.titleAvgProm.transform = CGAffineTransformTranslate(self.view.transform, -4.0, -17.0)
            self.averageHighestPromille.transform = CGAffineTransformTranslate(self.view.transform, -4.0, 0.0)
            
            self.lastMonthTitleCost.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.lastMonthHighProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.lastMonthAvgProm.transform = CGAffineTransformTranslate(self.view.transform, -4.0, -17.0)
            self.averageHighPromLastMonth.transform = CGAffineTransformTranslate(self.view.transform, -4.0, 0.0)
            
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            // TRANSFORM
            self.titleTotalCosts.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.titleHighestProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -17.0)
            self.titleAvgProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -17.0)
            
            self.lastMonthTitleCost.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -23.0)
            self.lastMonthHighProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -17.0)
            self.lastMonthAvgProm.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -17.0)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
        }
    }
}
