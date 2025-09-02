//
//  WeatherInformationTableViewCell.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit
import PINRemoteImage

final class WeatherInformationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet private weak var weatherPointLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var mapNavigationButton: UIButton!
    @IBOutlet private weak var weatherImage: UIImageView!

    // MARK: - Initialize
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImage.pin_clearImages()
        weatherImage.pin_cancelImageDownload()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
