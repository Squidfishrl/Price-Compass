//
//  PriceCompassApp.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import Foundation

final class NavigationRoute: ObservableObject {
    @Published var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }

    func popToRoot() {
        path.removeAll()
    }
}
