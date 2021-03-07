//
//  LearnViewController.swift
//  Boses
//
//  Created by Ritz Ballares on 3/2/21.
//

import UIKit

class LearnViewController: UITableViewController {
    
    var letters: [Letter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        self.title = "ASL Alphabet"
        addLettersToArray()
    }
    
    func addLettersToArray() {
        let min = 0
        let max = 25
        
        for i in min...max {
            letters += [Letter(letterNum: i)]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LetterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LetterTableViewCell else {
            fatalError("The dequeued reusable cell is not an instance of \(cellIdentifier)")
        }
        
        let letter = letters[indexPath.row]
        
        cell.letterLabel.text = letter.getLetter()
        
        return cell
    }
    
}
