//
//  ScanCardView.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/23.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision

struct HostedCameraViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct ScanCardView: View {
    var body: some View {
        HostedCameraViewController().ignoresSafeArea()
    }
}
