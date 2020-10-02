//
//  ComDetailsScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/29/20.
//

import UIKit

class ComDetailsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnMoreBtn: UIButton!
    @IBOutlet weak var viewComicBtn: UIButton!
    
    var comic: Comic!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarBtn = UIBarButtonItem.init(image: UIImage(named: "homeLogo"), style: .plain, target: self, action: #selector(self.returnToHome))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.tintColor = .black
        tableView.tableFooterView = UIView()
        
        self.navigationItem.title = comic.title
        comicImage.image = comic.image
        comicDescription.text = comic.description
        comicDescription.layer.cornerRadius = 10

        learnMoreBtn.layer.cornerRadius = 5
        viewComicBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return comic.creators.count
        } else {
            return comic.characters.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as? PersonCell {
                cell.setName(newName: comic.creators[indexPath.row])
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as? PersonCell {
                cell.setName(newName: comic.characters[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return "CREATORS"
        } else {
            return "CHARACTERS"
        }
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        if let url = URL(string: comic.infoURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func viewBtnPressed(_ sender: Any) {
        if let url = URL(string: comic.viewURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func returnToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

class PersonCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    func setName(newName: String) {
        name.text = newName
    }
}
