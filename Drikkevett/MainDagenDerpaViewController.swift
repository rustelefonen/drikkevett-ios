//  MainDagenDerpaViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 12.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

/*
OVERSIKT:
CMD - F = (Over-Overskriften du vil finne)

0001 - ATTRIBUTTER
0002 - FONTS AND COLORS
0003 - SJEKK PROMILLE
0004 - ADD UNITS DAY AFTER
0005 - INITATE METHODS
0006 - DEFAULT VERDIER
0007 - CORE DATA - SAMHANDLING MED DATABASEN
*/

import UIKit
import CoreData

class MainDagenDerpaViewController: UIViewController {
    ////////////////////////////////////////////////////////////////////////
    //                        ATTRIBUTTER (0001)                          //
    ////////////////////////////////////////////////////////////////////////
    
    ///////// TIL NY MENY MÅTE
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewOneBtnOutlet: UIButton!
    @IBOutlet weak var viewTwoBtnOutlet: UIButton!
    @IBOutlet weak var backgroundBehindBtns: UIView!
    
    weak var currentViewController: UIViewController?
    var underlinedLabel: UILabel!
    
    let setAppColors = AppColors()
    
    override func viewDidLoad() {
        backgroundBehindBtns.backgroundColor = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 0.9)

        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        //UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let behindUnderlineLabel2 = UILabel()
        behindUnderlineLabel2.text = "____________________________________________"
        behindUnderlineLabel2.textColor = UIColor.lightGrayColor()
        behindUnderlineLabel2.font = UIFont.systemFontOfSize(36)
        behindUnderlineLabel2.sizeToFit()
        behindUnderlineLabel2.center = CGPoint(x: 96, y: 100)
        view.addSubview(behindUnderlineLabel2)
        /**/
        
        viewOneBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        viewTwoBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("componentA")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        
        setConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showViewOneBtn(sender: UIButton) {
        viewOneBtnOutlet.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        viewTwoBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                self.underlinedLabel.center = CGPoint(x: 83, y: 100)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                self.underlinedLabel.center = CGPoint(x: 80, y: 100)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                self.underlinedLabel.center = CGPoint(x: 96, y: 100)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                self.underlinedLabel.center = CGPoint(x: 100, y: 100)
            }
            }, completion: nil)
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("componentA")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    @IBAction func showViewTwoBtn(sender: UIButton) {
        viewTwoBtnOutlet.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        viewOneBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            if UIScreen.mainScreen().bounds.size.height == 480 {
                // iPhone 4
                self.underlinedLabel.center = CGPoint(x: 250, y: 100)
            } else if UIScreen.mainScreen().bounds.size.height == 568 {
                // IPhone 5
                self.underlinedLabel.center = CGPoint(x: 240, y: 100)
            } else if UIScreen.mainScreen().bounds.size.width == 375 {
                // iPhone 6
                self.underlinedLabel.center = CGPoint(x: 279, y: 100)
            } else if UIScreen.mainScreen().bounds.size.width == 414 {
                // iPhone 6+
                self.underlinedLabel.center = CGPoint(x: 310, y: 100)
            }
            }, completion: nil)
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("componentB")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    // WITHOUT ANIMATIONS
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
    
        // TODO: Set the ending state of your constraints here
    
        UIView.animateWithDuration(0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
            }, completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
            })
    }
    
    // WITH ANIMATION
    /*func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }*/
    
    func addSubview(subView:UIView, toView parentView: UIView){
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            print("iphone 4 - MainDagenDerpå")
            self.viewOneBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, 0.0)
            self.viewTwoBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -36.0, 0.0)
            createSwipeLabel(83, yValue: 100, lineLenght: "___________")
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.viewOneBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -10.0, 0.0)
            self.viewTwoBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, -36.0, 0.0)
            createSwipeLabel(80, yValue: 100, lineLenght: "___________")
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            createSwipeLabel(96, yValue: 100, lineLenght: "_____________")
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.viewOneBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 12.0, 0.0)
            self.viewTwoBtnOutlet.transform = CGAffineTransformTranslate(self.view.transform, 30.0, 0.0)
            createSwipeLabel(100, yValue: 100, lineLenght: "______________")
        }
    }
    
    func createSwipeLabel(xValue: Int, yValue: Int, lineLenght: String){
        underlinedLabel = UILabel()
        underlinedLabel.text = lineLenght
        underlinedLabel.textColor = setAppColors.textUnderHeadlinesColors()
        underlinedLabel.font = UIFont.systemFontOfSize(36)
        underlinedLabel.sizeToFit()
        underlinedLabel.center = CGPoint(x: xValue, y: yValue)
        view.addSubview(underlinedLabel)
    }
}