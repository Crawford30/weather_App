//
//  WeatherClass.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import Foundation
import UIKit


class WeatherClass: NSObject {
    
    var id: Int = 0
    var cityName:String = ""
    var date: Int = 0
    
    
    
    //main
    var temperature: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0
    
    //wind
    var windSpeed: Double = 0.0
    var windDeg: Double = 0.0
    
    //sys
    var country: String = ""
    
    //clouds
    var clouds: Int = 0
    
    
    //Coordinate
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    
    //weather
    //    var weatherID: Int = 0
    var weatherMain: String = ""
    var weatherIcon: String = ""
    var weatherDesc: String = ""
    
    
    
    
}

