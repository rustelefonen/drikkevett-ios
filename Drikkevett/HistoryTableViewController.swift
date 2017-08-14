//
//  HistoryTableViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 26.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class HistoryTableViewController : UITableViewController {
    let cellId = "historyCell"
    
    var allHistoryEntries = [HistoryEntry]()
    let historyDao = HistoryDao()
    let newHistoryDao = NewHistoryDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tableBackground = tableView.backgroundView {
            AppColors.setBackground(view: tableBackground)
        }
        allHistoryEntries = getHistoryEntries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        allHistoryEntries = getHistoryEntries()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allHistoryEntries.count > 0 {
            return allHistoryEntries[section].histories?.count ?? 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allHistoryEntries.count > 0 ? allHistoryEntries[section].section : "Ingen kvelder"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allHistoryEntries.count > 0 ? allHistoryEntries.count : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Slett"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyEntry = allHistoryEntries[indexPath.section].histories![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        
        cell.dateLabel.text = "\(getDayFrom(date: (historyEntry.beginDate)!))"
        
        let highestBac = getHighestBac(history: historyEntry)
        cell.highestBacLabel.text = "Høyeste promille " + String(describing: Double(highestBac).roundTo(places: 2))
        
        cell.costLabel.text = String(describing: getNorwegianDayFrom(date: (historyEntry.beginDate!))) + " brukte du " + String(describing: calculateTotalCostBy(history: historyEntry)) + ",-"
        
        let goal = Double(AppDelegate.getUserData()?.goalPromille ?? 0.0)
        let red = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let green = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        
        if highestBac > goal {
            cell.highestBacLabel.textColor = red
            cell.circleView.ringColor = red
        }
        else {
            cell.highestBacLabel.textColor = green
            cell.circleView.ringColor = green
        }
        
        return cell
    }
    
    func getHighestBac(history:History) ->Double {
        var addedBeerUnits = 0.0
        var addedWineUnits = 0.0
        var addedDrinkUnits = 0.0
        var addedShotUnits = 0.0
        
        if let units = history.units {
            for unit in units.allObjects as! [Unit] {
                if unit.unitType == "Beer" {
                    addedBeerUnits += 1.0
                } else if unit.unitType == "Wine" {
                    addedWineUnits += 1.0
                } else if unit.unitType == "Drink" {
                    addedDrinkUnits += 1.0
                } else if unit.unitType == "Shot" {
                    addedShotUnits += 1.0
                }
            }
        }
        
        let totalGrams = (addedBeerUnits * Double(history.beerGrams ?? 0.0)) + (addedWineUnits * Double(history.wineGrams ?? 0.0)) + (addedDrinkUnits * Double(history.drinkGrams ?? 0.0)) + (addedShotUnits * Double(history.shotGrams ?? 0.0))
        
        let genderScore = Bool(history.gender ?? 1) ? 0.7 : 0.6
        
        var highestBac = (totalGrams/(Double(history.weight ?? 0.0) * genderScore)).roundTo(places: 2)
        if highestBac < 0.0 {highestBac = 0.0}
        
        return highestBac
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {       //Rar kode
        view.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: HistoryViewController.segueId, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HistoryViewController.segueId {
            if segue.destination is HistoryViewController {
                let destination = segue.destination as! HistoryViewController
                if sender is IndexPath {
                    let indexPath = sender as! IndexPath
                    destination.history = allHistoryEntries[indexPath.section].histories?[indexPath.row]
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func getMonthYearLabelFrom(date:Date) -> String {
        let calendar = Calendar.current
        
        let monthNumber = calendar.component(.month, from: date)
        let month = ResourceList.norwegianMonths[monthNumber - 1]
        let year = calendar.component(.year, from: date)
        
        return month + " - \(year)"
    }
    
    func getDayFrom(date:Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    func getNorwegianDayFrom(date:Date) -> String {
        let calendar = Calendar.current
        let americanWeekDay = calendar.component(.weekday, from: date)
        
        if americanWeekDay == 1 {return ResourceList.norwegianWeekDays[6]}
        return ResourceList.norwegianWeekDays[calendar.component(.weekday, from: date) - 2]
    }
    
    func getHistoryEntries() -> [HistoryEntry]{
        let allHistories = getAllHistories()
        
        var historyEntries = [HistoryEntry]()
        
        for history in allHistories {
            let label = getMonthYearLabelFrom(date: history.beginDate!)
            var historyWasAdded = false
            for historyEntry in historyEntries {
                if label == historyEntry.section {
                    historyEntry.histories?.append(history)
                    historyWasAdded = true
                    break
                }
            }
            if !historyWasAdded {
                let historyEntry = HistoryEntry()
                historyEntry.section = label
                historyEntry.histories = [History]()
                historyEntry.histories?.append(history)
                historyEntries.append(historyEntry)
            }
        }
        return historyEntries
    }
}
