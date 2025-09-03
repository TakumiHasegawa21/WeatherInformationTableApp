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
    var cityInput: PublishRelay<String> { get }
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
    let cityInput = PublishRelay<String>()
    
    // MARK: - Output Sources
    let weather: Property<WeatherResponse?>
    let isLoading: Driver<Bool>
    
    // MARK: - Properties
    private let _weather = BehaviorRelay<WeatherResponse?>(value: nil)
    private let _city = BehaviorRelay<String>(value: "Tokyo")
    private let loadAction: Action<String, WeatherResponse>
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        
        // MARK: - Actions
        self.loadAction = Action { city in
            weatherRepository.getWeatherInformation(for: city).asObservable()
        }
        
        // MARK: - Outputs & Actions Elements
        self.isLoading = loadAction.executing.asDriver(onErrorDriveWith: .empty())
        self.weather = Property(_weather)
        
        cityInput
            .bind(to: _city)
            .disposed(by: disposeBag)

        reload.asObservable()
            .withLatestFrom(_city) { _, city in city }
            .bind(to: loadAction.inputs)
            .disposed(by: disposeBag)
            
        loadAction.elements
            .bind(to: _weather)
            .disposed(by: disposeBag)
    }
}
