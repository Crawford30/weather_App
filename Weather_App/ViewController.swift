//
//  ViewController.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var weatherArray:   [ WeatherClass ] = []
    
    
    let baseURL: String = "https://api.openweathermap.org/data/2.5/group?id=833,3245,524901,703448,2643743,8277210,4873354,3126863,3125523,3120259&units=metric"
    
    let myCellSize: CGSize = CGSize(width: 295, height: 153)
    let myVertSpacing:  CGFloat = CGFloat( 8.0 )
    let apiKey: String = "10f09520ecd91670d285f15548b94940"
    
    //https://api.openweathermap.org/data/2.5/group?id=833,3245,524901,703448,2643743,8277210,4873354,3126863,3125523,3120259&units=metric&appid=10f09520ecd91670d285f15548b94940
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        fetchWeather()
        
        
    }
    
    
    
    
    
    //=============SEND REQUEST ======
    
    func fetchWeather() {
        
        let session = URLSession.shared
        let fullURLPath = baseURL + "&appid=\(apiKey)"
        
        print("Full URL Path: \(fullURLPath)")
        
        let url = URL(string: fullURLPath)!
        
        //=======convert url to request===
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            
            //======checking if the response is okay=====
            if error != nil {
                
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                
                print("error=\(String(describing: error))")
                
                return
                
            }
            
            var weatherObject: WeatherClass
            
            weatherObject = WeatherClass.init()
            
            
            
            
            //========converting the data into a array of dictionaires since we got a data object====
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                //print("This is JSON: \(json)")
                
                if let parserJSON =  json!["list"] as? [Dictionary<String,Any>]{
                    
                    //print("THIS IS PARSE JSON: \(parserJSON)")
                    
                    for dataReturned in parserJSON {
                        
                        weatherObject.cityName = dataReturned["name"] as! String
                        weatherObject.id = dataReturned["id"] as! Int
                        weatherObject.date = dataReturned["dt"] as! Int
                        
                        
                        guard let coordinateDict = dataReturned["coord"] as? Dictionary<String,Any> else {
                            return
                        }
                        
                        
                        //  print("THIS IS COORD DATA : \(coordinateDict)")
                        weatherObject.latitude = coordinateDict["lat"] as! Double
                        weatherObject.longitude = coordinateDict["lon"] as! Double
                        
                        guard let mainDictData = dataReturned["main"] as? Dictionary<String,Any> else {
                            return
                        }
                        weatherObject.temperature = mainDictData["temp"] as! Double
                        weatherObject.tempMin = mainDictData["temp_min"] as! Double
                        weatherObject.tempMax = mainDictData["temp_max"] as! Double
                        weatherObject.humidity = mainDictData["humidity"] as! Int
                        weatherObject.pressure = mainDictData["pressure"] as! Int
                        
                        
                        
                        
                        guard let windDict = dataReturned["wind"] as? Dictionary<String,Any> else {
                            return
                        }
                        weatherObject.windDeg =  Double(windDict["deg"] as! Int)
                        weatherObject.windSpeed =  windDict["speed"] as? Double ?? 0.0
                        
                        
                        
                        guard let weatherData = dataReturned["weather"] as? [Dictionary<String,Any>] else {
                            return
                        }
                        
                        
                        for weatherDict in weatherData{
                            weatherObject.weatherDesc = weatherDict["description"] as! String
                            weatherObject.weatherIcon = weatherDict["icon"] as! String
                            
                        }
                        
                        
                        
                    }
                    
                    
                    self.weatherArray.append(weatherObject)
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                        
                    }
                   
                    
                }
                
                
                
                
                
            } catch {
                
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                
                print(error)
                
                return
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    //==========================
    
    
    //============function to display alert messages==================
    func displayMessage(userMessage: String) -> Void {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController (title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                
                (action: UIAlertAction!) in
                
                //==========code in this block will trigger when ok button is tapped============
                
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    //======================================
    
    
    
    
    
    
    //=====collection view methods ====
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return myCellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        print("This is total number of items in section: \(weatherArray.count)")
        
        return weatherArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! WeatherCell
        
        let weatherArrayObject = weatherArray[indexPath.item]
        
        cell.cityName.text!  = weatherArrayObject.cityName
        
        cell.humidityLabel.text! = "\(String(weatherArrayObject.humidity) ) %"
        cell.pressureLabel.text! = "\(String(weatherArrayObject.pressure) ) %"
        
        
        let convertedTempInCelcius = Utilities.convertFromKelvinToCelcius(tempInKelvin: weatherArrayObject.temperature)
        cell.tempLabel.text! = "\(Int(convertedTempInCelcius)) °C"
        
        //Formatting Date
        let unixTimeInterval: Int = weatherArrayObject.date
        let stringDate = Utilities.convertUnixTimeStampToStringDate(unixTimeInterval: unixTimeInterval)
        cell.dateLabel.text! = stringDate
        
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
}



//EXTENSION FOR COLLECTION VIEW
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: myVertSpacing, left: myVertSpacing, bottom: myVertSpacing, right: myVertSpacing)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return myVertSpacing
        
    }
    
    
}




