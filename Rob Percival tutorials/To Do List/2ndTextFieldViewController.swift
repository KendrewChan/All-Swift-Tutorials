//
//  SecondViewController.swift
//  To Do List
//
//  Created by Rob Percival on 17/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var itemTextField: UITextField!
    
    
    @IBAction func add(_ sender: AnyObject) {
        
        let itemsObject = UserDefaults.standard.object(forKey: "items") //store data
        
        var items:[String] //empty array
        
        if let tempItems = itemsObject as? [String] { //to check whether itemsObject can be turned into a String
            
            items = tempItems //resets back to its orginal var to reduce confusion
            
            items.append(itemTextField.text!)//appends to the empty array above
            
            print(items) //just to check for errors, aka. its useless for the program
            
        } else {
            
            items = [itemTextField.text!] //to return text into textfield when error received?
            
        }
        
        UserDefaults.standard.set(items, forKey: "items")
        
        itemTextField.text = ""
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true) //to end keyboard if finger touches outside of keyboard
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() //for keyboard to end when return key is touched
        
        return true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

