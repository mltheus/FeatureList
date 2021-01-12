//
//  AppDelegate.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let featureListController = FeatureListController()
        let featureList = featureListController
        window!.rootViewController = UINavigationController(rootViewController: featureList)
        window!.makeKeyAndVisible()
        return true
    }
}

