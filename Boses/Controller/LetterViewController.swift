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
        self.title = letter?.getLetter()
        letterImgView.image = letter?.getLetterImage()
        
        let practiceButton = UIBarButtonItem(title: "Practice", style: .plain, target: self, action: #selector(self.practiceButtonPressed))
        navigationItem.rightBarButtonItem = practiceButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1641500294, green: 0.4532442689, blue: 0.7059374452, alpha: 1)
    }

    @objc func practiceButtonPressed() {
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
