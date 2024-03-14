//
//  NavigationStackRoot.swift
//  Culinary Chronicles
//
//  Created by Stanislav Ivanov on 11.02.24.
//

import SwiftUI

extension View {
    func navigationStackRoot() -> some View {
        modifier(NavigationStackRoot())
    }
}

struct NavigationStackRoot: ViewModifier {
    @StateObject private var navigationRoute = NavigationRoute()

    func body(content: Content) -> some View {
        NavigationStack(path: $navigationRoute.path) {
            content
                .navigationDestination(for: NavigationRoute.Destination.self) { destination in
                    destination.view
                }
        }
        .environmentObject(navigationRoute)
    }
}
