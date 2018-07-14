//
//  HomeViewController.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose User"
    }
    
    // MARK: - Public Methods
    func setPreferences(flag: Bool) {
        Preferences.fromUser = flag ? "User1" : "User2"
        Preferences.toUser = flag ? "User2" : "User1"
    }
    
    func pushToChatLogViewController() {
        let chatLogViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatLogViewController") as! ChatLogViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(chatLogViewController, animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func user1ButtonClicked(_ sender: UIButton) {
        setPreferences(flag: true)
        pushToChatLogViewController()
    }
    
    @IBAction func user2ButtonClicked(_ sender: UIButton) {
        setPreferences(flag: false)
        pushToChatLogViewController()
    }
}

