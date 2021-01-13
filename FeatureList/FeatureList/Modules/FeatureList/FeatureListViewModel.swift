//
//  FeatureListViewModel.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

final class FeatureListViewModel {
    //MARK: - Private properties
    private let dataSource: [FeatureListModel] = [
        FeatureListModel(featureName: "Standard Checkout", feature: .standardCheckout),
        FeatureListModel(featureName: "Processadora custom", feature: .customProcesadora),
        FeatureListModel(featureName: "Builder custom", feature: .customBuilder),
        FeatureListModel(featureName: "Checkout with charges", feature: .withCharges),
        FeatureListModel(featureName: "With charges and alert", feature: .chargesWithAlert),
        FeatureListModel(featureName: "No charges", feature: .noCharges)
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
    
    //TODO: Create a credentials file to add the information bellow and add to gitignore
    func getPreferenceId() -> String {
        return ""
    }
    
    func getPublicKey() -> String {
        return ""
    }
    
    func getPrivateKey() -> String {
        return ""
    }
}
