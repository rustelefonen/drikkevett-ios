//
//  DrinkEpisodeViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 03.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class DrinkEpisodeViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: getCurrentStatus().name){
            addChildViewController(vc)
            view.addSubview(vc.view)
            didMove(toParentViewController: self)
        }
    }
    
    func getCurrentStatus() -> StatusNew {
        let startEndTimestampsList = StartEndTimestampsDao().getAll()
        if startEndTimestampsList.count <= 0 {return StatusNew.NOT_RUNNING}
        let startEndTimestamps = startEndTimestampsList.first
        
        if startEndTimestamps!.endStamp! < Date() {return StatusNew.DA_RUNNING}
        else {return StatusNew.RUNNING}
    }
}
