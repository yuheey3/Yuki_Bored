//
//  DatabaseHelper.swift
//  Yuki_Bored
//  Student# : 141082180
//  Created by Yuki Waka on 2021-04-20.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    
    //singleton instance
    private static var shared : DatabaseHelper?
    
    static func getInstance() -> DatabaseHelper{
        
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            //create a new singleton instance
            return DatabaseHelper(context: (UIApplication.shared.delegate as! AppDelegate)
                                    .persistentContainer.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "Bored"
    
    private init (context : NSManagedObjectContext){
        self.moc = context
    }
    //insert
    func insertActivity(newMyActivity: MyFavorite){
        
        do{
            //try insert new record
            let activityTobeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! Bored
            activityTobeAdded.activity = newMyActivity.activity
         
            activityTobeAdded.id = UUID()
        
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data inserted successfully")
            }
            
        }catch let error as NSError{
            print(#function,"Could not save the data \(error)")
        }
    }
    //search
    func searchActivity(activityID : UUID) -> Bored?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", activityID as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                return result.first as? Bored
            }
            
        }catch let error as NSError{
            print("Unable to search order \(error)")
        }
        
        return nil
    }
    
    //delete
    func deleteActivity(activityID : UUID){
        let searchResult = self.searchActivity(activityID: activityID)
        
        if(searchResult != nil){
        //matching record found
            do{
                self.moc.delete(searchResult!)
               // try self.moc.save()
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.saveContext()
                
                print(#function, "Activity deleted successfully")
            
               }catch let error as NSError{
                    print("Unable to delete activity \(error)")
           
            }
        }
    }
    
    
    //retrieve all activities
    func getAllActivity() -> [Bored]?{
        let fetchRequest = NSFetchRequest<Bored>(entityName: ENTITY_NAME)
       // fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false )]
        
        do{
            //execute the request
            let result = try self.moc.fetch(fetchRequest)
            
            print(#function, "Fetched data : \(result as [Bored])")
            
            //return the fetched objects after conversion to MyOrder objects
            return result as [Bored]
            
            
        }catch let error as NSError{
            print("Could not fetch data \(error) \(error.code)")
        }
        //no data retrieved
        return nil
    }
}
    

