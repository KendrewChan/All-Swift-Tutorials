//
//  FirstViewController.swift
//  To Do List
//
//  Created by Rob Percival on 17/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var items: [String] = [] //forms an empty array for reminders to be appended later on

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count //number of rows = number of items
        
    }   //generally follow this format for first part of all tableView related apps
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell") //"Cell" is identified from storyboard area where you added it
        
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell //cell is where the items are displayed
        
    }   //generally follow this format for first part of all tableView related apps
    
    /////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "items") //storing data of "items" reminder using a var
        
        
        if let tempItems = itemsObject as? [String] { //in cases where reminders are numbers, to convert into string using a var since its not possible to directly set it as a String
            
            items = tempItems //resets all the above var back to its original form
            
        }
        
        table.reloadData() //refresh table to load reminder
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            items.remove(at: indexPath.row)
            
            table.reloadData()
            
            UserDefaults.standard.set(items, forKey: "items")
            
        }
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

