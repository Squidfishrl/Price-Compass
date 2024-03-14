//
//  TabViewDestination.swift
//  Culinary Chronicles
//
//  Created by Stanislav Ivanov on 11.02.24.
//

import SwiftUI

extension View {
    func tabViewDestination(_ tab: NavigationTab) -> some View {
        modifier(TabViewDestination(tab: tab))
    }
}

struct TabViewDestination: ViewModifier {
    let tab: NavigationTab

    func body(content: Content) -> some View {
        content
            .tabItem {
                Label(tab.name, systemImage: tab.iconName)
            }
            .tag(tab)
    }
}
