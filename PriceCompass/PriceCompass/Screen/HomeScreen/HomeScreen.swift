//
//  HomeScreen.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var navigationRoute: NavigationRoute
    @State private var searchQuery = ""
    @Binding private(set) var products: [ProductModel]

    var body: some View {
        List {
            ForEach(products) { product in
                ProductListItem(product: product)
                    .onTapGesture {
                        navigationRoute.path.append(.details)
                    }
            }
        }
        .searchable(text: $searchQuery)
    }
}

#Preview {
    HomeScreen(products: .constant([]))
}
