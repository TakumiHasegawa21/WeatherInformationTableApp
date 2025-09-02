//
//  OpenWeatherAPIInfo.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import Foundation

// 天気情報
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// 座標
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// 天気詳細
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// 主な気象データ
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int
    let grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// 風速・風向き
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// 雲量
struct Clouds: Codable {
    let all: Int
}

// システム情報
struct Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
