//
//  FeatureListViewModel.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

final class FeatureListViewModel {
    //MARK: - Private properties
    private let dataSource: [FeatureListModel] = [
        FeatureListModel(featureName: "Payment", feature: .payment),
        FeatureListModel(featureName: "Request Money", feature: .requestMoney)
    ]
    
    //MARK: - Public methods
    func getNumberOfCells() -> Int {
        return dataSource.count
    }
    
    func getFeatureName(index: Int) -> String {
        return dataSource[index].featureName
    }
    
    func getFeature(index: Int) -> Feature {
        return dataSource[index].feature
    }
}
