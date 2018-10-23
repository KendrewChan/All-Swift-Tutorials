//
//  ViewController.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 20/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //tableviewDelegate tells the tableview how to handle data
    //tableviewdatasource is the data
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather! //creates a generic class of CurrentWeather from its swift file
    var forecast: Forecast!
    var forecasts = [Forecast]() //create array for notes tableView also here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self //we want the tableview to be its own delegate
        tableView.dataSource = self //to find its data
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //authorise location gps only when app is active and in use
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather() //instantiate empty currentWeather class
        //forecast = Forecast() //instantiate empty forecast class
    }
    
    override func viewDidAppear(_ animated: Bool) { //runs code before viewDidLoad
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() { //authorise location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { //if authorization access allowed
                currentLocation = locationManager.location //save current location into the currentLocation var
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude //save the data into the singleton Latitude within Location.swift
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude //save the data into the singleton Longitude within Location.swift
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI() //self because it is within a closure
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization() //request authorization for location if user has not allowed it yet. (in the form of a pop-up)
            //add to infoPList for msg to appear in this pop-up
            locationAuthStatus() //rerun the code to find location once authorized, otherwise nothing would change even when user authorises the app
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(forecast_URL).responseJSON { response in //every request has a response
            let result = response.result //every response has a result
            
            if let dict = result.value as? Dictionary<String, AnyObject> { //check json formatter for api doc, root of the whole api is a dictionary
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] { //dictionary within an array
                    for i in list {
                        let forecast = Forecast(weatherDict: i) //download data from 'weatherDict' in Forecast.swift into the Forecast[] array
                        self.forecasts.append(forecast) //appends the various data into the array
                        print(i)
                    }
                    self.tableView.reloadData() //reload data to make it appear after its downloaded
                }
            }
            completed() //completed response
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //tells tableview we want 1 section
    } //default value is 1 already, so technically no need this function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count //returns number of cells according to array count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell { //looks for identifier with 'weatherCell' and recycles the cell using the same data while changing text/etc
           let forecast = forecasts[indexPath.row] //to tell which forecast to pass in and where
            cell.configureCell(forecast: forecast) //configureCell is from WeatherCell.swift
            return cell
        } else {
            return WeatherCell()
        }
    } //Apple Documentation: Asks the data source for a cell to insert in a particular location of the table view
    
    func updateMainUI() { 
        dateLabel.text = currentWeather.date
        tempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        weatherImage.image = UIImage(named: currentWeather.weatherType) //string required = name of image file, thus can directly update to cloud image
    }
    
}

