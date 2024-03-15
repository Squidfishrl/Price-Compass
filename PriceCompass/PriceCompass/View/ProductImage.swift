//
//  ProductImage.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import SwiftUI

struct ProductImage: View {
    let imageUrl: String
    private(set) var size = 50.0

    var body: some View {
        AsyncImage(url: URL(string: imageUrl))
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Size.cornerRadiusMedium))
    }
}

#Preview {
    ProductImage(imageUrl: "")
}
