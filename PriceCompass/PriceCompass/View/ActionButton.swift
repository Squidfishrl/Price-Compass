//
//  ActionButton.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 15.03.24.
//

import SwiftUI

struct ActionButton: View {
    let text: String
    let action: () async throws -> Void
    @State private var loading = false

    var body: some View {
        Button {
            Task {
                loading = true
                defer { loading = false }
                try await action()
            }
        } label: {
            ZStack {
                ProgressView()
                    .tint(.white)
                    .opacity(loading ? 1 : 0)
                Text(text)
                    .foregroundStyle(.white)
                    .opacity(loading ? 0 : 1)
            }
        }
        .padding(.vertical, Constants.Spacing.spacing100)
        .padding(.horizontal, Constants.Spacing.spacing500)
        .bold()
        .foregroundStyle(.white)
        .background(.blue)
        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: Constants.Size.cornerRadiusLarge,
                                                                            bottomLeading: Constants.Size.cornerRadiusSmall,
                                                                            bottomTrailing: Constants.Size.cornerRadiusLarge,
                                                                            topTrailing: Constants.Size.cornerRadiusSmall)))
    }
}

#Preview {
    ActionButton(text: "Click me") {
        print("Clicked")
    }
}
