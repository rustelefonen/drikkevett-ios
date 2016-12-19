//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titles = ["Trening", "Drikkevettreglene", "Psyken" , "Utseende", "Sex", "RUStelefonen"]
    var imageArray = [UIImage(named: "Dumbbell-100")!, UIImage(named: "Rules")!, UIImage(named: "Brain-100")!, UIImage(named: "Lips4")!, UIImage(named: "Sex")!, UIImage(named: "rustelefonenLOGO")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        self.navigationItem.title = "Informasjon"
        
        let setAppColors = AppColors()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.collectionView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.collectionView.reloadData()
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.imageView?.image = self.imageArray[(indexPath as NSIndexPath).row]
        cell.titleLabel?.text = self.titles[(indexPath as NSIndexPath).row]
        cell.titleLabel?.textColor = UIColor.white
        cell.titleLabel?.highlightedTextColor = UIColor.lightGray
        cell.sizeToFit()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            
            let vc = segue.destination as! InfoTableViewController
            
            vc.getTitlesFromColl = self.titles[(indexPath as NSIndexPath).row]
            
        }
    }
}
