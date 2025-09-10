//
//  UIImageViewExtension.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/10.
//

import UIKit
import PINRemoteImage

extension UIImageView {
    func pin_setFadeInImage(from url: URL?,
                            placeholderImage: UIImage? = nil,
                            completion: PINRemoteImageManagerImageCompletion? = nil) {
        pin_setImage(from: url, placeholderImage: placeholderImage) { [weak self] result in
            completion?(result)
            guard result.resultType == .download else { return }
            self?.alpha = 0
            UIView.animate(withDuration: 0.3) { self?.alpha = 1 }
        }
    }
}
