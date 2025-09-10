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
    
    // MARK: - Configuration
    func configure(with weatherResponse: WeatherResponse, iconURL: String?) {
        weatherPointLabel.text = weatherResponse.name
        maxTemperatureLabel.text = "最高気温: \(Int(weatherResponse.main.tempMax))°C"
        minTemperatureLabel.text = "最低気温: \(Int(weatherResponse.main.tempMin))°C"
        humidityLabel.text = "湿度: \(weatherResponse.main.humidity)%"
        windSpeedLabel.text = "風速: \(weatherResponse.wind.speed)m/s"
        
        weatherImage.pin_setImage(from: URL(string: iconURL ?? ""))
    }
}
