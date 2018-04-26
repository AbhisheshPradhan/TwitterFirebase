//
//  Post.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 25/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    let text: String
    let creationDate: Date
    let user: User
    
    //casting the default value
    init(user: User, dictionary: [String : Any]){
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
