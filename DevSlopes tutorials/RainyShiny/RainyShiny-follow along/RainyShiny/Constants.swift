//
//  Constants.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 22/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import Foundation

let _baseURL = "http://api.openweathermap.org/data/2.5/"
let _weather = "weather?"
let _latitude = "lat="
let _longitude = "&lon="
let _appID = "&appid="
let _apiKey = "6ea088e7ebdd313ed62dfdad63051c77"

typealias DownloadComplete = () -> ()

//http://api.openweathermap.org/data/2.5/forecast?lat=1.4&lon=103&appid=6ea088e7ebdd313ed62dfdad63051c77

let current_Weather_URL = "\(_baseURL)\(_weather)\(_latitude)\(Location.sharedInstance.latitude!)\(_longitude)\(Location.sharedInstance.longitude!)\(_appID)\(_apiKey)"
//lat=35&lon=139&appid=6ea088e7ebdd313ed62dfdad63051c77
let _forecast = "forecast?"
let forecast_URL = "\(_baseURL)\(_forecast)\(_latitude)\(Location.sharedInstance.latitude!)\(_longitude)\(Location.sharedInstance.longitude!)\(_appID)\(_apiKey)"
