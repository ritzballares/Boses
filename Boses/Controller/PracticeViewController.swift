//
//  PracticeViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/11/21.
//

import UIKit
import AVKit
import Vision

class PracticeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var letter: Letter?
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAV()
    }
    
    func setUpAV() {
        // configure the camera to use for capture
        let session = AVCaptureSession()
        
        // set device and session resolution
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice!) else {
            print("Could not create video device input")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        // add video input to session
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        
        session.addInput(deviceInput)
        
        // add video output to session
        let videoDataOutput = AVCaptureVideoDataOutput()
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        // process every frame, but don't hold on to more than one Vision request at a time
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        var bufferSize: CGSize = .zero
        
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        session.commitConfiguration()
        session.startRunning()
        
        // set up preview layer
        var previewLayer: AVCaptureVideoPreviewLayer! = nil
        var rootLayer: CALayer! = nil
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let model = try? ASLDetector(configuration: MLModelConfiguration()),
              let visionModel = try? VNCoreMLModel(for: model.model) else {
            print("Could not load model")
            return
        }
        
        let objectRecognition = VNCoreMLRequest(model: visionModel) { (req, err) in
            DispatchQueue.main.async(execute: {
                if let results = req.results {
                    for observation in results where observation is VNRecognizedObjectObservation {
                        guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
                        let topLabelObservation = objectObservation.labels[0]
                        print(topLabelObservation)
                    }
                }
            })
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        do {
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([objectRecognition])
        } catch {
            print("Something happened with the image request handler")
            return
        }
    }
}
