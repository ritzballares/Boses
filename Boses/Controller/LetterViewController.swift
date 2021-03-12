//
//  LetterViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/8/21.
//

import UIKit

class LetterViewController: UIViewController {
    
    @IBOutlet weak var letterImgView: UIImageView!
    var letter: Letter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterImgView.image = letter?.getLetterImage()
    }

    @IBAction func practiceButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPractice", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPractice" {
            if let practiceViewController = segue.destination as? PracticeViewController {
                if letter != nil {
                    practiceViewController.letter = self.letter
                }
            }
        }
    }
}
