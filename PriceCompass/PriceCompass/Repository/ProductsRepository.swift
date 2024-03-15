//
//  ProductsRepository.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import Foundation

protocol ProductsRepository {
    func getProduct(with ean: String) async throws -> ProductModel
    func getProducts() async throws -> [ProductModel]
    func save(products: [ProductModel]) async throws
}

final class ProductsManager: ProductsRepository, ObservableObject {
    private let productsProvider: ProductsProvidable

    init(productsProvider: ProductsProvidable = ProductsProvider()) {
        self.productsProvider = productsProvider
    }

    func getProduct(with ean: String) async throws -> ProductModel {
        do {
            let productMetadata = try await productsProvider.getProduct(with: ean)
            return ProductModel(id: productMetadata.ean,
                                brand: productMetadata.brand,
                                name: productMetadata.name,
                                category: productMetadata.category,
                                imageUrl: productMetadata.imageUrl,
                                prices: [])
        } catch {
            throw RequestFailure()
        }
    }

    func getProducts() async throws -> [ProductModel] {
        do {
            return try await productsProvider.getProducts().map { productData in
                let prices = (productData.stores ?? [:]).map { store, priceInfo in
                    ProductPrice(store: store, price: priceInfo.price, date: priceInfo.date)
                }
                return ProductModel(id: productData.ean,
                                    brand: productData.brand,
                                    name: productData.name,
                                    category: productData.category,
                                    imageUrl: productData.imageUrl,
                                    prices: prices)
            }
        } catch {
            throw RequestFailure()
        }
    }

    func save(products: [ProductModel]) async throws {
        do {
            try await productsProvider.save(products: products.compactMap { product in
                guard let priceInfo = product.prices.first else { return nil }
                return PriceDto(ean: product.id, price: priceInfo.price, store: priceInfo.store, date: priceInfo.date)
            })
        } catch {
            throw RequestFailure()
        }
    }
}

extension ProductsManager {
    struct RequestFailure: Error {}
}
