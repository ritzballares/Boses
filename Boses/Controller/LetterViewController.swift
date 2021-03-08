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
    }
    
}
