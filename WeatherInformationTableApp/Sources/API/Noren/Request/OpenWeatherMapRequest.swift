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

        var dataParser: DataParser {
            return JSONDataParser(readingOptions: [])
        }

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
            guard let jsonObject = object as? [String: Any] else {
                print("Unexpected object type:", type(of: object))
                throw ResponseError.unexpectedObject(object)
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonObject)
                let decoder = JSONDecoder()
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw ResponseError.unexpectedObject(object)
            }
        }
    }
}
