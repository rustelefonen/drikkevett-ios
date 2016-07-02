//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Kommunikasjon med database/Core Data
    let moc = DataController().managedObjectContext
    
    // set Colors
    let setAppColors = AppColors()
    
    var titles = [String]()
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titles = ["Trening", "Drikkevettreglene", "Psyken" , "Utseende", "Sex", "RUStelefonen"]
        imageArray = [UIImage(named: "Dumbbell-100")!, UIImage(named: "Rules")!, UIImage(named: "Brain-100")!, UIImage(named: "Lips4")!, UIImage(named: "Sex")!, UIImage(named: "rustelefonenLOGO")!]
        
        // LOAD ARRAYS
        //titles = ["Trening", "Drikkevettreglene", "Psyken" , "Utseende", "Sex", "RUStelefonen"]
        //imageArray = [UIImage(named: "Dumbbell-100")!, UIImage(named: "Rules")!, UIImage(named: "Brain-100")!, UIImage(named: "Wink")!, UIImage(named: "Sex")!, UIImage(named: "rustelefonenLOGO")!]
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        self.navigationItem.title = "Informasjon"
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.collectionView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.collectionView.reloadData()
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // LOAD ARRAYS
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.imageView?.image = self.imageArray[indexPath.row]
        cell.titleLabel?.text = self.titles[indexPath.row]
        cell.titleLabel?.textColor = UIColor.whiteColor()
        cell.titleLabel?.highlightedTextColor = UIColor.lightGrayColor()
        cell.sizeToFit()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let vc = segue.destinationViewController as! InfoTableViewController
            
            vc.getTitlesFromColl = self.titles[indexPath.row]
            
        }
    }
}