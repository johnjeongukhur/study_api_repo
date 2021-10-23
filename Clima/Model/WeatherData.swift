//
//  weatherData.swift
//  Clima
//
//  Created by John Hur on 2021/10/20.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

// WeatherManager에서 응답되는 데이터를 여기서
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    
}

struct Weather: Codable {
    let description: String
    let id: Int
}
