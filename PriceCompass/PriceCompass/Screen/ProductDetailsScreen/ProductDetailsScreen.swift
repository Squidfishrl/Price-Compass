//
//  ProductDetailsScreen.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import SwiftUI

struct ProductDetailsScreen: View {
    let product: ProductModel

    var body: some View {
        ProductImage(imageUrl: product.imageUrl)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProductDetailsScreen(product: ProductModel(brand: "Brand",
                                               name: "Name",
                                               category: "Category",
                                               imageUrl: "",
                                               prices: [ProductPrice(store: "Store",
                                                                     price: 10.55,
                                                                     date: .now)]))
}
