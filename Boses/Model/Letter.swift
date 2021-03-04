//
//  Letter.swift
//  Boses
//
//  Created by Ritz Ballares on 3/4/21.
//

import Foundation

struct Letter {
    let letterImages: [UIImage] = [#imageLiteral(resourceName: "a.jpg"), #imageLiteral(resourceName: "b.jpg"), #imageLiteral(resourceName: "c.jpg"), #imageLiteral(resourceName: "d.jpg"), #imageLiteral(resourceName: "e.jpg"), #imageLiteral(resourceName: "f.jpg"), #imageLiteral(resourceName: "g.jpg"), #imageLiteral(resourceName: "h.jpg"), #imageLiteral(resourceName: "i.jpg"), #imageLiteral(resourceName: "j.jpg"), #imageLiteral(resourceName: "k.jpg"), #imageLiteral(resourceName: "l.jpg"), #imageLiteral(resourceName: "m.jpg"), #imageLiteral(resourceName: "n.jpg"), #imageLiteral(resourceName: "o.jpg"), #imageLiteral(resourceName: "p.jpg"), #imageLiteral(resourceName: "q.jpg"), #imageLiteral(resourceName: "r.jpg"), #imageLiteral(resourceName: "s.jpg"), #imageLiteral(resourceName: "t.jpg"), #imageLiteral(resourceName: "u.jpg"), #imageLiteral(resourceName: "v.jpg"), #imageLiteral(resourceName: "w.jpg"), #imageLiteral(resourceName: "x.jpg"), #imageLiteral(resourceName: "y.jpg"), #imageLiteral(resourceName: "z.jpg")]
    let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    let letterImage: UIImage
    let letter: String
    
    init(letterNum: Int) {
        letterImage = letterImages[letterNum]
        letter = letters[letterNum]
    }
    
    func getLetterImage() -> UIImage {
        return letterImage
    }
    
    func getLetter() -> String {
        return letter
    }
    
}
