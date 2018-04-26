//
//  PostController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 26/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class PostController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PostCreationViewDelegate
{
    var post: Post?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: PostCreationView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let postInputView = PostCreationView(frame: frame)
        postInputView.delegate = self
        return postInputView
    }()
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    
    func didSubmit(for post: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("post id:", self.post?.id ?? "")
        
        print("Inserting post:", post)
        
        let values = ["uid": uid, "text": post, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert Post", err)
                return
            }
            print("Successfully inserted Post.")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: PostController.updateFeedNotificationName, object: nil)
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
