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
        
//        navigationItem.rightBarButtonItem = tweetButton
        navigationItem.leftBarButtonItem = dismissButton
    }
    
//    let tweetButton : UIBarButtonItem = {
//        let button = UIButton()
//        let barButton = UIBarButtonItem()
//        button.setTitle("Tweet", for: .normal)
//        button.backgroundColor = .mainBlue()
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 15
//        button.layer.masksToBounds = true
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleTweet), for: .touchUpInside)
//
//        barButton.customView = button
//        barButton.customView?.widthAnchor.constraint(equalToConstant: 65).isActive = true
//        barButton.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        return barButton
//    }()
    
//    @objc func handleTweet(){
//        print("Tweet")
//    }
    
    let dismissButton : UIBarButtonItem = {
        let button = UIButton()
        let barButton = UIBarButtonItem()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        barButton.customView = button
        barButton.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return barButton
    }()
    
    @objc func handleDismiss(){
        self.navigationController?.popViewController(animated: false)
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
        let frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 50)
        let postInputView = PostCreationView(frame: frame)
        postInputView.delegate = self
        return postInputView
    }()
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    func didSubmit(for post: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid, "text": post, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        let postNode = Database.database().reference().child("posts").child(uid).childByAutoId()
        postNode.updateChildValues(values) { (err, ref) in
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
