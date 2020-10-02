//
//  CreatorCell.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/30/20.
//

import UIKit

class CreatorCell: UITableViewCell {

    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var comicsLabel: UILabel!
    
    func setVariables(creator: Creator){
        creatorName.text = creator.name
        creatorImage.image = creator.image

        comicsLabel.text = "\(creator.numOfComics) COMICS WRITTEN"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
