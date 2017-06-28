//
//  MyScrollVC.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class myScrollVC :UIViewController {
    
    var image:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        imageView.image = image
    }
}
