//
//  Classes.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/27/20.
//

import Foundation
import UIKit

class Character {
    
    init(newId: Int, newName: String, urlImage: String, newDesc: String, url: String) {
        id = newId
        name = newName
        description = newDesc
        infoURL = url

        let url = URL(string: urlImage)!
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "ImageNotFound")!
        }
        
    }
    
    var id: Int
    var name: String
    var image: UIImage
    var description: String
    var infoURL: String
    

}

class Comic {
    
    init(newId: Int, newTitle: String, urlImage: String, newDesc: String, urlI: String, urlV: String, creators: [String], characters: [String]) {
        id = newId
        title = newTitle
        description = newDesc
        infoURL = urlI
        viewURL = urlV
        self.creators = creators
        self.characters = characters
        
        let url = URL(string: urlImage)!
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "ImageNotFound")!
        }
        
    }
    
    var id: Int
    var title: String
    var image: UIImage
    var description: String
    var infoURL: String
    var viewURL: String
    var creators = [String]()
    var characters = [String]()
}

class Creator {
    
    init(newId: Int, newName: String, urlImage: String, infoURL: String, comics: Int) {
        id = newId
        name = newName
        moreInfoURL = infoURL
        numOfComics = comics

        
        let url = URL(string: urlImage)!
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "ImageNotFound")!
        }
    }
    
    var id: Int
    var name: String
    var image: UIImage
    var moreInfoURL: String
    var numOfComics: Int

}
