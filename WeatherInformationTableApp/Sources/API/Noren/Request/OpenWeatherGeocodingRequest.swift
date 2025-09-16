//
//  OpenWeatherGeocodingRequest.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/03.
//

import Foundation
import RxSwift
import APIKit

extension NorenAPI {
    struct GeocodingRequest: NorenRequestType {

        // MARK: - Properties
        let query: String
        let apiKey: String

        // MARK: - Request Type
        typealias Response = [GeocodingResponse]

        let method: HTTPMethod = .get
        var path: String {
            return "/geo/1.0/direct"
        }
        var parameters: Any? {
            return [
                "q": query,
                "limit": 5,
                "appid": apiKey
            ]
        }

        var dataParser: DataParser {
            return JSONDataParser(readingOptions: [])
        }

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
            guard let jsonObject = object as? [Any] else {
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
