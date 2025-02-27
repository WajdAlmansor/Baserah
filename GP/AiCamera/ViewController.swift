import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    class CameraView: UIView {
        
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }

        var session: AVCaptureSession? {
            get {
                (layer as! AVCaptureVideoPreviewLayer).session
            }
            set {
                let previewLayer = layer as! AVCaptureVideoPreviewLayer
                previewLayer.session = newValue
                previewLayer.videoGravity = .resizeAspectFill
            }
        }
    }

    var session: AVCaptureSession

    func makeUIView(context: Context) -> CameraView {
        let cameraView = CameraView()
        cameraView.session = session
        return cameraView
    }

    func updateUIView(_ uiView: CameraView, context: Context) {
        uiView.session = session
    }
}

import AVFoundation
import Vision
import Combine

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var detectionRequest: VNCoreMLRequest?
    private let speechSynthesizer = AVSpeechSynthesizer()

    @Published var detectedObject: String = "Detecting..." {
        didSet {
            speak(detectedObject)
        }
    }
    private var isLocked: Bool = false

    override init() {
        super.init()
        setupSession()
        setupObjectDetection()
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Error: Unable to access the camera.")
            return
        }

        guard session.canAddInput(videoInput) else { return }
        session.addInput(videoInput)

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        guard session.canAddOutput(videoOutput) else { return }
        session.addOutput(videoOutput)

        session.commitConfiguration()
    }

    private func setupObjectDetection() {
        do {
            let coreMLModel = try Resnet50(configuration: MLModelConfiguration()).model
            let visionModel = try VNCoreMLModel(for: coreMLModel)

            detectionRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleDetection)
            print("ResNet50 object detection setup complete.")
        } catch {
            print("Error loading ResNet50 Core ML model: \(error.localizedDescription)")
        }
    }

    private func handleDetection(request: VNRequest, error: Error?) {
        guard !isLocked,
              let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            return
        }

        DispatchQueue.main.async {
            self.detectedObject = topResult.identifier
            self.isLocked = true
        }
    }

    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func resetDetection() {
        DispatchQueue.main.async {
            self.isLocked = false
            self.detectedObject = "Detecting..."
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let detectionRequest = detectionRequest else {
            return
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Error performing Vision request: \(error.localizedDescription)")
        }
    }
}
