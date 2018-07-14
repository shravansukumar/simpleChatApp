//
//  Message.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var timestamp: Double = 0
    @objc dynamic var fromUser: String = ""
    @objc dynamic var toUser: String = ""
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: String, timestamp: Double, fromUser: String, toUser: String, text: String) {
        self.init()
        
        self.id = id
        self.timestamp = timestamp
        self.fromUser = fromUser
        self.toUser = toUser
        self.text = text
    }
}
