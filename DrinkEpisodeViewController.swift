//
//  DrinkEpisodeViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class DrinkEpisodeViewController: UIViewController {
    
    @IBOutlet weak var trash: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        insertView()
    }
    
    func insertView() {
        for childViewController in childViewControllers {
            childViewController.removeFromParentViewController()
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: getCurrentStatus().name){
            if vc is PlanPartyViewController {
                (vc as! PlanPartyViewController).drinkEpisodeViewController = self
                title = "Planlegg kvelden"
                trash.isEnabled = true
            }
            else if vc is PartyViewController {
                (vc as! PartyViewController).drinkEpisodeViewController = self
                title = "Pågående kveld"
                trash.isEnabled = false
            }
            
            addChildViewController(vc)
            view.addSubview(vc.view)
            didMove(toParentViewController: self)
        }
    }
    
    private func getCurrentStatus() -> StatusNew {
        let startEndTimestampsList = StartEndTimestampsDao().getAll()
        if startEndTimestampsList.count > 0 && Date() < startEndTimestampsList.first!.endStamp! {
            return StatusNew.RUNNING
        }
        return StatusNew.NOT_RUNNING
    }
    
    @IBAction func clearUnits(_ sender: UIBarButtonItem) {
        print("i metoden")
        print(childViewControllers)
        if trash.isEnabled && childViewControllers.first is PlanPartyViewController {
            print("sletter")
            (childViewControllers.first as! PlanPartyViewController).resetUnits()
        }
    }
    
    
    func kek() {
        print("kek")
    }
}
