//
//  CountryController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.07.2016.
//  Copyright © 2016 RUStelefonen. All rights reserved.
//

import UIKit

class CountyController: UITableViewController {
    
    var counties:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counties = ResourceList.counties
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = counties[indexPath.row]
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return counties.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = cell?.accessoryType == .Checkmark ? .None : .Checkmark
    }
}