//
//  OpenWeatherMapRequest.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import APIKit
import Foundation

extension NorenAPI {
    struct GetWeatherRequest: NorenRequestType {
        
        // MARK: - Properties
        let city: String
        let apiKey: String
        
        // MARK: - Request Type
        typealias Response = WeatherResponse
        
        let method: HTTPMethod = .get
        var path: String {
            return "/data/2.5/weather"
        }
        var parameters: Any? {
            return [
                "q": city,
                "appid": apiKey,
                "units": "metric",
                "lang": "ja"
            ]
        }
        
        // 明示的にJSONを受け取る
        var dataParser: DataParser {
            return JSONDataParser(readingOptions: [])
        }
        
        // MARK: - Response Parsing
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> WeatherResponse {
            // JSONDataParserにより`object`はJSON(Any)になるため、Dataへ戻してからCodableデコード
            let jsonObject = object
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                // ルートが辞書/配列以外のケースも一応考慮し、辞書として受け直す
                if let dict = jsonObject as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                    let decoder = JSONDecoder()
                    return try decoder.decode(WeatherResponse.self, from: data)
                }
                if let array = jsonObject as? [Any] {
                    let data = try JSONSerialization.data(withJSONObject: array, options: [])
                    let decoder = JSONDecoder()
                    return try decoder.decode(WeatherResponse.self, from: data)
                }
                throw ResponseError.unexpectedObject(object)
            }
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        }
    }
}
