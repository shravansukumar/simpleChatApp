//
//  Preferences.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation


class Preferences {
    static var fromUser: String? {
        get {
            return UserDefaults.standard.string(forKey: "fromUser")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "fromUser")
        }
    }
    
    static var toUser: String? {
        get {
            return UserDefaults.standard.string(forKey: "toUser")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "toUser")
        }
    }
}
