//
//  ViewController.swift
//  MeteoApp
//
//  Created by Kevin Roth on 10/12/2017.
//  Copyright © 2017 Kevin Roth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let weather = WeatherGetter()
        weather.getWeather(city:"Tampa")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

