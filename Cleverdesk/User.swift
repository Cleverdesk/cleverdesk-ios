//
//  User.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 21.06.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import CoreData
import KeychainSwift


class User: NSManagedObject {
    let keychain = KeychainSwift()
    

// Insert code here to add functionality to your managed object subclass

    var token: String? {
        get {
            if username == nil {
                return nil
            }
            return keychain.get(username!)
        }
        
        set(value) {
            if value == nil {
                return
            }
            keychain.set(value!, forKey: username!, withAccess: .AccessibleWhenUnlocked)
        }
    }
    
    
}
