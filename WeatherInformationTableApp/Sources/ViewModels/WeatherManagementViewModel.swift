//
//  WeatherManagementViewModel.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import Foundation
import Action
import RxCocoa
import RxSwift

protocol WeatherManagementViewModelInputs: AnyObject {
    var reload: PublishRelay<Void> { get }
    var cityKeyword: PublishRelay<String> { get }
}

protocol WeatherManagementViewModelOutputs: AnyObject {
    var weather: Driver<[WeatherResponse]> { get }
    var weatherIconURL: Driver<String?> { get }
    var isLoading: Driver<Bool> { get }
    var error: Driver<APIError?> { get }
}

protocol WeatherManagementViewModelType: AnyObject {
    var inputs: WeatherManagementViewModelInputs { get }
    var outputs: WeatherManagementViewModelOutputs { get }
}

final class WeatherManagementViewModel: WeatherManagementViewModelType, WeatherManagementViewModelInputs, WeatherManagementViewModelOutputs {
    // MARK: - Properties
    var inputs: WeatherManagementViewModelInputs { return self }
    var outputs: WeatherManagementViewModelOutputs { return self }

    // MARK: - Input Sources
    let reload = PublishRelay<Void>()
    let cityKeyword = PublishRelay<String>()
    
    // MARK: - Output Sources
    let weather: Driver<[WeatherResponse]>
    let weatherIconURL: Driver<String?>
    let isLoading: Driver<Bool>
    let error: Driver<APIError?>

    // MARK: - Properties
    private let loadAction: Action<String, WeatherResponse>
    private let _weather = BehaviorRelay<WeatherResponse?>(value: nil)
    private let _city = BehaviorRelay<String>(value: "Tokyo")
    private let _error = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    // MARK: - Initialize
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository(), geocodingRepository: GeocodingRepositoryProtocol = GeocodingRepository()) {

        // MARK: - Actions
        self.loadAction = Action { city in
            weatherRepository.getWeatherInformation(for: city).asObservable()
        }
    
        // MARK: - Outputs & Actions Elements
        self.isLoading = loadAction.executing.asDriver(onErrorDriveWith: .empty())
        self.weather = _weather
            .asDriver()
            .map { weatherResponse in
                weatherResponse.map { [$0] } ?? []
            }
        self.weatherIconURL = _weather
            .asDriver()
            .map { weatherResponse in
                guard let iconCode = weatherResponse?.weather.first?.icon else { return nil }
                return OpenWeatherConstants.iconURL(for: iconCode)
            }

        let error = loadAction.underlyingError
            .map { APIError(error: $0) }
            .map { Optional($0) }
            .asDriver(onErrorDriveWith: .empty())
        self.error = Driver.merge(error,
                                  isLoading.filter { $0 }.map { _ in nil })
        .startWith(nil)

        // MARK: - Inputs
        cityKeyword
            .bind(to: _city)
            .disposed(by: disposeBag)

        reload.asObservable()
            .withLatestFrom(_city) { _, city in city }
            .flatMap { city in
                // Geocoding APIで地名を検索（日本語地名も対応）
                return geocodingRepository.searchCity(city)
                    .map { responses in
                        guard let firstResponse = responses.first else {
                            return city
                        }
                        return firstResponse.name
                    }
                    .catch { _ in
                        return Single.just(city)
                    }
            }
            .bind(to: loadAction.inputs)
            .disposed(by: disposeBag)

        loadAction.elements
            .bind(to: _weather)
            .disposed(by: disposeBag)
    }
}
