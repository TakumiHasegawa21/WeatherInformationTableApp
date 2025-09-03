//
//  WeatherRepository.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/03.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit

protocol WeatherRepositoryProtocol {
    func getWeatherInformation() -> Single<WeatherResponse>
}

final class WeatherRepository: WeatherRepositoryProtocol {
    // MARK: - ItemRepository Protocol
    func getWeatherInformation() -> Single<WeatherResponse> {
        let request = NorenAPI.GetWeatherRequest(city: "Tokyo", apiKey: "a284d183b62eae0d39b4a24d5822c531")
        return Single<WeatherResponse>.create { observer in
            let task = Session.shared.send(request) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
