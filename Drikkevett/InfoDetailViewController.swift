//
//  InfoDetailViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 19.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {
    
    static let segueId = "detailSegue"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var info:Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppColors.setBackground(view: view)
        
        navigationItem.title = info?.title
        textView.text = info?.text
        imageView.image = UIImage(named: (info?.image)!)
    }
}
