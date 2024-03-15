//
//  PriceCompassApp.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import Foundation

enum NavigationTab {
    case home
    case addProducts

    var name: String {
        switch self {
        case .addProducts:
            "Add products"
        default:
            String(describing: self).capitalized
        }
    }

    var iconName: String {
        switch self {
        case .home:
            "house.fill"
        case .addProducts:
            "qrcode"
        }
    }
}
