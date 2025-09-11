//
//  StatusCode.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/10.
//

import Foundation

// swiftlint:disable operator_usage_whitespace
enum StatusCode: Int {
    
    // MARK: - HTTP Error
    case ok         = 200,
         created         = 201,
         accepted        = 202,
         noContent       = 204
    
    case badRequest         = 400,
         unauthorized            = 401,
         forbidden               = 403,
         notFound                = 404,
         notAcceptable           = 406,
         requestTimeout          = 408,
         conflict                = 409,
         unprocessableEntity     = 422
    
    case internalServerError    = 500,
         badGateway                  = 502,
         serviceUnavailable          = 503,
         gatewayTimeout              = 504
    
    case networkError   = 0
    
    // MARK: - Common Error
    case unknownStatus  = -1
    case objectParserError = 40400
    
    // MARK: - Initialize
    init(code: Int?) {
        if let code = code {
            self = StatusCode(rawValue: code) ?? .unknownStatus
        } else {
            self = .networkError
        }
    }
    
}
