//
//  Forecast.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 23/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) { //downloading max and min temp from weather API
        //
        if let temp = weatherDict["main"] as? Dictionary<String, AnyObject> { //following api json
            if let min = temp["temp_min"] as? Double {
                let kelvinToCelcius = (min - 273.15)
                self._lowTemp = String(format: "%.1f",kelvinToCelcius)
            }
            if let max = temp["temp_max"] as? Double {
                let kelvinToCelcius = (max - 273.15)
                self._highTemp = String(format: "%.1f",kelvinToCelcius)
            }
        }
        //
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        //
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date) //'Date' is from extension
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE" //monday, tue, wed, etc
            dateFormatter.timeStyle = .none //time not needed
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        //
    }
}

extension Date { //changing date to day of the week
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
