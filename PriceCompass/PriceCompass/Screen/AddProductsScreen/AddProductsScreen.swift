//
//  AddProductsScreen.swift
//  PriceCompass
//
//  Created by Stanislav Ivanov on 14.03.24.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct AddProductsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showErrorAlert = false
    @State private var showScanner = false
    @State private var products: [ProductModel] = [ProductModel(brand: "brand", name: "name", category: "category", imageUrl: "", prices: [])]
    @State private var prices: [String] = [""]
    @State private var storeName = ""
    private let productsUploadDate: Date = .now

    var body: some View {
        if [.authorized, .notDetermined].contains(cameraAccess) {
            content
        } else {
            noPermissionsPlaceholder
        }
    }

    private var content: some View {
        VStack {
            List {
                ForEach(products.indices, id: \.self) { index in
                    HStack {
                        ProductListItem(product: products[index])
                        Spacer()
                        TextField("Price", text: $prices[index])
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 60)
                            .padding([.horizontal, .vertical], Constants.Spacing.spacing100)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                                    .foregroundStyle(.secondary)
                            }
                    }
                }
                .onDelete { indexSet in
                    products.remove(atOffsets: indexSet)
                }
            }
            HStack(spacing: Constants.Spacing.spacing500) {
                TextField("Store", text: $storeName)
                    .padding([.horizontal, .vertical], Constants.Spacing.spacing100)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(.secondary)
                    }
                ActionButton(text: "Submit") {
                    // TODO: map prices and call post endpoint
                    dismiss()
                }
            }
            .padding(.horizontal, Constants.Spacing.spacing300)
        }
        .padding(.bottom, Constants.Spacing.spacing100)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }
        }
        .sheet(isPresented: $showScanner) {
            CodeScannerView(codeTypes: [.ean13, .qr]) { result in
                if case let .success(success) = result {
                    products.append(product(from: success.string))
                    prices.append("0")
                } else {
                    showErrorAlert = true
                }
                showScanner = false
            }
            .scaledToFill()
        }
        .alert("There was a problem with the scanning process...", isPresented: $showErrorAlert) {}
        .navigationTitle("Add Products")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var noPermissionsPlaceholder: some View {
        VStack(spacing: Constants.Spacing.spacing200) {
            Text("It seems you have denied the access to the camera! We cannot scan the products without it!")
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                Button("Open Settings to allow camera access!") {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }
        .padding(.horizontal)
    }

    private var cameraAccess: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    private func product(from ean: String) -> ProductModel {
        ProductModel(brand: "", name: "", category: "", imageUrl: "", prices: [])
    }
}

#Preview {
    NavigationStack {
        AddProductsScreen()
    }
}
