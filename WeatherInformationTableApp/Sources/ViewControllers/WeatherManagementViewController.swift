//
//  WeatherManagementViewController.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit
import APIKit

final class WeatherManagementViewController: UIViewController {
    
    // MARK: - Properties
    private let apiKey = "a284d183b62eae0d39b4a24d5822c531"
    
    // MARK: - Dependency
    @IBOutlet private weak var weatherPointTextField: UITextField!
    @IBOutlet private weak var weatherTableView: UITableView! {
        didSet {
            weatherTableView.rowHeight = 190
            weatherTableView.registerCell(WeatherInformationTableViewCell.self)
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        // 東京固定
        fetchWeatherData(for: "Tokyo")
    }
    
    // MARK: - API Call
    private func fetchWeatherData(for city: String) {
        let request = NorenAPI.GetWeatherRequest(city: city, apiKey: apiKey)
        
        // 送信URLを事前にログ出力
        if let urlRequest = try? request.buildURLRequest() {
            print("Request URL:", urlRequest.url?.absoluteString ?? "nil")
        }
        
        Session.send(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.handleWeatherResponse(response)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleWeatherResponse(_ response: WeatherResponse) {
        print("=== 天気情報取得成功 ===")
        print("都市: \(response.name)")
        print("天気: \(response.weather.first?.description ?? "不明")")
        print("現在気温: \(response.main.temp)°C")
        print("最高気温: \(response.main.tempMax)°C")
        print("最低気温: \(response.main.tempMin)°C")
        print("湿度: \(response.main.humidity)%")
        print("風速: \(response.wind.speed)m/s")
        print("======================")
    }
    
    private func handleError(_ error: Error) {
        print("=== 天気情報取得エラー ===")
        if let taskError = error as? SessionTaskError {
            switch taskError {
            case .connectionError(let underlying):
                print("種別: connectionError")
                print("詳細:", underlying.localizedDescription)
            case .requestError(let underlying):
                print("種別: requestError (URLRequest生成時)")
                print("詳細:", underlying.localizedDescription)
            case .responseError(let underlying):
                print("種別: responseError (レスポンス解析時)")
                print("詳細:", underlying.localizedDescription)
            }
        } else {
            print("種別: unknown")
            print("詳細:", error.localizedDescription)
        }
        print("========================")
    }
}

extension WeatherManagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: WeatherInformationTableViewCell.self),
            for: indexPath
        ) as! WeatherInformationTableViewCell
        return cell
    }
}

extension WeatherManagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
