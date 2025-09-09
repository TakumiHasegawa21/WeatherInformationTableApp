//
//  WeatherManagementViewController.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit
import APIKit
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
        }
    }
    
    private lazy var viewModel: Dependency = { fatalError("Use configure(with:) method at initialize controller") }()
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
        weatherTableView.dataSource = self
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
            .emit(to: viewModel.inputs.cityKeyword)
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
        viewModel.outputs.weather
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.weatherTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension WeatherManagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: WeatherInformationTableViewCell.self),
            for: indexPath
        ) as! WeatherInformationTableViewCell

        if let weatherResponse = viewModel.outputs.weather.value {
            cell.configure(with: weatherResponse)
        }
        return cell
    }
}
