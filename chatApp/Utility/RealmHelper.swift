//
//  RealmHelper.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    class func save(_ messages: [Message], in realm: Realm) {
        try! realm.write {
            realm.add(messages, update: true)
        }
    }
}
