//
//  CharacterCell.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/25/20.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterTitle: UILabel!
    
    func setVariables(character: Character) {
        characterImage.image = character.image
        characterTitle.text = character.name
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
