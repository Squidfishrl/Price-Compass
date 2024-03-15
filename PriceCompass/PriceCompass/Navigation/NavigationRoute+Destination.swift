//
//  PriceCompassApp.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

extension NavigationRoute {
    enum Destination: Hashable {
        case analytics(for: String)
        case details(product: ProductModel)

        var view: some View {
            Group {
                switch self {
                case let .analytics(for: ean):
                    if let url = URL(string: "https://price-compass.onrender.com/analytic/\(ean)") {
                        WebView(url: url)
                    }
                case let .details(product: product):
                    ProductDetailsScreen(product: product)
                }
            }
        }
    }
}
