//
//  CharDetailsScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/27/20.
//

import UIKit

class CharDetailsScreen: UIViewController {

    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var charDesc: UITextView!
    @IBOutlet weak var comicBtn: UIButton!
    @IBOutlet weak var moreInfoBtn: UIButton!

    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = character.name.uppercased()
        let rightBarBtn = UIBarButtonItem.init(image: UIImage(named: "homeLogo"), style: .plain, target: self, action: #selector(self.returnToHome))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        charImage.image = character.image
        charDesc.text = character.description
        
        comicBtn.layer.cornerRadius = 10
        comicBtn.layer.borderWidth = 1
        comicBtn.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
        moreInfoBtn.layer.cornerRadius = 10
        moreInfoBtn.layer.borderWidth = 1
        moreInfoBtn.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
    }
    
    @IBAction func comicsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToComics", sender: nil)
    }
    
    @IBAction func moreInfoBtnPressed(_ sender: Any) {
        if let url = URL(string: character.infoURL) {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToComics" {
            if let destination = segue.destination as? ComicsScreen {
                destination.personType = true
                destination.personId = character.id
                destination.personName = character.name
            }
        }
    }
    
    @objc func returnToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
