//
//  FeatureListModel.swift
//  FeatureList
//
//  Created by Matheus Leandro Martins on 12/01/21.
//

import Foundation

struct FeatureListModel {
    let featureName: String
    let feature: Feature
}

enum Feature {
    case payment
    case requestMoney
}
