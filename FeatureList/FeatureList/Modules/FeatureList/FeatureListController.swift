//
//  FeatureListController.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

import UIKit

final class FeatureListController: UIViewController {
    //MARK: - Private properties
    private let viewModel = FeatureListViewModel()
    private lazy var customView = FeatureListView(delegate: self, dataSource: self)
    
    //MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view = customView
    }
}

extension FeatureListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeatureListCell.reuseIdentifier) as? FeatureListCell else { return UITableViewCell() }
        cell.setupInfos(featureName: viewModel.getFeatureName(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.getFeature(index: indexPath.row) {
        case .payment: print("User did tap on payment feature")
        case .requestMoney: print("User did tap on requestMoney feature")
        }
    }
}
