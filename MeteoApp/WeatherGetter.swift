//
//  getMeteo.swift
//  MeteoApp
//
//  Created by Kevin Roth on 10/12/2017.
//  Copyright © 2017 Kevin Roth. All rights reserved.
//


import Foundation


// MARK: WeatherGetterDelegate
// ===========================
// WeatherGetter should be used by a class or struct, and that class or struct
// should adopt this protocol and register itself as the delegate.
// The delegate's didGetWeather method is called if the weather data was
// acquired from OpenWeatherMap.org and successfully converted from JSON into
// a Swift dictionary.
// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.
protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}


// MARK: WeatherGetter
// ===================

class WeatherGetter {
    
    private var delegate: WeatherGetterDelegate
    
    
    // MARK: -
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByCity(city: String) {
        let weatherRequestURL = URL(string:"http://api.openweathermap.org/data/2.5/weather?APPID=6ca0bce84fd8c89e6bc9d91caa15294b")
        getWeather(weatherRequestURL:weatherRequestURL!)
    }
    
    /*
    func getWeatherByCoordinates(latitude latitude: Double, longitude: Double) {
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL)
    }
   */
    
    private func getWeather(weatherRequestURL: URL) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(width:weatherRequestURL) {
            (data: NSData?, response: URLResponse?, error: NSError?) in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetWeather(networkError)
            }
            else {
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(
                        data!,
                        options: .MutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetWeather(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}



