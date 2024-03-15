//
//  PriceCompassApp.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

extension NavigationRoute {
    enum Destination: Hashable {
        case analytics(url: String)
        case details(product: ProductModel)

        var view: some View {
            Group {
                switch self {
                case let .analytics(url: url):
                    if let url = URL(string: url) {
                        WebView(url: url)
                    }
                case let .details(product: product):
                    ProductDetailsScreen(product: product)
                }
            }
        }
    }
}
