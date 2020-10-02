//
//  ComicsScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/29/20.
//

import UIKit
import SwiftyJSON

class ComicsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    var comics = [Comic]()
    var comic: Comic!
    var personType: Bool!
    var personName: String!
    var personId: Int!
    var inSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarBtn = UIBarButtonItem.init(image: UIImage(named: "homeLogo"), style: .plain, target: self, action: #selector(self.returnToHome))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        showActivityIndicator()
        
        // personType is true if a character and false if a creator
        if personType {
            self.navigationItem.title = "\(personName!) Comics"
        } else {
            self.navigationItem.title = "Comics Written by \(personName!)"
        }
        
        downloadComics(filterComics: "", offsetNum: 0, completion: {result in
            if result == true {
                print("Comics Downloaded Scucessfully")
            }
        })
        
    }

    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as? ComicCell {
            
            cell.setVariables(comic: comics[indexPath.row])
            
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comic = comics[indexPath.row]
        self.performSegue(withIdentifier: "segueToComicDetails", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == comics.count - 6 {
            var comicFil = ""
            if searchBar.text != nil || searchBar.text != "" {
                comicFil = searchBar.text!
            }
            
            self.showActivityIndicator()
            downloadComics(filterComics: comicFil, offsetNum: comics.count, completion: { result in
                if result == true {
                    print("Comics downloaded Successfully")
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
        
        comics.removeAll()
        self.tableView.reloadData()
        showActivityIndicator()
        
        downloadComics(filterComics: "", offsetNum: 0, completion: { result in
            if result == true {
                print("Comics Downloaded Successfully")
                return
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        comics.removeAll()
        self.tableView.reloadData()
        showActivityIndicator()
        
        downloadComics(filterComics: searchBar.text!, offsetNum: comics.count, completion: {result in
            if result == true {
                print("Comics downloaded successfully")
                return
            }
        })
    }
    
    func downloadComics(filterComics: String, offsetNum: Int, completion: @escaping (Bool) -> ()) {
        
        downloadComicsofCharacter(person: personType, personID: personId, filter: filterComics, offset: offsetNum, completion: {jsonData in
            
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
                let title = jsonData["data"]["results"][i]["title"].string!
                let imagePath = jsonData["data"]["results"][i]["thumbnail"]["path"].string!
                let imageExt = jsonData["data"]["results"][i]["thumbnail"]["extension"].string!
                let imageURL = imagePath + "." + imageExt
                
                var infoURL: String! = "https://marvel.com"
                var viewURL: String! = "https://marvel.com"
                
                if let urlI = jsonData["data"]["results"][i]["urls"][0]["url"].string {
                    infoURL = urlI
                }
                if let urlV = jsonData["data"]["results"][i]["urls"][1]["url"].string {
                    viewURL = urlV
                }
                
                var newDescription = "No Description"
                if let description = jsonData["data"]["results"][i]["description"].string {
                    newDescription = description
                }
                
                let numOfCreators = jsonData["data"]["results"][i]["creators"]["available"].int!
                var creatorsInComic = [String]()
                
                if numOfCreators != 0 {
                    for j in 0...numOfCreators-1 {
                        if let creatorName = jsonData["data"]["results"][i]["creators"]["items"][j]["name"].string {
                            if let creatorTitle = jsonData["data"]["results"][i]["creators"]["items"][j]["role"].string {
                                creatorsInComic.append("\(creatorName)  -  \(creatorTitle)")

                            }
                        }
                    }
                } else {
                    creatorsInComic.append("Creators Unknown")
                }

                
                let numofCharacters = jsonData["data"]["results"][i]["characters"]["available"].int!
                var charactersInComic = [String]()
                
                if numofCharacters != 0 {
                    for j in 0...numofCharacters-1 {
                        if let charName = jsonData["data"]["results"][i]["characters"]["items"][j]["name"].string {
                            charactersInComic.append(charName)
                        }
                    }
                } else {
                    charactersInComic.append("Characters Unknown")
                }

                let newComic = Comic.init(newId: id, newTitle: title, urlImage: imageURL, newDesc: newDescription, urlI: infoURL, urlV: viewURL, creators: creatorsInComic, characters: charactersInComic)
                self.comics.append(newComic)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            completion(true)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToComicDetails" {
            let destVC = segue.destination as? ComDetailsScreen
            destVC?.comic = comic
        }
    }
    
    @objc func returnToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
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
