//
//  OpenWeatherGeocodingAPIInfo.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/16.
//

import Foundation

struct GeocodingResponse: Codable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
    }
