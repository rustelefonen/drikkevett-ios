//
//  UIViewExtension.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.07.2016.
//  Copyright © 2016 RUStelefonen. All rights reserved.
//

import UIKit

extension UIView {
    func endEditingInFirstResponder() -> UIView?{
        if isFirstResponder(){
            endEditing(true)
            return self
        }
        
        for subview in subviews {
            if subview.isFirstResponder() {
                subview.endEditing(true)
                return subview
            }
            subview.endEditingInFirstResponder()
        }
        return nil
    }
}
