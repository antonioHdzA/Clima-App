//
//  WeatherMangagerDelegate.swift
//  Clima
//
//  Created by Antonio Hernandez Ambrocio on 05/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailedWithError(_ error: Error)
}
