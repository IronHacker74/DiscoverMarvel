//
//  CharactersScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/25/20.
//

import Foundation
import UIKit
import SwiftyJSON

class CharactersScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    var characters = [Character]()
    var character: Character!
    var inSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        showActivityIndicator()

        downloadCharacters(filterCharacters: "", offsetNum: 0, completion: {result in
            if result == true {
                print("Characters Downloaded Successfully")
            }
        })

    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charCell", for: indexPath) as? CharacterCell {
            
            cell.setVariables(character: characters[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        character = characters[indexPath.row]
        
        self.performSegue(withIdentifier: "segueToCharacter", sender: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == characters.count - 9 {
            var charFil = ""
            if searchBar.text != nil || searchBar.text != "" {
                charFil = searchBar.text!
            }
            
            self.showActivityIndicator()
            downloadCharacters(filterCharacters: charFil, offsetNum: characters.count, completion: {result in
                if result == true {
                    print("Characters Downloaded Successfully")
                    return
                }
            })
        }
        
    }
    
    //MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        characters.removeAll()
        self.collectionView.reloadData()
        showActivityIndicator()
        
        downloadCharacters(filterCharacters: "", offsetNum: 0, completion: {result in
            if result == true {
                print("20 characters downloaded successfully")
                return
            }
        })
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        characters.removeAll()
        
        self.collectionView.reloadData()
        showActivityIndicator()
        
        downloadCharacters(filterCharacters: searchBar.text!, offsetNum: characters.count, completion: {result in
            if result == true {
                print("20 characters downloaded successfully")
                return
            }
        })
    }
    
    //MARK: - DOWNLOADING DATA
    
    func downloadCharacters(filterCharacters: String, offsetNum: Int, completion: @escaping (Bool) -> ()) {
        downloadAllCharacters(filter: filterCharacters, offset: offsetNum, completion: {jsonData in
                        
            if jsonData == JSON() {
                print("JSON data is empty")
                completion(false)
            } else {
                print("JSON data downloaded")
            }

            let numOfResults = jsonData["data"]["count"].int!
            
            if numOfResults == 0 {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                completion(false)
                return
            }
            
            for i in 0...numOfResults-1 {
                let id = jsonData["data"]["results"][i]["id"].int!
                let name = jsonData["data"]["results"][i]["name"].string!
                let imagePath = jsonData["data"]["results"][i]["thumbnail"]["path"].string!
                let imageExt = jsonData["data"]["results"][i]["thumbnail"]["extension"].string!
                let imageURL = imagePath + "." + imageExt
                let description = jsonData["data"]["results"][i]["description"].string!
                
                var infoURL = "https://marvel.com"
                if let urlI = jsonData["data"]["results"][i]["urls"][1]["url"].string {
                    infoURL = urlI
                }
                                
                let newCharacter = Character.init(newId: id, newName: name, urlImage: imageURL, newDesc: description, url: infoURL)
                self.characters.append(newCharacter)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            completion(true)
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCharacter" {
            let destVC = segue.destination as? CharDetailsScreen
            destVC?.character = character
        }
    }
    
    //MARK: - ACTIVITY INDICATOR
    
    func showActivityIndicator(){
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .black
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
}
