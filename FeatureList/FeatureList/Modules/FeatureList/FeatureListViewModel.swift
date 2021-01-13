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
        return "656525290-7bda964b-26d9-4352-a04c-1b04801627ee"
    }
    
    func getPublicKey() -> String {
        return "TEST-e28d5a35-dece-45c9-9618-e8cc5dec6c42"
    }
    
    func getPrivateKey() -> String {
        return "TEST-7169122440478352-062213-d23fa9fb38e4b3e94feee29864f0fae2-443064294"
    }
}
