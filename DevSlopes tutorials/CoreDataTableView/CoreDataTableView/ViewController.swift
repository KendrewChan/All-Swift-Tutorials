//
//  ViewController.swift
//  CoreDataTableView
//
//  Created by Kendrew Chan on 29/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { //link "Save" to textField
            [unowned self] action in
        
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
        }
        
        self.save(name: nameToSave)
        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        //Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //insert a new managed object into a managed object context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //create a new managed object and insert it into the managed object context
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        //With an NSManagedObject, set the name attribute using key-value coding
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        } //You commit your changes to 'person' and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert(append) the new managed object into the people array so it shows up when the table view reloads
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") //register tableviewcell with identifier of "Cell" using code instead of directly in the interface
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //pull up the appDelegate and grab a reference to its persistentContainer to get your hands on its NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //NSFetchRequest is the class responsible for fetching from Core Data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //Hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch . \(error), \(error.userInfo)")
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        //cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

