//
//  CreatorsScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/30/20.
//

import UIKit
import SwiftyJSON

class CreatorsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var creators = [Creator]()
    var creator: Creator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        showActivityIndicator()
        
        downloadCreators(filterCreators: "", offsetNum: 0, completion: {result in
            if result == true {
                print("Creators Downloaded Successfully")
            }
        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "creatorCell") as? CreatorCell {
                        
            cell.setVariables(creator: creators[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == creators.count - 7 {
            var creatorFilter = ""
            if searchBar.text != nil || searchBar.text != "" {
                creatorFilter = searchBar.text!
            }
            
            self.showActivityIndicator()
            downloadCreators(filterCreators: creatorFilter, offsetNum: creators.count, completion: {result in
                if result == true {
                    print("Creators Downloaded Successfully")
                    return
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        creator = creators[indexPath.row]
        
        self.performSegue(withIdentifier: "segueToComics", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        creators.removeAll()
        self.tableView.reloadData()
        showActivityIndicator()
        
        downloadCreators(filterCreators: "", offsetNum: 0, completion: {result in
            if result == true {
                print("Creators Downloaded Successfully")
                return
            }
        })
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        creators.removeAll()
        
        self.tableView.reloadData()
        showActivityIndicator()
        
        downloadCreators(filterCreators: searchBar.text!, offsetNum: creators.count, completion: {result in
            if result == true {
                print("Creators Downloaded Successfully")
                return
            }
        })
    }
    
    
    func downloadCreators(filterCreators: String, offsetNum: Int, completion: @escaping (Bool) -> ()) {
        downloadAllCreators(filter: filterCreators, offset: offsetNum, completion: {jsonData in
                        
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
                let name = jsonData["data"]["results"][i]["fullName"].string!
                let imagePath = jsonData["data"]["results"][i]["thumbnail"]["path"].string!
                let imageExt = jsonData["data"]["results"][i]["thumbnail"]["extension"].string!
                let imageURL = imagePath + "." + imageExt
                let infoURL = jsonData["data"]["results"][i]["resourceURI"].string!
                let comics = jsonData["data"]["results"][i]["comics"]["available"].int!

                                
                let newCreator = Creator.init(newId: id, newName: name, urlImage: imageURL, infoURL: infoURL, comics: comics)
                self.creators.append(newCreator)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            completion(true)
            
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToComics" {
            let destVC = segue.destination as? ComicsScreen
            destVC?.personType = false
            destVC?.personId = creator.id
            destVC?.personName = creator.name
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
