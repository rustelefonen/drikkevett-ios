//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionCell = "collectionCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        navigationItem.title = "Informasjon"
        
        let setAppColors = AppColors()
        view.backgroundColor = setAppColors.mainBackgroundColor()
        collectionView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        collectionView.reloadData()
        collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.translatesAutoresizingMaskIntoConstraints = false // var false
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ResourceList.infoTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! CollectionViewCell
        
        let row = (indexPath as NSIndexPath).row
        cell.imageView?.image = UIImage(named: ResourceList.infoImages[row])
        cell.titleLabel?.text = ResourceList.infoTitles[row]
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
            let indexPaths = collectionView!.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            
            let vc = segue.destination as! InfoTableViewController
            
            vc.getTitlesFromColl = ResourceList.infoTitles[(indexPath as NSIndexPath).row]
        }
    }
}
