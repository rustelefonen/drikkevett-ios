//
//  InfoCategoryTableViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 22.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoCategoryTableViewController : UITableViewController {
    
    static let segueId = "showImage"
    
    var infoCategory:InfoCategory?
    let cellId = "infoCell"
    let drinkSmartTitle = "Drikkevettreglene"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tableViewBackgroundView = tableView.backgroundView {
            AppColors.setBackground(view: tableViewBackgroundView)
        }
        
        navigationItem.title = infoCategory?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoCategory!.infos!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InfoCell
        cell.title.text = infoCategory?.infos?[indexPath.row].title
        
        if infoCategory?.title == drinkSmartTitle {
            cell.title.font = cell.title.font.withSize(14.0)
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if infoCategory?.title != drinkSmartTitle {performSegue(withIdentifier: InfoDetailViewController.segueId, sender: self)}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == InfoDetailViewController.segueId {
            if segue.destination is InfoDetailViewController {
                let destinationVC = segue.destination as! InfoDetailViewController
                destinationVC.info = infoCategory?.infos?[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
