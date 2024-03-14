//
//  ProductImage.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import SwiftUI

struct ProductImage: View {
    let imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl))
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ProductImage(imageUrl: "")
}
