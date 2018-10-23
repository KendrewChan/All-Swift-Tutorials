//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Rob Percival on 20/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    
    @IBAction func getWeather(_ sender: AnyObject) {
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") { //since website shows Los Angeles as los-angeles, thus when someone types "los angeles" into textfield, automically converts to text required for website
        
        let request = NSMutableURLRequest(url: url) //Mutable means able to change form > E.g. changing cities
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { //provides an API for downloading content, and gives app the ability to perform background downloads when your app is not running
            data, response, error in
            
            var message = ""
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let unwrappedData = data {
                    
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) //utf8 means it uses 8-bit blocks to represent a character
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">" //start of weather forecast from source code
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 { //more than 1 word count in message separated by stringSeparator
                            
                            stringSeparator = "</span>" //ending of weather forecast from source code
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°") //changes "&deg;" from source code into degrees symbol in phone app
                                
                                print(message)
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
            if message == "" { //for when nothing is typed
                
                message = "The weather there couldn't be found. Please try again."
                
            }
            
            DispatchQueue.main.sync(execute: {
                
                self.resultLabel.text = message //converts message var into the resultLabel for the app
                
            })
            
        }
        
        task.resume()
            
        } else { //for when a string/city cannot be located from website
            
            resultLabel.text = "The weather there couldn't be found. Please try again."
            
        }
        
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

