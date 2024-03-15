//
//  ProductModel.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import Foundation

struct ProductModel: Identifiable, Hashable {
    let id: String
    let brand: String
    let name: String
    let category: String
    let imageUrl: String
    var prices: [ProductPrice]
}

struct ProductPrice: Identifiable, Hashable {
    let id = UUID()
    let store: String
    let price: Double
    let date: Date
}
