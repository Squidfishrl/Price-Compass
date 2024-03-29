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
            return ProductModel(id: productMetadata.ean13,
                                brand: productMetadata.brand ?? "No brand",
                                name: productMetadata.name,
                                category: productMetadata.category ?? "No category",
                                imageUrl: productMetadata.imageUrl,
                                prices: [])
        } catch {
            throw RequestFailure()
        }
    }

    func getProducts() async throws -> [ProductModel] {
        do {
            return try await productsProvider.getProducts().map { productData in
                var prices: [ProductPrice] = []
                for (store, priceEntries) in productData.stores ?? [:] {
                    priceEntries.forEach { priceInfo in
                        prices.append(ProductPrice(store: store, price: priceInfo.price, date: priceInfo.date))
                    }
                }
                return ProductModel(id: productData.ean13,
                                    brand: productData.brand ?? "No brand",
                                    name: productData.name,
                                    category: productData.category ?? "No category",
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
