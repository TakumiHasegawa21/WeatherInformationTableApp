//
//  UITableViewExtension.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit

extension UITableView {
    // swiftlint:disable force_cast
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, identifier: String, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
    // swiftlint:enable force_cast
}

extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.className, bundle: nil), forCellReuseIdentifier: T.className)
    }
    
    func registerCell<T: UITableViewCell>(_: T.Type, identifier: String) {
        register(UINib(nibName: T.className, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerCell(_ nibName: String, identifier: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(UINib(nibName: T.className, bundle: nil), forHeaderFooterViewReuseIdentifier: T.className)
    }
}
