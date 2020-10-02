//
//  ComicCell.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/29/20.
//

import UIKit

class ComicCell: UITableViewCell {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicDescription: UITextView!
    
    func setVariables(comic: Comic) {
        comicTitle.text = comic.title
        comicImage.image = comic.image
        comicDescription.text = comic.description
        comicDescription.layer.cornerRadius = 5
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
