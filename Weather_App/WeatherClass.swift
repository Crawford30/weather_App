//
//  WeatherClass.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import Foundation
import UIKit

struct Keys {
    static let locationID  =      "locationID"
    static let date  =      "date"
    static let cityName    =      "cityName"
    static let temperature     =      "temperature"
    static let tempMin     =      "tempMin"
    static let tempMax     =      "tempMax"
    static let pressure     =      "pressure"
    
    
    static let humidity     =      "humidity"
    static let windSpeed     =      "windSpeed"
    static let windDeg     =      "windDeg"
    static let country     =      "country"
    static let clouds     =      "clouds"
    static let latitude     =      "latitude"
    static let longitude     =      "longitude"
    static let weatherMain     =      "weatherMain"
    static let weatherIcon     =      "weatherIcon"
    static let weatherDesc     =      "weatherDesc"
    
}



class WeatherClass: NSObject, NSCoding {
    //    func encode(with coder: NSCoder) {
    //        <#code#>
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        <#code#>
    //    }
    
    
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
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    
    //weather
    //    var weatherID: Int = 0
    var weatherMain: String = ""
    var weatherIcon: String = ""
    var weatherDesc: String = ""
    
    
    
    
    
    init(locationID: Int, date: Int, cityName: String, temperature: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int, windSpeed: Double, windDeg: Double,country: String, clouds: Int, latitude: Double, longitude: Double, weatherMain: String, weatherIcon: String, weatherDesc: String  ) {
        
        self.id = locationID
        self.date = date
        self.cityName = cityName
        self.temperature = temperature
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.country = country
        self.clouds = clouds
        self.latitude = latitude
        self.longitude = longitude
        self.weatherMain = weatherMain
        self.weatherIcon = weatherIcon
        self.weatherDesc = weatherDesc
        
        
        
        
    }
    
    
    
    //=====read from disk==
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeInteger(forKey: Keys.locationID)  as  Int
        date = aDecoder.decodeInteger(forKey: Keys.date)  as  Int
        cityName = aDecoder.decodeObject(forKey: Keys.cityName)  as! String
        temperature = aDecoder.decodeObject(forKey: Keys.temperature)  as? Double ?? 0
        tempMin = aDecoder.decodeObject(forKey: Keys.tempMin)  as? Double ?? 0
        tempMax = aDecoder.decodeObject(forKey: Keys.tempMax)  as? Double ?? 0
        pressure = aDecoder.decodeInteger(forKey: Keys.pressure)  as  Int
        humidity = aDecoder.decodeInteger(forKey: Keys.humidity)  as  Int
        
        windSpeed = aDecoder.decodeObject(forKey: Keys.windSpeed)  as? Double ?? 0
        windDeg = aDecoder.decodeObject(forKey: Keys.windDeg)  as? Double ?? 0
        country = aDecoder.decodeObject(forKey: Keys.country)  as? String ?? ""
        clouds = aDecoder.decodeInteger(forKey: Keys.clouds)  as  Int
        
        latitude = aDecoder.decodeObject(forKey: Keys.latitude)  as? Double ?? 0
        longitude = aDecoder.decodeObject(forKey: Keys.longitude)  as? Double ?? 0
        weatherMain = aDecoder.decodeObject(forKey: Keys.weatherMain)  as! String
        weatherIcon = aDecoder.decodeObject(forKey: Keys.weatherIcon)  as! String
        weatherDesc = aDecoder.decodeObject(forKey: Keys.weatherDesc)  as! String
        
       
    
    }
    
    //======write to disk======
    func encode(with coder : NSCoder) {
        
        coder.encode(id,  forKey: Keys.locationID)
        coder.encode(date,  forKey: Keys.date)
        coder.encode(cityName,  forKey: Keys.cityName)
        coder.encode(temperature,  forKey: Keys.temperature)
        coder.encode(tempMin,  forKey: Keys.tempMin)
        coder.encode(tempMax,  forKey: Keys.tempMax)
        coder.encode(pressure,  forKey: Keys.pressure)
        coder.encode(humidity,  forKey: Keys.humidity)
        coder.encode(windSpeed,  forKey: Keys.windSpeed)
        coder.encode(windDeg,  forKey: Keys.windDeg)
        coder.encode(country,  forKey: Keys.clouds)
        coder.encode(latitude,  forKey: Keys.latitude)
        coder.encode(longitude,  forKey: Keys.longitude)
        coder.encode(weatherMain,  forKey: Keys.weatherMain)
        coder.encode(weatherIcon,  forKey: Keys.weatherDesc)
        coder.encode(weatherIcon,  forKey: Keys.weatherIcon)
        
        
    }
    
    
    
    
    
}

