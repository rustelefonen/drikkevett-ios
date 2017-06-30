//
//  GuidanceContentViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 29.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class GuidanceContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var titleValue:String?
    var imageValue:String?
    var textValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        titleLabel.text = titleValue
        imageView.image = UIImage(named: imageValue!)
        textView.text = textValue
        
    }
}
