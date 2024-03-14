//
//  PriceCompassApp.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

@main
struct PriceCompassApp: App {
    @State private var selectedTab: NavigationTab = .home

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeScreen(products: .constant([]))
                    .navigationStackRoot()
                    .tabViewDestination(.home)
                AddProductsScreen()
                    .navigationStackRoot()
                    .tabViewDestination(.addProducts)
            }
        }
    }
}
