
//
//  ChatLogViewController.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import RealmSwift

class ChatLogViewController: UIViewController {
    
    // MARK: - Lifecycle
    @IBOutlet var tableView: UITableView!
    var messageTextField: UITextField!
    
    // MARK: - Variables
    let realm = try! Realm()
    var token: NotificationToken?
    var messages: Results<Message>? {
        didSet {
            token = messages?.observe {[weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else {return}
                
                switch changes {
                case .initial:
                    tableView.reloadData()
                    break
                    
                case .update( _, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    
                    //re-order repos when new pushes happen
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                    tableView.endUpdates()
                    break
                    
                case .error(let error):
                    print(error)
                    break
                }
                
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        messages = realm.objects(Message.self).sorted(byKeyPath: "timestamp", ascending: true)
        FirebaseManager.shared.observe()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.keyboardDismissMode = .interactive
        tableView.register(UINib(nibName: "ChatLogTableViewCell", bundle: nil), forCellReuseIdentifier: "chatLogTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Chat Log"
        let rightButton = UIBarButtonItem(title: "Send Message", style: .plain, target: self, action: #selector(sendMessageClicked(_:)))
        navigationItem.rightBarButtonItem = rightButton
    }
    

    
    private func sendMessage() {
        if let messageText = messageTextField.text, messageText.count > 0 {
            let message = Message(id: UUID().uuidString, timestamp: Date().timeIntervalSince1970, fromUser: Preferences.fromUser!, toUser: Preferences.toUser!, text: messageText)
            RealmHelper.save([message], in: realm)
            FirebaseManager.shared.send(message)
        }
    }
    
    // MARK: - Selector Methods
    @objc func sendMessageClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Message Box", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            self.messageTextField = textfield
            textfield.delegate = self
            textfield.placeholder = "Enter Message here.."
        }
        let sendButton = UIAlertAction(title: "send", style: .default) { _ in
            self.sendMessage()
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .default) { _ in
            print("cancel clicked")
        }
        alertController.addAction(sendButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - UITableViewDataSource
extension ChatLogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatLogTableViewCell") as! ChatLogTableViewCell
        let message = messages![indexPath.row]
        cell.userNameLabel.font = UIFont.systemFont(ofSize: 10)
        cell.messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.userNameLabel.text = message.fromUser
        cell.messageLabel.text = message.text
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let message = messages![indexPath.row]
        if let cell = cell as? ChatLogTableViewCell {
            cell.userNameLabel.textAlignment = message.fromUser == Preferences.fromUser! ? .right : .left
            cell.messageLabel.textAlignment = message.fromUser == Preferences.fromUser! ? .right : .left
        }
    }
}

// MARK: - UITextFieldDelegate
extension ChatLogViewController : UITextFieldDelegate {
    
}
