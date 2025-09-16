//
//  WeatherManagementViewController.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherManagementViewController: UIViewController {

    // MARK: - Dependency
    typealias Dependency = WeatherManagementViewModelType

    // MARK: - Properties
    @IBOutlet private weak var weatherPointTextField: UITextField!
    @IBOutlet private weak var weatherSearchButton: UIButton!
    @IBOutlet private weak var weatherTableView: UITableView! {
        didSet {
            weatherTableView.rowHeight = 320
            weatherTableView.registerCell(WeatherInformationTableViewCell.self)
            weatherTableView.refreshControl = refreshControl
        }
    }
    
    private lazy var viewModel: Dependency = { fatalError("Use configure(with:) method at initialize controller") }()
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .gray
        return view
    }()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    init(dependency: Dependency) {
        super.init(nibName: Self.className, bundle: Self.bundle)
        self.viewModel = dependency
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.inputs.reload.accept(())
    }
}


// MARK: - Binding
private extension WeatherManagementViewController {
    func bind(to viewModel: WeatherManagementViewModelType) {
        // 検索ボタンのタップで天気情報を取得
        weatherSearchButton.rx.tap.asSignal()
            .withLatestFrom(weatherPointTextField.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
            .filter { !$0.isEmpty }
            .emit(onNext: { [weak self] inputText in
                self?.viewModel.inputs.cityKeyword.accept(inputText)
            })
            .disposed(by: disposeBag)
        
        // 検索ボタンをタップすると合わせてリロード処理も実行
        weatherSearchButton.rx.tap.asSignal()
            .withLatestFrom(weatherPointTextField.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
            .filter { !$0.isEmpty }
            .emit(onNext: { [weak self] _ in
                self?.viewModel.inputs.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        // ViewModelのweatherデータを監視してTableViewを更新
        Driver.combineLatest(
            viewModel.outputs.weather,
            viewModel.outputs.weatherIconURL
        )
        .map { weatherData, iconURL in
            weatherData.map { ($0, iconURL) }
        }
        .drive(weatherTableView.rx.items) { tableView, row, data in
            let (weatherResponse, iconURL) = data
            let cell = tableView.dequeueReusableCell(WeatherInformationTableViewCell.self, for: [0, row])
            cell.configure(with: weatherResponse, iconURL: iconURL)
            return cell
        }
        .disposed(by: disposeBag)
        
        // isLoading実行時はRefreshControlを表示 (読み込みが一瞬すぎてわからない)
        viewModel.outputs.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // PullToRefreshでリロード処理実行
        refreshControl.rx.controlEvent(.valueChanged)
            .asSignal()
            .emit(to: viewModel.inputs.reload)
            .disposed(by: disposeBag)
        
        // エラー表示処理
        viewModel.outputs.error
            .filter { $0 != nil }
            .drive(onNext: { [weak self] _ in
                let alert = UIAlertController(title: "エラーが発生しました", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
