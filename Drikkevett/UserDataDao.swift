//
//  UserDataDao.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 02.02.2017.
//
//

import CoreData
import UIKit

class UserDataDao: CoreDataDao {
    
    //Fields
    let entityName:String
    
    //Constructor
    required init() {
        entityName = String(describing: UserData.self)
        super.init()
    }
    
    //Operations
    func fetchUserData() -> UserData? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        return (try! managedObjectContext.fetch(fetchRequest) as! [UserData]).first
    }
    
    func createNewUserData() -> UserData {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! UserData
    }
    
    func createNewUserData(age:NSNumber?, costsBeer:NSNumber?, costsDrink:NSNumber?, costsShot:NSNumber?, costsWine:NSNumber?, gender:NSNumber?, height:String?, weight:NSNumber?, goalPromille:NSNumber?, goalDate:Date?) -> UserData{
        let userData = createNewUserData()
        userData.age = age
        userData.costsBeer = costsBeer
        userData.costsDrink = costsDrink
        userData.costsShot = costsShot
        userData.costsWine = costsWine
        userData.gender = gender
        userData.height = height
        userData.weight = weight
        userData.goalPromille = goalPromille
        userData.goalDate = goalDate
        return userData
    }
    
    func fetchGoalBac() -> Double{
        let userData = fetchUserData()
        if userData == nil {return 0.0}
        return userData!.goalPromille as! Double
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userDatas = (try? managedObjectContext.fetch(fetchRequest)) as? [UserData] ?? []
        
        deleteObjects(userDatas)
    }
}
