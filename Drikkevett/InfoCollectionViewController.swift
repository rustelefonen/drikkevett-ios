//
//  InfoCollectionViewController.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 22.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoCollectionViewController : UICollectionViewController {
    
    let infoCellId = "infoCell"
    var infoCategories:[InfoCategory]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.setBackground(view: view)
        fillInfos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoCategories.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellId, for: indexPath) as! InfoCategoryCell
        cell.title.text = infoCategories[indexPath.row].title
        cell.image.image = UIImage(named: infoCategories[indexPath.row].image!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 165, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if infoCategories[indexPath.row].title == "Veiledning" {
            performSegue(withIdentifier: "intoToGuidanceSegue", sender: self)
        }
        else if infoCategories[indexPath.row].title == "Kilder" {
            performSegue(withIdentifier: "infoToSourcesSegue", sender: self)
        }
        else {
            performSegue(withIdentifier: InfoCategoryTableViewController.segueId, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == InfoCategoryTableViewController.segueId {
            if segue.destination is InfoCategoryTableViewController {
                let indexPaths = collectionView!.indexPathsForSelectedItems
                let indexPath = indexPaths![0] as IndexPath
                
                let destinationVC = segue.destination as! InfoCategoryTableViewController
                destinationVC.infoCategory = infoCategories[indexPath.row]
            }
        }
    }
    
    func fillInfos() {
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
}
