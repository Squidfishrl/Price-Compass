//
//  HomeScreen.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var productsRepository: ProductsManager
    @State private var searchQuery = ""
    @State private var products: [ProductModel] = []

    var body: some View {
        List {
            ForEach(products) { product in
                NavigationLink(value: NavigationRoute.Destination.details(product: product)) {
                    ProductListItem(product: product)
                }
            }
        }
        .searchable(text: $searchQuery)
        .task {
            do {
                products = try await productsRepository.getProducts()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
