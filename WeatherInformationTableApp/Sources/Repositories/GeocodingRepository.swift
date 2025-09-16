//
//  GeocodingRepository.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/03.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit

protocol GeocodingRepositoryProtocol {
    func searchCity(_ query: String) -> Single<[GeocodingResponse]>
}

final class GeocodingRepository: GeocodingRepositoryProtocol {

    // MARK: - GeocodingRepositoryProtocol
    func searchCity(_ query: String) -> Single<[GeocodingResponse]> {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String ?? ""
        let request = NorenAPI.GeocodingRequest(query: query, apiKey: apiKey)
        return Single<[GeocodingResponse]>.create { observer in
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
