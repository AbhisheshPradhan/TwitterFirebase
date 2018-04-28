//
//  User.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 25/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let fullname: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
