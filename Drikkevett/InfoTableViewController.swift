//
//  InfoTableViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 19.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoTableViewController /*: UIViewController, UITableViewDataSource, UITableViewDelegate*/ {
    /*
    @IBOutlet weak var tableView: UITableView!
    
    let drinkSmartTitle = "Drikkevettreglene"
    let cellId = "infoCell"
    var infoCategory:InfoCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        tableView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        
        navigationItem.title = infoCategory?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoCategory!.infos!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setAppColors = AppColors()
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        cell.name.text = infoCategory?.infos?[indexPath.row].title
        cell.name.textColor = setAppColors.textHeadlinesColors()
        cell.name.font = setAppColors.textHeadlinesFonts(25)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = setAppColors.cellTextColors()
        cell.textLabel?.font = setAppColors.cellTextFonts(35)
        cell.textLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        cell.selectedBackgroundView = backgroundView
        
        if(infoCategory?.title == drinkSmartTitle){
            cell.name.textColor = setAppColors.textUnderHeadlinesColors()
            cell.name.font = setAppColors.textHeadlinesFonts(14)
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if infoCategory?.title != drinkSmartTitle {performSegue(withIdentifier: InfoDetailViewController.segueId, sender: self)}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == InfoDetailViewController.segueId {
            if segue.destination is InfoDetailViewController {
                let destinationVC = segue.destination as! InfoDetailViewController
                
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                destinationVC.info = infoCategory?.infos?[indexPath.row]
            }
        }
    }*/
}
