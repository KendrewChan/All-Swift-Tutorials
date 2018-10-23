//
//  ViewController.swift
//  testLearn
//
//  Created by Kendrew Chan on 26/10/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var salaries = [45, 10, 54, 20]
    
    for i in 0..< salaries.count {
        salaries[i] = salaries[i] + (salaries[i] * 0.10 )
        }
    
    
    
}

