//  AppColors.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 04.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import Foundation
import UIKit

class AppColors {
    
    func roundedCorners() -> Bool{ return false }
    
    func mainBackgroundColor() -> UIColor {
        // BAKGRUNNSFARGEN PÅ ALLE VIEWS (255 - 255 -255)
        let backgroundColor = UIColor(patternImage: UIImage(named: "black_back_1")!)
        //let backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        return backgroundColor
    }
    
    func barChartBackgroundColor() -> UIColor {
        // BAKGRUNNSFARGE FOR BAR CHART (255 - 255 - 255)
        let barChartBackgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        
        return barChartBackgroundColor
    }
    
    func lineChartBackgroundColor() -> UIColor {
        // BAKGRUNNSFARGE FOR LINE CHART (255 - 255 - 255)
        let lineChartBackgroundColor = UIColor(red: 199/255.0, green: 221/255.0, blue: 226/255.0, alpha: 0.0)
        
        return lineChartBackgroundColor
    }
    
    func setBarsColor() -> UIColor { // (179 - 35 - 32)
        return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.6)
    }
    
    func descriptTextColor() -> UIColor {
        return UIColor.darkGray
    }
    
    func setLineColor() -> UIColor {
        //(179 - 35 - 34)
        return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.6)
    }
    
    func setLineSircleColor() -> UIColor {
        return UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 0.6)
    }
    
    func setTitleColorTextOnCircles() -> UIColor {
        return UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 0.6)
    }
    
    func updateFeedBack(_ distance: Double) -> UIColor{
        var color = UIColor()
        
        if(distance < 0.1){
            // MØRKEGRØNN
            color = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 0.7)
        }
        if(distance < 0.2 && distance >= 0.1){
            // GRØNN
            color = UIColor(red: 0/255.0, green: 225/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.3 && distance >= 0.2){
            // LYSE GRØNN
            color = UIColor(red: 0/255.0, green: 200/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.4 && distance >= 0.3){
            // LYS ORANSJE
            color = UIColor(red: 200/255.0, green: 80/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.5 && distance >= 0.4){
            // ORANSJE
            color = UIColor(red: 255/255.0, green: 70/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.6 && distance >= 0.5){
            // MØRK ORANSJE
            color = UIColor(red: 255/255.0, green: 60/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.7 && distance >= 0.6){
            // LYSRØD
            color = UIColor(red: 245/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.8 && distance >= 0.7){
            // RØD
            color = UIColor(red: 240/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 0.9 && distance >= 0.8){
            // MØRK RØD
            color = UIColor(red: 245/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance < 1.0 && distance >= 0.9){
            // BEKKRØD
            color = UIColor(red: 250/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        if(distance >= 1.0){
            // BLODRØD
            color = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        return color
    }
    
    func buttonColors(){ // (179 - 35 - 34)
        let buttonsColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        UIButton.appearance().tintColor = buttonsColor
    }
    
    func buttonFonts(_ fontSize: CGFloat) -> UIFont{
         return UIFont(name: "HelveticaNeue-Light", size: fontSize)!
    }
    
    func drawRoundedBordersButtons(_ button: UIButton, trueFalse: Bool){
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func swipeInfoStatsFontsChosen(_ fontSize: CGFloat) -> UIFont{
        return UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
    }
    
    func swipeInfoStatsFontsNotChosen(_ fontSize: CGFloat) -> UIFont{
        return UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)!
    }
    
    func headlineFont(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }
    func behindLineColor() -> UIColor{
        return UIColor(red: 200/255.0, green: 135/255.0, blue: 235/255.0, alpha: 1.0)
    }
    
    func textHeadlinesColors() -> UIColor{ // (179 - 35 - 34)
        // FARGE PÅ TEKST HEADLINES
        let headlines = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return headlines
    }
    
    func textHeadlinesFonts(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST HEADLINES
        var headlineFont = UIFont()
        headlineFont = UIFont(name: "HelveticaNeue-Light", size: fontSize)!
        
        return headlineFont
    }
    
    func welcomeTextHeadlinesFonts(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST HEADLINES
        var headlineFont = UIFont()
        headlineFont = UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)!
        
        return headlineFont
    }
    
    func titleFont(_ fontSize: CGFloat) -> UIFont{
        var font = UIFont()
        font = UIFont(name: "HelveticaNeue-Light", size: fontSize)!
        
        return font
    }
    
    func testConstraintFont() -> UIFont{
        var font = UIFont()
        
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            font = UIFont(name: "HelveticaNeue-Light", size: 30)!
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            font = UIFont(name: "HelveticaNeue-Light", size: 40)!
        }
        return font
    }
    
    func textUnderHeadlinesColors() -> UIColor{
        // FARGE PÅ TEKST HEADLINES
        let underHeadlines = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return underHeadlines
    }
    
    func textUnderHeadlinesFonts(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let underHeadlineFont = UIFont(name: "HelveticaNeue-Light", size: fontSize)
        return underHeadlineFont!
    }

    func textViewsColors() -> UIColor{
        // FARGE PÅ TEKST HEADLINES
        let textViewColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return textViewColor
    }
    
    func textViewsFonts() -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let textViewFont = UIFont(name: "HelveticaNeue-Light", size: 17)
        return textViewFont!
    }
    
    func textViewFont(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let textViewFont = UIFont(name: "HelveticaNeue-Light", size: fontSize)
        return textViewFont!
    }
    
    func promilleLabelColors() -> UIColor{
        // FARGE PÅ TEKST HEADLINES (179 - 35 - 34)
        let textViewColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return textViewColor
    }
    
    func promilleLabelFonts() -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let textViewFont = UIFont(name: "HelveticaNeue-Thin", size: 65)
        return textViewFont!
    }
    
    func datePickerTextColor() -> UIColor {
        // FARGE PÅ TEKST HEADLINES
        let textDatePicker = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return textDatePicker
    }
    
    func setTextQuoteFont(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let textViewFont = UIFont(name: "HelveticaNeue-MediumItalic", size: fontSize)
        return textViewFont!
    }
    func textQuoteColors() -> UIColor{
        // FARGE PÅ TEKST HEADLINES (179 - 35 - 34)
        let textViewColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return textViewColor
    }
    
    func tabBarColors(){
        // SETT HIGHLIGHTED TAB-BAR
        let colorUITabBar = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // SETT BAKGRUNNSFARGE TAB-BAR
        let tabBarMenuColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        UITabBar.appearance().tintColor = colorUITabBar
        UITabBar.appearance().barTintColor = tabBarMenuColor
        //UITabBar.appearance().backgroundColor = UIColor.blackColor()
        //UITabBar.appearance().backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        //UITabBarItem.appearance()
        // set color of unselected text
        /*[[UITabBarItem, appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:unselectedColor, NSForegroundColorAttributeName, nil]
        forState:UIControlStateNormal]*/
    }
    
    func navigationBarColors(){
        // SETT BAKGRUNNSFARGE NAV-BAR (TRADISJONELL RØD 179 - 35 - 34)
        let backgroundscolorNavBar = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        // SETT FARGE PÅ ELEMENTER ( SOM TILBAKE FARGE ) (( 255 - 255 - 255))
        let navBarElements = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        // SETT FARGE PÅ TEKST ((200 - 200 - 200))
        let textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        UINavigationBar.appearance().barTintColor = backgroundscolorNavBar
        UINavigationBar.appearance().tintColor = navBarElements
        
        let textAttributes = [NSForegroundColorAttributeName: textColor]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        // Sets background to a blank/empty image
        //UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        //UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        //UINavigationBar.appearance().backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0)// 0.0
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        //UINavigationBar.appearance().translucent = true
        
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        //UIStatus
    }
    
    func cellSidesColors() -> UIColor{
        // FARGE CELL SIDER
        let sidesColors = UIColor(red: 205/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return sidesColors
    }
    func cellBackgroundColors() -> UIColor{
        // FARGE CELL BAKGRUNN
        let cellBackColor = UIColor(red: 205/255.0, green: 6/255.0, blue: 255/255.0, alpha: 1.0)
        return cellBackColor
    }
    
    func cellTextColors() -> UIColor{
        // FARGE PÅ TEKST HEADLINES
        let textColor = UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 1.0)
        return textColor
    }
    
    func cellTextFonts(_ fontSize: CGFloat) -> UIFont{
        // FONT OG SIZE PÅ TEKST UNDERHEADLINES
        let cellFont = UIFont(name: "HelveticaNeue-Light", size: fontSize)
        return cellFont!
    }
    
    func cellTextColorsPressed() -> UIColor{
        // FARGE TEKST CELL PRESSED
        let cellPressedTextColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        return cellPressedTextColor
    }
    func cellBackgroundPressed() -> UIColor{
        // FARGE CELL BAKGRUNN PRESSED
        let cellPressedBackColor = UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 1.0)
        return cellPressedBackColor
    }
    
    func pageController(){
        let pageControl = UIPageControl.appearance()
        // FARGE DER MAN IKKE ER
        let colorNonPage = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
        // FARGE DER MAN ER (179 - 35 - 34)
        let colorOnPage = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        // BAKGRUNNSFARGE 
        let background = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)
        
        pageControl.pageIndicatorTintColor = colorNonPage
        pageControl.currentPageIndicatorTintColor = colorOnPage
        pageControl.backgroundColor = background
    }
    
    func steppColor(){
        // STEPPER
        UIStepper.appearance().tintColor = UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 1.0)
    }
    
    func segmentContColor(){
        // SEGMENT CONTROLLERS
        UISegmentedControl.appearance().tintColor = UIColor(red: 179/255.0, green: 35/255.0, blue: 34/255.0, alpha: 1.0)
    }
    
    static let graphRed = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
    static let graphGreen = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0)
    
    static func setBackground(view:UIView) {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "black_back_1")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.sendSubview(toBack: blurEffectView)
    }
}
