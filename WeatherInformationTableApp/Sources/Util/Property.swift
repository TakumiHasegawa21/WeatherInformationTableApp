//
//  Property.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/03.
//

import Foundation
import RxSwift
import RxCocoa

/// A get-only `BehaviorRelay` that works similar to ReactiveSwift's `Property`.
///
/// - Note:
/// From ver 0.3.0, this class will no longer send `.completed` when deallocated.
///
/// - SeeAlso:
///     https://github.com/inamiy/RxProperty
///     https://github.com/ReactiveCocoa/ReactiveSwift/blob/1.1.0/Sources/Property.swift
///     https://github.com/ReactiveX/RxSwift/pull/1118 (unmerged)
final class Property<Element> {
    
    // MARK: - Properties
    private let _behaviorRelay: BehaviorRelay<Element>
    private let _disposeBag: DisposeBag?
    
    var value: Element {
        return _behaviorRelay.value
    }
    
    // MARK: - Initialize
    init(_ value: Element) {
        _behaviorRelay = BehaviorRelay(value: value)
        _disposeBag = nil
    }
    
    init(_ behaviorRelay: BehaviorRelay<Element>) {
        _behaviorRelay = behaviorRelay
        _disposeBag = nil
    }
    
    func asObservable() -> Observable<Element> {
        return _behaviorRelay.asObservable()
    }
    
    func asDriver() -> Driver<Element> {
        return _behaviorRelay.asDriver()
    }
    
    func asSignal() -> Signal<Element> {
        return _behaviorRelay.asSignal(onErrorSignalWith: .empty())
    }
    
    var changed: Observable<Element> {
        return asObservable().skip(1)
    }
    
}
