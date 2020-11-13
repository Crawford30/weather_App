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
        
        
    }
    
    
    
    //==========================
    
    
    
    
    
    
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




