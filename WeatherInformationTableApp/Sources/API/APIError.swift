//
//  APIError.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/10.
//

import Foundation
import APIKit
import SwiftyJSON

struct APIError: Error {
    
    // MARK: - Properties
    let domain: String
    let statusCode: StatusCode
    let responseObject: Any?
    var responseJSON: JSON? {
        guard let object = responseObject else { return nil }
        return JSON(object)
    }
    
    // MARK: - NSError
    var _domain: String {
        return domain
    }
    var _code: Int {
        return statusCode.rawValue
    }
    
    // MARK: - Initialize
    init(error: Error) {
        if let error = error as? APIError {
            self.domain = error.domain
            self.statusCode = error.statusCode
            self.responseObject = error.responseObject
        } else if let error = error as? SessionTaskError {
            switch error {
            case .requestError:
                // APIRequest生成エラー
                self.domain = "APIKit Request Error"
                self.statusCode = .unknownStatus
                self.responseObject = nil
            case .connectionError:
                // URLSessionの内部エラー
                self.domain = "URLSession Connection Error"
                self.statusCode = .networkError
                self.responseObject = nil
            case .responseError(let responseError as APIError):
                // APIKit内部で独自エラーを吐いた場合
                self.domain = responseError.domain
                self.statusCode = responseError.statusCode
                self.responseObject = responseError.responseObject
            case .responseError(let responseError as ResponseError):
                switch responseError {
                case .nonHTTPURLResponse:
                    // URLSession上でHTTP以外のレスポンスがきた場合
                    self.domain = "Non HTTP Response"
                    self.statusCode = .networkError
                    self.responseObject = nil
                case .unacceptableStatusCode(let statusCode):
                    // APIKit.Request.intercept() 内で200番以外のステータスが帰ってきた場合
                    // ただし、各APIでエラーはAPIErrorに丸めるので通常がここにはこない
                    self.domain = "Unacceptable Status Code"
                    self.statusCode = StatusCode(code: statusCode)
                    self.responseObject = nil
                case .unexpectedObject(let object):
                    // responseをモデルへのパースに失敗した場合
                    self.domain = "Unexpected Object"
                    self.statusCode = .objectParserError
                    self.responseObject = object
                }
            case .responseError(let responseError):
                self.domain = responseError._domain
                self.statusCode = StatusCode(code: responseError._code)
                self.responseObject = nil
            }
        } else {
            self.domain = error._domain
            self.statusCode = StatusCode(code: error._code)
            self.responseObject = nil
        }
    }
    
    init(domain: String, statusCode: StatusCode, responseObject: Any?) {
        self.domain = domain
        self.statusCode = statusCode
        self.responseObject = responseObject
    }
    
}
