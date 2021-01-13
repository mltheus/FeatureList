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
        case .standardCheckout: goToStandardCheckoutFlow()
        case .customProcesadora: goToCustomProcesadoraFlow()
        case .customBuilder: goToCustomBuilderFlow()
        case .withCharges: goToCheckoutWithChargesFlow()
        case .chargesWithAlert: goToCheckoutWithAlert()
        case .noCharges: goToZeroChargesFlow()
        }
    }
}

extension FeatureListController {
    private func goToStandardCheckoutFlow() {
        guard let navigationController = navigationController else { return }
        // Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(), preferenceId: viewModel.getPreferenceId()).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()
        
        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
    
    //Check if this flow is used nowadays
    private func goToCustomProcesadoraFlow() {
        guard let navigationController = navigationController else { return }
        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()

        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
//         Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(),
                                                 preferenceId: viewModel.getPreferenceId(),
                                                 paymentConfiguration: paymentConfiguration).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()
        
        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
    
    //TODO: Customizations arent work, check this out
    private func goToCustomBuilderFlow() {
        guard let navigationController = navigationController else { return }
        // Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(), preferenceId: viewModel.getPreferenceId()).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()

        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())
        builder.addCustomTranslation(.pay_button, withTranslation: "Pay button custom")
        builder.addCustomTranslation(.pay_button_progress, withTranslation: "loading...")
        builder.addCustomTranslation(.total_to_pay_onetap, withTranslation: "One tap payment")


        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
    
    //Checkout why it is not working
    private func goToCheckoutWithChargesFlow() {
        guard let navigationController = navigationController else { return }
        // Create charge rules
        var pxPaymentTypeChargeRules : [PXPaymentTypeChargeRule] = []
        pxPaymentTypeChargeRules.append(PXPaymentTypeChargeRule.init(paymentTypeId: PXPaymentTypes.DEBIT_CARD.rawValue, amountCharge: 10.00 ))
        // Create an instance of your custom payment processor
        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
            
        // Create a payment configuration instance using the recently created payment processor
        var paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
              
        // Add charge rules
        paymentConfiguration = paymentConfiguration.addChargeRules(charges: pxPaymentTypeChargeRules)
        
        // Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(),
                                                 preferenceId: viewModel.getPreferenceId(),
                                                 paymentConfiguration: paymentConfiguration).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()

        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
    
    private func goToCheckoutWithAlert() {
        guard let navigationController = navigationController else { return }
        
        var pxPaymentTypeChargeRules : [PXPaymentTypeChargeRule] = []
        
        let alert = UIAlertController(title: "Charges detail", message: "Charges description", preferredStyle: .alert)
        
        pxPaymentTypeChargeRules.append(PXPaymentTypeChargeRule(paymentTypeId: PXPaymentTypes.CREDIT_CARD.rawValue, amountCharge: 15.00, detailModal: alert))
        
        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
        
        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
        
        _ = paymentConfiguration.addChargeRules(charges: pxPaymentTypeChargeRules)

        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(),
                                                 preferenceId: viewModel.getPreferenceId(),
                                                 paymentConfiguration: paymentConfiguration).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()

        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
    
    //Visual bugs to be solved
    private func goToZeroChargesFlow() {
        guard let navigationController = navigationController else { return }
        
        var pxPaymentTypeChargeRules : [PXPaymentTypeChargeRule] = []
         
        // Free charge rule
        pxPaymentTypeChargeRules.append(PXPaymentTypeChargeRule.init(paymentTypeId: PXPaymentTypes.CREDIT_CARD.rawValue, message: "No charges for you"))
        
        let paymentProcessor : PXPaymentProcessor = CustomPaymentProcessor()
        
        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentProcessor)
        
        _ = paymentConfiguration.addChargeRules(charges: pxPaymentTypeChargeRules)
        
        let builder = MercadoPagoCheckoutBuilder(publicKey: viewModel.getPublicKey(),
                                                 preferenceId: viewModel.getPreferenceId(),
                                                 paymentConfiguration: paymentConfiguration).setLanguage("pt-BR")
        
        let configuration = PXAdvancedConfiguration()

        builder.setAdvancedConfiguration(config: configuration)
        
        // Set the payer private key
        builder.setPrivateKey(key: viewModel.getPrivateKey())

        // Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)

        // Start with your navigation controller.
        checkout.start(navigationController: navigationController, lifeCycleProtocol: self)
    }
}

//MARK: - namePXLifeCycleProtocol (OPTIONAL)
extension FeatureListController: PXLifeCycleProtocol {
    func finishCheckout() -> ((PXResult?) -> Void)? {
        return nil
    }

    func cancelCheckout() -> (() -> Void)? {
        return nil
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            print("px - changePaymentMethodTapped")
        }
    }
}
