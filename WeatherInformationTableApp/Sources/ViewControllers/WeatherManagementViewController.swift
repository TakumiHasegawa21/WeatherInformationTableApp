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

    // MARK: - Dependency
    @IBOutlet private weak var weatherPointTextField: UITextField!
    @IBOutlet private weak var weatherSearchButton: UIButton!
    @IBOutlet private weak var weatherTableView: UITableView! {
        didSet {
            weatherTableView.rowHeight = 190
            weatherTableView.registerCell(WeatherInformationTableViewCell.self)
        }
    }
    
    private var viewModel: Dependency
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    init(dependency: Dependency) {
        self.viewModel = dependency
        super.init(nibName: Self.className, bundle: Self.bundle)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        bind()
        viewModel.inputs.reload.accept(())
    }
}


// MARK: - Binding
private extension WeatherManagementViewController {
    func bind() {
        // 検索ボタンのタップで天気情報を取得
        weatherSearchButton.rx.tap
            .withLatestFrom(weatherPointTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .bind(to: viewModel.inputs.cityInput)
            .disposed(by: disposeBag)
        
        // 検索ボタンのタップでリロード実行
        weatherSearchButton.rx.tap
            .withLatestFrom(weatherPointTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        // ViewModelのweatherデータを監視してTableViewを更新
        viewModel.outputs.weather
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
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

extension WeatherManagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
