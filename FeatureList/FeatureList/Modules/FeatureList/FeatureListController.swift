//
//  FeatureListController.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

import UIKit
import MercadoPagoSDK

final class FeatureListController: UIViewController {
    //MARK: - Private properties
    private let viewModel = FeatureListViewModel()
    private lazy var customView = FeatureListView(delegate: self, dataSource: self)
    
    //MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feature List"
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
        case .payment: goToPaymentFlow()
        case .requestMoney: print("User did tap on requestMoney feature")
        }
    }
}

extension FeatureListController {
    private func goToPaymentFlow() {
        guard let navigationController = navigationController else { return }
        // Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(), preferenceId: viewModel.getPreferenceId()).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()
        
        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())
        
        // Add custom translations (px_custom_texts)
        builder.addCustomTranslation(.pay_button, withTranslation: "Pagar custom")
        builder.addCustomTranslation(.pay_button_progress, withTranslation: "Pagando custom...")
        builder.addCustomTranslation(.total_to_pay_onetap, withTranslation: "Total a pagar custom")

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController)
    }
}
