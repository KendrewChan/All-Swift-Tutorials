//
//  ViewController.swift
//  testCoreData
//
//  Created by Kendrew Chan on 28/8/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) //refers to the "Users" entity from testCoreData.xcdatamodelid
            /*
        newUser.setValue("Kenny", forKey: "username") //sets these to the core data
        newUser.setValue("myPassword", forKey: "password")
        newUser.setValue(19, forKey: "age")
        
        do {
            try context.save() //try to save the newUser
            print("Value Saved") //no error in setting value
        } catch {
            print("error")
        }
        */
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users") //similar to array, setting up with "Users" from core data
        request.predicate = NSPredicate(format: "username = %@", "kirsten")
        // (format: "age < %@", "10") can also be used to find users less than 10 yrs old
        //predicate is to locate certain data with certain properties
        // %@ represents a string. name = something, where kirsten is that
        
        request.returnsObjectsAsFaults = false //to test structure of coredata, replaces results with faults
        
        do {
            let results = try context.fetch(request) //currently fetches all Users available, will learn how to fetch specific "Users" in the future
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let username = result.value(forKey: "username") as? String { //casts the NSMangaedObject as a String
                   
                        /* context.delete(result)
                        do {
                            try context.save()
                        }   catch {
                            print("Delete failed")
                        }
                    */
                    }
                }
            } else {
                print("No results")
            }
        } catch {
            print("Couldn't fetch results")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

