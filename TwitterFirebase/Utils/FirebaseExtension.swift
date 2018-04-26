//
//  FirebaseExtension.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 26/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    
    //used completion block
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }) { (err) in
            print("Failed to fetch users", err)
        }
    }
}
