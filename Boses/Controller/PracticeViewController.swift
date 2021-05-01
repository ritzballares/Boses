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
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ASLImageClassifier().model)

            let request = VNCoreMLRequest(model: model) { (req, err) in
                self.processClassifications(for: req, error: err)
            }
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let practiceButton = UIBarButtonItem(title: "Retry", style: .plain, target: self, action: #selector(self.resetCamera))
        navigationItem.rightBarButtonItem = practiceButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1641500294, green: 0.4532442689, blue: 0.7059374452, alpha: 1)
        
        setUpCamera()
    }
    
    func setUpCamera() {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .camera
        imgPicker.cameraDevice = .rear
        imgPicker.allowsEditing = false
        imgPicker.delegate = self
        present(imgPicker, animated: true)
    }
    
    @objc func resetCamera() {
        self.rightOrWrongLabel.text = ""
        setUpCamera()
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
        var attemptIsRight: Bool = false
        
        DispatchQueue.main.async {
            if let results = request.results {
                let classifications = results as! [VNClassificationObservation]
                
                if classifications.isEmpty {
                    self.rightOrWrongLabel.text = "Nothing recognized"
                } else {
                    if classifications.first?.identifier == self.letter?.getLetter() {
                        attemptIsRight = true
                    }
                }
                
                if attemptIsRight {
                    self.rightOrWrongLabel.text = "✅"
                } else {
                    self.rightOrWrongLabel.text = "❌"
                }
            }
        }
    }
}
