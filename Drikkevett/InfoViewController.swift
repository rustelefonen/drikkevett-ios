//  FirstViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 27.01.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.

import UIKit
import CoreData

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var infoCategories:[InfoCategory]!
    let collectionCell = "collectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillMyInfos()
        
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
    
    func fillMyInfos() {
        infoCategories = [InfoCategory]()
        for i in 0..<ResourceList.infoTitles.count {
            let infoCategory = InfoCategory()
            infoCategory.title = ResourceList.infoTitles[i]
            infoCategory.image = ResourceList.infoImages[i]
            infoCategory.infos = [Info]()
            infoCategories.append(infoCategory)
        }
        
        for i in 0..<ResourceList.exerciseTitles.count {
            let info = Info()
            info.title = ResourceList.exerciseTitles[i]
            info.image = ResourceList.exerciseImages[i]
            info.text = ResourceList.exerciseTexts[i]
            infoCategories[0].infos?.append(info)
        }
        
        for i in 0..<ResourceList.drinkSmartRulesTitles.count {
            let info = Info()
            info.title = ResourceList.drinkSmartRulesTitles[i]
            infoCategories[1].infos?.append(info)
        }
        
        for i in 0..<ResourceList.psycheTitles.count {
            let info = Info()
            info.title = ResourceList.psycheTitles[i]
            info.image = ResourceList.psycheImages[i]
            info.text = ResourceList.psycheTexts[i]
            infoCategories[2].infos?.append(info)
        }
        
        for i in 0..<ResourceList.apperanceTitles.count {
            let info = Info()
            info.title = ResourceList.apperanceTitles[i]
            info.image = ResourceList.apperanceImages[i]
            info.text = ResourceList.apperanceTexts[i]
            infoCategories[3].infos?.append(info)
        }
        
        for i in 0..<ResourceList.sexTitles.count {
            let info = Info()
            info.title = ResourceList.sexTitles[i]
            info.image = ResourceList.sexImages[i]
            info.text = ResourceList.sexTexts[i]
            infoCategories[4].infos?.append(info)
        }
        
        for i in 0..<ResourceList.rustelefonenTitles.count {
            let info = Info()
            info.title = ResourceList.rustelefonenTitles[i]
            info.image = ResourceList.rustelefonenImages[i]
            info.text = ResourceList.rustelefonenTexts[i]
            infoCategories[5].infos?.append(info)
        }
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
        return infoCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! CollectionViewCell
        
        let row = indexPath.row
        cell.imageView?.image = UIImage(named: infoCategories[row].image!)
        cell.titleLabel?.text = infoCategories[row].title
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
            if segue.destination is InfoCategoryTableViewController {
                let indexPaths = collectionView!.indexPathsForSelectedItems
                let indexPath = indexPaths![0] as IndexPath
                
                let destinationVC = segue.destination as! InfoCategoryTableViewController
                destinationVC.infoCategory = infoCategories[indexPath.row]
            }
        }
    }
}
