//
//  FormCell.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.07.2016.
//  Copyright © 2016 RUStelefonen. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {
    var cellIdentifier:String!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var staticTextLabel: UILabel!
    @IBOutlet weak var textContent: UILabel!
}

