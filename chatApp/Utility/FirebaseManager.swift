//
//  FirebaseManager.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RealmSwift

final class FirebaseManager {
    
    struct Reference {
        let rootReference = Database.database().reference().root
        let messagesReference = Database.database().reference().root.child("messages")
    }
    
    // MARK: - Shared Instance
    static let shared = FirebaseManager()
    
    // MARK: - Variables
    let realm = try! Realm()
    
    // MARK: - Public Methods
    func send(_ message: Message) {
        let values = ["timestamp" : message.timestamp,
                      "fromUser": message.fromUser,
                      "toUser": message.toUser,
                      "text": message.text
            ] as [String : Any]
        Reference().messagesReference.child(message.id).updateChildValues(values)
    }
    
    func observe() {
        Reference().messagesReference.observe(.childAdded) { (snapshot) in
            guard let message = snapshot.value as? [String:Any] else { return }
            if message["fromUser"] as? String != Preferences.fromUser! {
//                let message = Message(id: snapshot.key, timestamp: message["timestamp"] as! Double, fromUser: message["fromUser"] as! String, toUser: message["toUser"] as! String, text: message["text"] as! String)
                RealmHelper.save([self.createMessageObject(with: snapshot.key, and: message)], in: self.realm)
            }
        }
    }
    
    func fetchAllMessages() {
        Reference().messagesReference.observeSingleEvent(of: .value) { (snapshot) in
            guard let messagesDictionary = snapshot.value as? [String:Any] else {return}
            var messages = [Message]()
            for key in messagesDictionary.keys {
                let values = messagesDictionary[key] as! [String:Any]
                messages.append(self.createMessageObject(with: key, and: values))
            }
            RealmHelper.save(messages, in: self.realm)
        }
    }
    
    private func createMessageObject(with key: String, and values: [String:Any]) -> Message{
        return Message(id: key, timestamp: values["timestamp"] as! Double, fromUser: values["fromUser"] as! String, toUser: values["toUser"] as! String, text: values["text"] as! String)
    }
}
