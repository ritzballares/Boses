//
//  ViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/2/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true  
    }

    @IBAction func learnButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLearn", sender: nil)
    }
    
}

