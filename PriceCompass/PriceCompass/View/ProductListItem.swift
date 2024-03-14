//
//  ProductListItem.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI

struct ProductListItem: View {
    let product: ProductModel

    var body: some View {
        HStack {
            ProductImage(imageUrl: product.imageUrl)
            VStack(alignment: .leading) {
                Text(productName)
                Text(product.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var productName: String {
        "\(product.name.capitalized) (\(product.brand.capitalized))"
    }
}

#Preview {
    ProductListItem(product: ProductModel(brand: "Brand",
                                          name: "Name",
                                          category: "Category",
                                          imageUrl: "",
                                          prices: [ProductPrice(store: "Store",
                                                                price: 14.73,
                                                                date: .now)]))
}
