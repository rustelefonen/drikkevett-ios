//  MainDagenDerpaViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 12.02.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class MainDagenDerpaViewController: UIViewController {
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let behindUnderlineLabel2 = UILabel()
        behindUnderlineLabel2.text = "____________________________________________"
        behindUnderlineLabel2.textColor = UIColor.lightGray
        behindUnderlineLabel2.font = UIFont.systemFont(ofSize: 36)
        behindUnderlineLabel2.sizeToFit()
        behindUnderlineLabel2.center = CGPoint(x: 96, y: 100)
        view.addSubview(behindUnderlineLabel2)
        /**/
        
        viewOneBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        viewTwoBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "componentA")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let pageControll = UIPageControl.appearance()
        pageControll.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showViewOneBtn(_ sender: UIButton) {
        viewOneBtnOutlet.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        viewTwoBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                self.underlinedLabel.center = CGPoint(x: 83, y: 100)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                self.underlinedLabel.center = CGPoint(x: 80, y: 100)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                self.underlinedLabel.center = CGPoint(x: 96, y: 100)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                self.underlinedLabel.center = CGPoint(x: 100, y: 100)
            }
            }, completion: nil)
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "componentA")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    @IBAction func showViewTwoBtn(_ sender: UIButton) {
        viewTwoBtnOutlet.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        viewOneBtnOutlet.titleLabel?.font = setAppColors.buttonFonts(15)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            if UIScreen.main.bounds.size.height == 480 {
                // iPhone 4
                self.underlinedLabel.center = CGPoint(x: 250, y: 100)
            } else if UIScreen.main.bounds.size.height == 568 {
                // IPhone 5
                self.underlinedLabel.center = CGPoint(x: 240, y: 100)
            } else if UIScreen.main.bounds.size.width == 375 {
                // iPhone 6
                self.underlinedLabel.center = CGPoint(x: 279, y: 100)
            } else if UIScreen.main.bounds.size.width == 414 {
                // iPhone 6+
                self.underlinedLabel.center = CGPoint(x: 310, y: 100)
            }
            }, completion: nil)
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "componentB")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    // WITHOUT ANIMATIONS
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
    
        // TODO: Set the ending state of your constraints here
    
        UIView.animate(withDuration: 0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
            }, completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            })
    }
    
    func addSubview(_ subView:UIView, toView parentView: UIView){
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            print("iphone 4 - MainDagenDerpå")
            self.viewOneBtnOutlet.transform = self.view.transform.translatedBy(x: -10.0, y: 0.0)
            self.viewTwoBtnOutlet.transform = self.view.transform.translatedBy(x: -36.0, y: 0.0)
            createSwipeLabel(83, yValue: 100, lineLenght: "___________")
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            self.viewOneBtnOutlet.transform = self.view.transform.translatedBy(x: -10.0, y: 0.0)
            self.viewTwoBtnOutlet.transform = self.view.transform.translatedBy(x: -36.0, y: 0.0)
            createSwipeLabel(80, yValue: 100, lineLenght: "___________")
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            createSwipeLabel(96, yValue: 100, lineLenght: "_____________")
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            self.viewOneBtnOutlet.transform = self.view.transform.translatedBy(x: 12.0, y: 0.0)
            self.viewTwoBtnOutlet.transform = self.view.transform.translatedBy(x: 30.0, y: 0.0)
            createSwipeLabel(100, yValue: 100, lineLenght: "______________")
        }
    }
    
    func createSwipeLabel(_ xValue: Int, yValue: Int, lineLenght: String){
        underlinedLabel = UILabel()
        underlinedLabel.text = lineLenght
        underlinedLabel.textColor = setAppColors.textUnderHeadlinesColors()
        underlinedLabel.font = UIFont.systemFont(ofSize: 36)
        underlinedLabel.sizeToFit()
        underlinedLabel.center = CGPoint(x: xValue, y: yValue)
        view.addSubview(underlinedLabel)
    }
}
