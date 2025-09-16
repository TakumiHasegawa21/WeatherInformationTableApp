//
//  OpenWeatherConstants.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/03.
//

import Foundation

struct OpenWeatherConstants {
    static let baseIconURL = "https://openweathermap.org/img/wn/"
    static let iconSize = "@2x.png"

    static func iconURL(for iconCode: String) -> String {
        return baseIconURL + iconCode + iconSize
    }
}
