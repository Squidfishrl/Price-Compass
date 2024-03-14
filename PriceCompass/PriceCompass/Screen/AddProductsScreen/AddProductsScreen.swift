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
    @State private var showErrorAlert = false
    @State private var showScanner = false
    @State private var data: [String] = []

    var body: some View {
        if [.authorized, .notDetermined].contains(cameraAccess) {
            content
        } else {
            noPermissionsPlaceholder
        }
    }

    private var content: some View {
        List {
            ForEach(data, id: \.self) { data in
                Text(data)
            }
            .onDelete { indexSet in
                data.remove(atOffsets: indexSet)
            }
        }
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
                    if success.string.isEmpty { return }
                    data.append(success.string)
                } else {
                    showErrorAlert = true
                }
                showScanner = false
            }
            .scaledToFill()
        }
        .alert("There was a problem with the scanning process...", isPresented: $showErrorAlert) {}
    }

    private var noPermissionsPlaceholder: some View {
        VStack(spacing: 16) {
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
}

#Preview {
    NavigationStack {
        AddProductsScreen()
    }
}

extension AVMediaType: CaseIterable {
    static public var allCases: [AVMediaType] {
        [.audio, .metadataObject, .video]
    }
}
