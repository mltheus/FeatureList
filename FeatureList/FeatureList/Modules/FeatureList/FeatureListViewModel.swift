//
//  FeatureListViewModel.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

final class FeatureListViewModel {
    //MARK: - Private properties
    private let dataSource: [FeatureListModel] = [
        FeatureListModel(featureName: "Checkout: Standard", requirements: nil, feature: .standardCheckout),
        FeatureListModel(featureName: "Checkout: Processadora custom", requirements: nil, feature: .customProcesadora),
        FeatureListModel(featureName: "Checkout: Builder custom", requirements: nil, feature: .customBuilder),
        FeatureListModel(featureName: "Checkout: With charges", requirements: "(There is a requirement)", feature: .withCharges),
        FeatureListModel(featureName: "Checkout: With charges and alert", requirements: "(There is a requirement)", feature: .chargesWithAlert),
        FeatureListModel(featureName: "Checkout: No charges", requirements: "(There is a requirement)", feature: .noCharges),
        FeatureListModel(featureName: "Checkout with parameters", requirements: nil, feature: .withParameters),
        FeatureListModel(featureName: "Payment feedback message", requirements: nil, feature: .paymentFeedback)
        
    ]
    
    private let userProfiles: [PickerUserProfileModel] = [
        PickerUserProfileModel(userProfile: "Nome user",
                               publicKey: "",
                               privateKey: ""),
        PickerUserProfileModel(userProfile: "Standard user",
                               publicKey: "",
                               privateKey: "")
    ]
    
    private var profileIndex = 0
    
    //MARK: - Public methods
    func getNumberOfCells() -> Int {
        return dataSource.count
    }
    
    func getFeatureInfos(index: Int) -> (String, String?) {
        return (dataSource[index].featureName, dataSource[index].requirements)
    }
    
    func getFeature(index: Int) -> Feature {
        return dataSource[index].feature
    }
    
    func getUserProfiles() -> [PickerUserProfileModel] {
        return userProfiles
    }
    
    func getCurrentUser() -> String {
        return userProfiles[profileIndex].userProfile
    }
    
    func updateProfileIndex(index: Int) {
        profileIndex = index
    }
    
    //TODO: Create a credentials file to add the information bellow and add to gitignore
    func getPreferenceId() -> String {
        return ""
    }
    
    func getPublicKey() -> String {
        return userProfiles[profileIndex].publicKey
    }
    
    func getPrivateKey() -> String {
        return userProfiles[profileIndex].privateKey
    }
}
