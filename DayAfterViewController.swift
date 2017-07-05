//
//  DayAfterViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 05.07.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class DayAfterViewController: UIViewController {
    
    var titleValue:String?
    var imageValue:String?
    var textValue:String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        imageView.image = UIImage(named: imageValue!)
        titleLabel.text = titleValue
        contentTextView.text = textValue
    }
    
}
