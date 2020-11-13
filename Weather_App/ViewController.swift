//
//  ViewController.swift
//  Weather_App
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    let baseURL: String = "https://api.openweathermap.org/data/2.5/group?id=833,3245,524901,703448,2643743,8277210,4873354,3126863,3125523,3120259&units=metric"
    
    let apiKey:String = "10f09520ecd91670d285f15548b94940"
    
    //https://api.openweathermap.org/data/2.5/group?id=833,3245,524901,703448,2643743,8277210,4873354,3126863,3125523,3120259&units=metric&appid=10f09520ecd91670d285f15548b94940
    

    @IBOutlet weak var collectionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

