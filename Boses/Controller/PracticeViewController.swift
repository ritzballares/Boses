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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAV()
    }
    
    func setUpAV() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        session.addInput(deviceInput)
        session.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(dataOutput)
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: ASLDetector().model) else {
            print("Error occured during initialization of CoreML model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (req, err) in
 
            if let results = req.results {
                for observation in results {
                    guard let obv = observation as? VNRecognizedObjectObservation else {return}
                    print(obv.labels[0])
                }
            }
            

        }
        
        do {
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        } catch {
            print("Something happened with the image request handler")
            return
        }
        
    }
}
