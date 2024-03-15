//
//  ProductsProvider.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import Foundation

protocol ProductsProvidable {
    func getProduct(with ean: String) async throws -> ProductDto
    func getProducts() async throws -> [ProductDto]
    func save(products: [PriceDto]) async throws
}

final class ProductsProvider: ProductsProvidable {
    private let baseUrl = ""
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private let jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    func getProduct(with ean: String) async throws -> ProductDto {
        guard let request = URL(string: "\(baseUrl)/product/\(ean)") else {
            throw BadUrlError()
        }
        let (data, _) = try await URLSession.shared.data(from: request)
        return try jsonDecoder.decode(ProductDto.self, from: data)
    }

    func getProducts() async throws -> [ProductDto] {
        guard let request = URL(string: "\(baseUrl)/products") else {
            throw BadUrlError()
        }
        let (data, _) = try await URLSession.shared.data(from: request)
        return try jsonDecoder.decode([ProductDto].self, from: data)
    }

    func save(products: [PriceDto]) async throws {
        guard let url = URL(string: "\(baseUrl)/prices") else {
            throw BadUrlError()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try jsonEncoder.encode(products)
        _ = try await URLSession.shared.data(for: request)
    }
}

extension ProductsProvider {
    struct BadUrlError: Error {}
}
