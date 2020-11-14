//
//  ViewController.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var collectionViewContainer: UIView!
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
        
        prepUI()
        
        fetchWeather()
        
        
        
        
    }
    //===========
    
    func prepUI(){
        
        
        //mainView.anchor(top: navBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: -5.0, paddingRight: 5.0, width: 0, height: 0)
        
        
        var screenWidth: CGFloat {
            if screenOrientation.isPortrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
        var screenHeight: CGFloat {
            if screenOrientation.isPortrait {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
        
        
        //        var screenOrientation: UIInterfaceOrientation {
        //            return UIApplication.shared.statusBarOrientation
        //        }
        
        var screenOrientation: UIInterfaceOrientation {
            get {
                guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                    #if DEBUG
                    fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                    #else
                    return nil
                    #endif
                }
                return orientation
            }
        }
        
        // =======POSITION THE VIEW =======
        
        //1. --------------MAIN VIEW -------
        
        // let screenH = UIScreen.main.bounds.size.height
        
        mainView.frame.origin.y = navBar.frame.size.height
        mainView.frame.origin.x = 0.0
        
        mainView.frame.size.height = screenHeight - (navBar.frame.size.height + 20)
        
        
        
        
        
        
        
        
        
        
        
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
            
            
            
            
            
            //========converting the data into a array of dictionaires since we got a data object====
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                //print("This is JSON: \(json)")
                
                if let parserJSON =  json!["list"] as? [Dictionary<String,Any>]{
                    
                    //print("THIS IS PARSE JSON: \(parserJSON)")
                    
                    for dataReturned in parserJSON {
                        
                        var weatherObject: WeatherClass
                        weatherObject = WeatherClass.init()
                        
                        
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
                        
                        
                        
                        //array of data
                        guard let weatherData = dataReturned["weather"] as? [Dictionary<String,Any>] else {
                            return
                        }
                        
                        
                        for weatherData in weatherData{
                            weatherObject.weatherDesc = weatherData["description"] as! String
                            weatherObject.weatherIcon = weatherData["icon"] as! String
                            
                        }
                        
                        
                        self.weatherArray.append(weatherObject)
                        
                        DispatchQueue.main.async {
                            
                            self.collectionView.reloadData()
                            
                        }
                        
                        
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
        
        
        cell.cityName?.layer.cornerRadius = 5.0
        cell.cityName?.layer.masksToBounds = true
        cell.cityName.text!  = weatherArrayObject.cityName
        
        cell.latitudeLabel?.layer.cornerRadius = 5.0
        cell.latitudeLabel?.layer.masksToBounds = true
        cell.latitudeLabel.text! = String(weatherArrayObject.latitude)
        
        cell.logitudeLabel?.layer.cornerRadius = 5.0
        cell.latitudeLabel?.layer.masksToBounds = true
        cell.logitudeLabel.text! = String(weatherArrayObject.longitude)
        
        
        //        cell.humidityLabel?.layer.cornerRadius = 5.0
        //        cell.humidityLabel?.layer.masksToBounds = true
        //        cell.humidityLabel.text! = "\(String(weatherArrayObject.humidity) ) %"
        //
        
        //        cell.pressureLabel?.layer.cornerRadius = 5.0
        //        cell.pressureLabel?.layer.masksToBounds = true
        //        cell.pressureLabel.text! = "\(String(weatherArrayObject.pressure) ) %"
        
        
        
        
        //        cell.tempLabel?.layer.cornerRadius = 5.0
        //        cell.tempLabel?.layer.masksToBounds = true
        //
        //        let convertedTempInCelcius = Utilities.convertFromKelvinToCelcius(tempInKelvin: weatherArrayObject.temperature)
        //        cell.tempLabel.text! = "\(Int(convertedTempInCelcius)) °C"
        
        
        
        //        //Formatting Date
        //        let unixTimeInterval: Int = weatherArrayObject.date
        //        let stringDate = Utilities.convertUnixTimeStampToStringDate(unixTimeInterval: unixTimeInterval)
        //        cell.dateLabel.text! = stringDate
        
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






//========================================

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
