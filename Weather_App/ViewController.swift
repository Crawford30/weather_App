//
//  ViewController.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var navBar: UINavigationBar!
    let keyForBookMarks = "BookMarks"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mainView: UIView!
    
    var isBookMarked:Bool = false
    
    
    var weatherArray:   [ WeatherClass ] = []
    var bookMarkArray:   [ WeatherClass ] = []
    var selectedBookMarkArray: [ WeatherClass ] = []
    
    
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
        
        checkForBookMarks() 
        
        
        
        
    }
    //===========
    
    func prepUI(){
        
        let screenWidth = self.view.frame.size.width
        let screenHeight =  self.view.frame.size.height
        
        //main view
        mainView.frame = CGRect(x: 0, y: 64, width: (2  * screenWidth ), height: screenHeight)
        
        //collection view
        collectionView.frame = CGRect(x: 0, y: 5, width: screenWidth, height: mainView.frame.size.height)
        
        
        
    }
    
    
    
    
    
    //⚙️⚙️⚙️⚙️  SUPPORT FOR SAVING AND LOADING BOOKMARKS  ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️
    
    
    //MARK:- SAVE BOOK MARK
    func saveBookMark() {
        
        do {
            
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: bookMarkArray, requiringSecureCoding: false)
            
            UserDefaults.standard.set( encodedData, forKey: keyForBookMarks )
            
        } catch {
            
            print("Problem in saving data")
            
        }
        
    }
    
    
    
    //MARK: - CHECK BOOK MARK
    func checkForBookMarks() {
        
        //--------------------------------------------------------------------------
        
        if  UserDefaults.standard.object(forKey: keyForBookMarks ) == nil {  // Return if no bookmark saved
            
            return
            
        }
        
        do {
            
            let decodedData = UserDefaults.standard.object(forKey: keyForBookMarks ) as! Data
            
            bookMarkArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData( decodedData ) as! [WeatherClass]
            
        } catch {
            
            print("Problem Decoding Bookmarks")
            
        }
        
    }
    
    
    
    //===================isBookMark============
    func isBookMark( theID: WeatherClass ) -> Bool {
        
        if bookMarkArray.count == 0 {
            return false
            
        }
        
        for localID in bookMarkArray {
            
            if localID.id == theID.id {
                
                return true
                
            }
            
        }
        
        return false
        
    }
    
    
    
    //========removing book mark
    func removeBookMark( theID: WeatherClass ) {
        if bookMarkArray.count == 0 {
            
            return
            
        }
        
        var localIndex: Int = 0
        
        for localID in bookMarkArray {
            
            if localID.id == theID.id {
                
                bookMarkArray.remove(at: localIndex)
                
                
                //                //========= checking  for count ====
                //                if bookMarkArray.count == 0 {
                //
                //                   // bookMarkArray = weatherArray //to load all data
                //
                //                }
                
                return
                
            }
            
            
        }
        
        localIndex += 1
        
        
        
        
    }
    
    
    
    @IBAction func bookMarkAction(_ sender: UIButton) {
        
        
        print("BOOKMARK BUTTON TAPPED: \(sender.tag)")
        
        
        let whichLocation: Int = sender.tag
        
        // let id = weatherArray[whichLocation].id
        
        //  print("THIS IS THE WEATHER ID: \(id)")
        
        
        var isInBookMark: Bool = false //assume not already  in bookmark
        
        isInBookMark = isBookMark(theID: weatherArray[whichLocation])
        
        if isInBookMark {
            
            removeBookMark(theID: weatherArray[whichLocation])
            
            
            
        } else{
            
            bookMarkArray.append( weatherArray[ whichLocation ] )
        }
        
        
        
        collectionView.reloadData()
        
        saveBookMark()
        
        
        
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
                        weatherObject = WeatherClass.init(locationID: 0, date: 0, cityName: "", temperature: 0.0, tempMin: 0.0, tempMax: 0.0, pressure: 0, humidity: 0, windSpeed: 0.0, windDeg: 0.0, country: "", clouds: 0, latitude: 0.0, longitude: 0.0, weatherMain: "", weatherIcon: "", weatherDesc: "")
                        
                        
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
                        
                        
                        
                        
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                        
                        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true )
                        
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
        
        cell.bookMarkBtn.tag = indexPath.item
        
        
        //
        if isBookMark(theID: weatherArray[indexPath.item]){
            
            cell.bookMarkBtn.setImage(UIImage(named:"filledStarRating"), for: .normal)
            
        } else {
            
            cell.bookMarkBtn.setImage(UIImage(named:"notFilledStar"), for: .normal)
            
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationDetail") as! CityLocationDetailViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
        
        
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
