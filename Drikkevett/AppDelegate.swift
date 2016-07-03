//  AppDelegate.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let moc = DataController().managedObjectContext
    
    var first = FirstViewController()
    var dayAfter = GlemteEnheterViewController()
    var setAppColors = AppColors()
    var pageControll = UIPageControl()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setAppColors.tabBarColors()

        setAppColors.buttonColors()

        setAppColors.navigationBarColors()
        
        setAppColors.pageController()
        
        setAppColors.steppColor()
        
        setAppColors.segmentContColor()
        
        first.testingCheckPromilleActive()
        dayAfter.updatePromilleAppDelegate()
    
        //first.startTimerTesting()
        //dayAfter.startDagenDerpaTimerAppDelegate()
        
        // Change the status bar's appearance
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barStyle = .Black
        
        // NOTIFICATION
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("appdidbecomeactive")
        first.testingCheckPromilleActive()
        dayAfter.updatePromilleAppDelegate()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        seedTimeStamp()
    }

    func getTimeStamp() -> NSDate {
        let date = NSDate()
        return date
    }
    
    func seedTimeStamp() {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("TerminatedTimeStamp", inManagedObjectContext: moc) as! TerminatedTimeStamp
        
        entity.setValue(getTimeStamp(), forKey: "terminatedTimeStamp")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save timestamp: \(error)")
        }
    }
}
