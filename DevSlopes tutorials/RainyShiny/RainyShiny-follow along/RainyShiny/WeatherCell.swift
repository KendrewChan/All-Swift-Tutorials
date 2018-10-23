//
//  WeatherCell.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 24/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell { //NotesCell

    @IBOutlet weak var weatherIcon: UIImageView! //add Notes IBOutlets here
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    func configureCell(forecast: Forecast) { //add func to configure notes
        minTemp.text = "\(forecast.lowTemp)°"
        maxTemp.text = "\(forecast.highTemp)°"
        weatherType.text = forecast.weatherType
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayLabel.text = forecast.date
    }

}
