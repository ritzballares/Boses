//
//  PracticeViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/11/21.
//

import UIKit
import AVKit

class PracticeViewController: UIViewController {
    var letter: Letter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAV()
    }
    
    func setUpAV() {
        let session = AVCaptureSession()
        
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
        
        
    }
}
