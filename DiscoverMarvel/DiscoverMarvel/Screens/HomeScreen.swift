//
//  HomeScreen.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/25/20.
//

import UIKit

class HomeScreen: UIViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func charactersButtonPressed(_ sender: Any){
        self.performSegue(withIdentifier: "segueToCharacters", sender: nil)
    }
    
    @IBAction func creatorsButtonPressed(_ sender: Any){
        self.performSegue(withIdentifier: "segueToCreators", sender: nil)
    }

}

