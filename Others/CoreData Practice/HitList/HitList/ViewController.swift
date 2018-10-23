//
//  ViewController.swift
//  HitList
//
//  Created by Kendrew Chan on 28/1/18.
//  Copyright © 2018 KCStudios. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var names: [NSManagedObject] = [] //empty array for names, same for titles?
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(name: nameToSave) //save the "names"
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        guard let ad = UIApplication.shared.delegate as? AppDelegate //guard statements are just boolean ver. of if let statements
            else {
            return
        }
        
        //1. Insert a new managed object into a managed object context
        //2. “commit” the changes in your managed object context to save it to disk
        //The default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate
        let context = ad.persistentContainer.viewContext
        
        //You create a new managed object and insert it into the managed object context. You can do this in one step with NSManagedObject’s static method: entity(forEntityName:in:)
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
       
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        //with the NSManagedObject from 'person', spell the KVC key exactly as in the datamodel
        person.setValue(name, forKeyPath: "name")
        
        //commit changes and save to disk by calling save on the managed object context
        //Note: save can throw an error, which is why you call it using the try keyword within a do-catch block
        do {
            try context.save()
            names.append(person) //insert new object
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
        }
        //Some of the code here, such as getting the managed object context and entity, could be done just once in your own init() or viewDidLoad() then reused later. For simplicity, you’re doing it all in the same method.
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") //instead of directly adding in user interface
    }
    
    //viewWillAppear used to fetch data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        //anything related to core data needs a managed object context first
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //NSFetchRequest is the class responsible for fetching from Core Data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request
        do {
            names = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

