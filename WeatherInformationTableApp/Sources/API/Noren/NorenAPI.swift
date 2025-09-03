//
//  NorenAPI.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import Foundation
import APIKit

struct NorenAPI {}

// MARK: - NorenRequestType Protocol
protocol NorenRequestType: Request {
    var baseURL: URL { get }
}

// MARK: - Default Implementation
extension NorenRequestType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
}
