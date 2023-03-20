//
//  ContactCardScanning.swift
//  Contax
//
//  Created by Arpit Bansal on 16/03/23.
//

import SwiftUI
import AVFoundation
import Vision
import TesseractOCR

struct ContactCardScanning: View {
    @State private var detectedBusinessCards: [CGRect] = []

    var body: some View {
        CameraView(detectedBusinessCards: $detectedBusinessCards)
            .ignoresSafeArea()
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var detectedBusinessCards: [CGRect]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraVC = CameraViewController()
        cameraVC.delegate = context.coordinator
        return cameraVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

            detectBusinessCards(in: pixelBuffer) { results in
                DispatchQueue.main.async {
                    self.parent.detectedBusinessCards = results.map { $0.boundingBox }

                    if let image = UIImage(pixelBuffer: pixelBuffer) {
                        processBusinessCards(results, from: image) { extractedTexts in
                            // Process the extracted texts here (e.g., use an NER model)
                            // print(extractedTexts)
                        }
                    }
                }
            }
        }
    }
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        startCamera()
    }

    func startCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
}

// Helper Functions
extension UIImage {
    convenience init?(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))) else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}

func detectBusinessCards(in pixelBuffer: CVPixelBuffer, completion: @escaping ([VNRectangleObservation]) -> Void) {
    let request = VNDetectRectanglesRequest { request, error in
        guard let results = request.results as? [VNRectangleObservation] else { return }
        completion(results)
    }
    request.minimumAspectRatio = VNAspectRatio(1.5)
    request.maximumAspectRatio = VNAspectRatio(2.5)

    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
    do {
        try handler.perform([request])
    } catch {
        print("Error performing business card detection: \(error)")
    }
}

func extractText(from image: UIImage, completion: @escaping (String) -> Void) {
//    let tessdataParentPath = Bundle.main.bundleURL.path
//    setenv("TESSDATA_PREFIX", tessdataParentPath, 1)
    
//    let tessdataPath = Bundle.main.bundleURL.appendingPathComponent("tessdata_best-main").path
//    print("TESSDATA_PATH: \(tessdataPath)")
//    setenv("TESSDATA_PREFIX", tessdataPath, 1)
    
//    let tesseract = G8Tesseract(language: "pan")
//    tesseract?.image = image
//    tesseract?.recognize()
    
    // 1
    if let tesseract = G8Tesseract(language: "eng") {
        // 2
        tesseract.engineMode = .tesseractCubeCombined
        // 3
        tesseract.pageSegmentationMode = .auto
        // 4
        tesseract.image = image
        // 5
        tesseract.recognize()

        if let recognizedText = tesseract.recognizedText {
            completion(recognizedText)
        } else {
            completion("")
        }
    }
}


func cropImage(_ image: UIImage, with observation: VNRectangleObservation) -> UIImage {
    let imageSize = image.size

    var transform = CGAffineTransform.identity
    transform = transform.scaledBy(x: imageSize.width, y: imageSize.height)

    let topLeft = observation.topLeft.applying(transform)
    let topRight = observation.topRight.applying(transform)
    let bottomLeft = observation.bottomLeft.applying(transform)
    let bottomRight = observation.bottomRight.applying(transform)

    let minX = min(topLeft.x, bottomLeft.x, topRight.x, bottomRight.x)
    let maxX = max(topLeft.x, bottomLeft.x, topRight.x, bottomRight.x)
    let minY = min(topLeft.y, bottomLeft.y, topRight.y, bottomRight.y)
    let maxY = max(topLeft.y, bottomLeft.y, topRight.y, bottomRight.y)

    let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    let imageRef = image.cgImage!.cropping(to: rect)!
    return UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
}

func processBusinessCards(_ observations: [VNRectangleObservation], from image: UIImage, completion: @escaping ([String]) -> Void) {
    var extractedTexts: [String] = []

    let group = DispatchGroup()
    for observation in observations {
        group.enter()

        let croppedImage = cropImage(image, with: observation)
        extractText(from: croppedImage) { text in
            extractedTexts.append(text)
            group.leave()
        }
    }

    group.notify(queue: .main) {
        completion(extractedTexts)
    }
}
