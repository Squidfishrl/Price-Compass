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
        .padding(.vertical, 8)
        .padding(.horizontal, 40)
        .bold()
        .foregroundStyle(.white)
        .background(.blue)
        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 20,
                                                                            bottomLeading: 8,
                                                                            bottomTrailing: 20,
                                                                            topTrailing: 8)))
    }
}

#Preview {
    ActionButton(text: "Click me") {
        print("Clicked")
    }
}
