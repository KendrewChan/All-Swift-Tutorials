 //
//  CurrentWeather.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 22/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import Foundation
import Alamofire

 class CurrentWeather { //obtaining data here 
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName //when _cityName changes, cityName changes along with it
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //long version of date (google it)
        dateFormatter.timeStyle = .none //no time shown
        
        let currentDate = dateFormatter.string(from: Date()) //format Date() with dateFormatter
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = ""
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Alamofire download
        Alamofire.request(current_Weather_URL).responseJSON { //getting the api using alamofire
            response in //every request has a response
            let result = response.result //every response has a result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                //find dictionary keys with the sample api doc on the website
                if let name = dict["name"] as? String { //find key called "name" within dictionary
                    self._cityName = name
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] { //array of dictionary with the Key being a String and the Value being AnyObject
                    if let main = weather[0]["main"] as? String { //first value in array and "main" key within the dictionary
                        //once again, check api sample
                        self._weatherType = main.capitalized
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToCelcius = (currentTemperature - 273.15)
                        self._currentTemp = String(format: "%.1f",kelvinToCelcius)
                    }
                }
                
            }
            completed() //name of function we set to tell when its done
        }
    }
    
 }
