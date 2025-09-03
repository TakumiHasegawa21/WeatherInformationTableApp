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
}

protocol WeatherManagementViewModelOutputs: AnyObject {
    var weather: Property<WeatherResponse?> { get }
    var isLoading: Driver<Bool> { get }
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
    
    // MARK: - Output Sources
    let weather: Property<WeatherResponse?>
    let isLoading: Driver<Bool>
    
    // MARK: - Properties
    private let _weather = BehaviorRelay<WeatherResponse?>(value: nil)
    private let loadAction: Action<Void, WeatherResponse>
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        
        // MARK: - Actions
        self.loadAction = Action {
            weatherRepository.getWeatherInformation().asObservable()
        }
        
        // MARK: - Outputs & Actions Elements
        self.isLoading = loadAction.executing.asDriver(onErrorDriveWith: .empty())
        self.weather = Property(_weather)
        
        reload.asObservable()
            .bind(to: loadAction.inputs)
            .disposed(by: disposeBag)
        loadAction.elements
            .do(onNext: { weatherResponse in
                print("=== ViewModel経由で天気情報取得成功 ===")
                print("都市: \(weatherResponse.name)")
                print("天気: \(weatherResponse.weather.first?.description ?? "不明")")
                print("天気アイコン: \(weatherResponse.weather.first?.icon ?? "不明")")
                print("現在気温: \(weatherResponse.main.temp)°C")
                print("最高気温: \(weatherResponse.main.tempMax)°C")
                print("最低気温: \(weatherResponse.main.tempMin)°C")
                print("湿度: \(weatherResponse.main.humidity)%")
                print("風速: \(weatherResponse.wind.speed)m/s")
                print("取得時刻: \(Date())")
                print("================================")
            }, onError: { error in
                print("=== ViewModel経由で天気情報取得エラー ===")
                print("エラー: \(error)")
                print("================================")
            })
            .bind(to: _weather)
            .disposed(by: disposeBag)
    }
}
