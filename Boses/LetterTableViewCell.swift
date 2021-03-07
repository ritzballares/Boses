//
//  LetterTableViewCell.swift
//  Boses
//
//  Created by Ritz Ballares on 3/6/21.
//

import UIKit

class LetterTableViewCell: UITableViewCell {

    @IBOutlet weak var letterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
