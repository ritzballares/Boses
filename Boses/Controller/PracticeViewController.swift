//
//  PracticeViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/11/21.
//

import UIKit
import CoreML
import Vision

class PracticeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var letter: Letter?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rightOrWrongLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ASLDetector().model)

            let request = VNCoreMLRequest(model: model) { (req, err) in
                self.processClassifications(for: req, error: err)
            }
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load model: \(error)")
        }
    }()
    
    func setUpCamera() {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .camera
        imgPicker.cameraDevice = .front
        imgPicker.allowsEditing = false
        imgPicker.delegate = self
        present(imgPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
            
        }
        
        imageView.image = image
        updateClassifications(for: image)
    }
    
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification \(error)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                for observation in results where observation is VNRecognizedObjectObservation {
                    guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
                    let topLabelObservation = objectObservation.labels[0]
                    
                    if topLabelObservation.identifier == self.letter?.getLetter() {
                        self.rightOrWrongLabel.text = "✅"
                    } else {
                        self.rightOrWrongLabel.text = "❌"
                    }
                
                }
            }
        }
    }
}
