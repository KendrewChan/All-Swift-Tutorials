//
//  Location.swift
//  RainyShiny
//
//  Created by Kendrew Chan on 24/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
