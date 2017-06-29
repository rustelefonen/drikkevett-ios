//
//  BackButton.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 22.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class BackButton {
    class func setTitle(title:String?, navigationController:UINavigationController) {
        let backButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationController.navigationBar.topItem!.backBarButtonItem = backButton
    }
}
