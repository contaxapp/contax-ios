//
//  CameraScanner.swift
//  Contax
//
//  Created by Arpit Bansal on 26/11/22.
//

import SwiftUI
import VisionKit

struct CameraScannerViewController: UIViewControllerRepresentable {
    
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true)
        
        viewController.delegate = context.coordinator

        return viewController
    }
    
    func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
        if startScanning {
            try? viewController.startScanning()
        } else {
            viewController.stopScanning()
        }
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: CameraScannerViewController
        init(_ parent: CameraScannerViewController) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.scanResult = text.transcript
            default:
                break
            }
        }
    }
}

struct CameraScanner: View {
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            CameraScannerViewController(startScanning: $startScanning, scanResult: $scanResult)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
    }
}

struct CameraScanner_Previews: PreviewProvider {
    static var previews: some View {
        CameraScanner()
    }
}
