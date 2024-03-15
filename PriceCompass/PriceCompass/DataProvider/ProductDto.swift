//
//  ProductDto.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import Foundation

struct ProductDto: Codable {
    let ean: String
    let brand: String
    let name: String
    let category: String
    let imageUrl: String
    let stores: [String: ProductPriceDto]?
}

struct ProductPriceDto: Codable {
    let price: Double
    let date: Date
}

struct PriceDto: Codable {
    let ean: String
    let price: Double
    let store: String
    let date: Date
}
