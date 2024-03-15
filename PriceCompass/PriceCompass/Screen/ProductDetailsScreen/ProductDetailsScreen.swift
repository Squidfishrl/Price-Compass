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
        VStack {
            List {
                Section {
                    HStack(spacing: Constants.Spacing.spacing200) {
                        ProductImage(imageUrl: product.imageUrl, size: 120)
                        VStack(alignment: .leading, spacing: Constants.Spacing.spacing100) {
                            Text("Brand: \(product.brand)")
                                .font(.title2)
                            Text("Category: \(product.category)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(sectionedPrices, id: \.0) { date in
                    section(for: date)
                }
            }
        }
        .navigationTitle(product.name)
    }

    private var sectionedPrices: [(String, [ProductPrice])] {
        var result: [(String, [ProductPrice])] = []
        product.prices.sorted { $0.date > $1.date }.forEach { details in
            let date = details.date.formatted(date: .numeric, time: .omitted)
            if let index = result.firstIndex(where: { $0.0 == date }) {
                result[index].1.append(details)
            } else {
                result.append((date, [details]))
            }
        }
        return result
    }

    private func section(for data: (String, [ProductPrice])) -> some View {
        let (date, prices) = data
        return Section(date) {
            ForEach(prices) { details in
                NavigationLink(value: NavigationRoute.Destination.analytics(url: "")) {
                    HStack {
                        Text(details.store)
                        Spacer()
                        Text(String(format: "%.2f", details.price))
                    }
                    .padding(.trailing, Constants.Spacing.spacing100)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailsScreen(product: ProductModel(brand: "Brand",
                                                   name: "Name",
                                                   category: "Category",
                                                   imageUrl: "",
                                                   prices: [ProductPrice(store: "Store",
                                                                         price: 10.55,
                                                                         date: .now)]))
    }
}
