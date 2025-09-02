//
//  NSObjectExtension.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import Foundation

// MARK: - Class Name
extension NSObject {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}

// MARK: - Bundle
extension NSObject {
    
    static var bundle: Bundle {
        return .init(for: self.self)
    }
}
