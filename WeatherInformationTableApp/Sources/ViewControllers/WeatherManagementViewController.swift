//
//  WeatherManagementViewController.swift
//  WeatherInformationTableApp
//
//  Created by TakumiHasegawa on 2025/09/02.
//

import UIKit

final class WeatherManagementViewController: UIViewController {
    
    // MARK: - Dependency
    @IBOutlet private weak var weatherPointTextField: UITextField!
    @IBOutlet private weak var weatherTableView: UITableView! {
        didSet {
            weatherTableView.estimatedRowHeight = 190
            weatherTableView.rowHeight = UITableView.automaticDimension
            weatherTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
            weatherTableView.registerCell(WeatherInformationTableViewCell.self)
        }
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.dataSource = self
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
