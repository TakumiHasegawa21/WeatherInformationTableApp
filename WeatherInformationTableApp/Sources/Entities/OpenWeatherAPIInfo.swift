//
//  OpenWeatherAPIInfo.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}
