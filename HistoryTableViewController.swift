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
    
    var historyEntries = [HistoryEntry]()
    let historyDao = HistoryDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHistoryEntries()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyEntries[section].histories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return historyEntries.count > 0 ? historyEntries[section].section : "Ingen kvelder"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return historyEntries.count > 0 ? historyEntries.count : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Slett"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyEntry = historyEntries[indexPath.section].histories![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        
        cell.dateLabel.text = "\(getDayFrom(date: (historyEntry.dato)!))"
        cell.highestBacLabel.text = "Høyeste promille " + String(describing: Double(historyEntry.hoyestePromille!).roundTo(places: 2))
        cell.costLabel.text = String(describing: getNorwegianDayFrom(date: (historyEntry.dato!))) + " brukte du " + String(describing: historyEntry.forbruk!) + ",-"
        
        let goal = Double(UserDataDao().fetchUserData()!.goalPromille!)
        let red = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let green = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
        
        if Double(historyEntry.hoyestePromille!) > goal {
            cell.highestBacLabel.textColor = red
            cell.circleView.ringColor = red
        }
        else {
            cell.highestBacLabel.textColor = green
            cell.circleView.ringColor = green
        }
        
        return cell
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
                    destination.history = historyEntries[indexPath.section].histories?[indexPath.row]
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
    
    func initHistoryEntries() {
        let allHistories = historyDao.getAllOrderedByDate()
        
        for history in allHistories {
            let label = getMonthYearLabelFrom(date: history.dato!)
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
                historyEntry.histories = [Historikk]()
                historyEntry.histories?.append(history)
                historyEntries.append(historyEntry)
            }
        }
    }
}
