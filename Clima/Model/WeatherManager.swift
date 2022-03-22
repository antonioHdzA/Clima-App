//
//  WeatherManager.swift
//  Clima
//
//  Created by Antonio Hernandez Ambrocio on 04/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=4ccae96f853a1b9633f2e2725f7f44fe&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lon=\(longitude)&lat=\(latitude)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        //Create a URL
        if let url = URL(string: urlString) {
            //Create a urlSession
            let session = URLSession(configuration: .default)
            //Give a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailedWithError(error!)
                    return
                }
                if let data = data {
                    if let weatherModel = parseJSON(data: data) {
                        self.delegate?.didUpdateWeather(weather: weatherModel)
                    }
                }
            }
            //Start task
            task.resume()
        }
    }
    
    func handle(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
            return
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            let weatherModel = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weatherModel
            
        }
        catch {
            delegate?.didFailedWithError(error)
            return nil
        }
    }
    
    
    
}
