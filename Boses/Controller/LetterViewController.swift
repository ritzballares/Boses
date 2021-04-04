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
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9781288505, green: 0.9683626294, blue: 0.9683561921, alpha: 1)
        
        let practiceButton = UIBarButtonItem(title: "Practice", style: .plain, target: self, action: #selector(self.practiceButtonPressed))
        
        navigationItem.rightBarButtonItem = practiceButton
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
