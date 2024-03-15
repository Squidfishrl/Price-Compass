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
    @EnvironmentObject private var productsRepository: ProductsManager
    @State private var showErrorAlert = false
    @State private var showScanner = false
    @State private var products: [ProductModel] = []
    @State private var prices: [String] = []
    @State private var storeName = ""
    private let productsUploadDate: Date = .now
    @FocusState private var focusedInputField

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
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: Constants.Size.width750)
                            .padding([.horizontal, .vertical], Constants.Spacing.spacing100)
                            .background {
                                RoundedRectangle(cornerRadius: Constants.Size.cornerRadiusMedium)
                                    .stroke()
                                    .foregroundStyle(.secondary)
                            }
                            .focused($focusedInputField, equals: true)
                    }
                }
                .onDelete { indexSet in
                    products.remove(atOffsets: indexSet)
                }
            }
            if !products.isEmpty {
                HStack(spacing: Constants.Spacing.spacing500) {
                    TextField("Store", text: $storeName)
                        .padding([.horizontal, .vertical], Constants.Spacing.spacing100)
                        .background {
                            RoundedRectangle(cornerRadius: Constants.Size.cornerRadiusMedium)
                                .stroke()
                                .foregroundStyle(.secondary)
                        }
                    ActionButton(text: "Submit") {
                        for index in products.indices {
                            products[index].prices.append(ProductPrice(store: storeName,
                                                                       price: Double(prices[index]) ?? -1,
                                                                       date: productsUploadDate))
                        }
                        try await productsRepository.save(products: products)
                    }
                }
                .padding(.horizontal, Constants.Spacing.spacing300)
            }
        }
        .padding(.bottom, Constants.Spacing.spacing100)
        .toolbar(products.isEmpty ? .visible : .hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    Task {
                        focusedInputField = false
                        try? await Task.sleep(for: .milliseconds(100))
                        reset()
                    }
                }
                .opacity(products.isEmpty ? 0 : 1)
                .disabled(products.isEmpty)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }
        }
        .animation(.easeInOut, value: products.isEmpty)
        .sheet(isPresented: $showScanner) {
            CodeScannerView(codeTypes: [.ean13, .qr]) { result in
                if case let .success(success) = result {
                    Task {
                        try await products.append(product(from: success.string))
                        prices.append("0")
                    }
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

    private func product(from ean: String) async throws -> ProductModel {
        try await productsRepository.getProduct(with: ean)
    }

    private func reset() {
        products = []
        prices = []
    }
}

#Preview {
    NavigationStack {
        AddProductsScreen()
    }
}
