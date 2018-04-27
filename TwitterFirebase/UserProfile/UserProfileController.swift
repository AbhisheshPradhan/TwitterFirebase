//
//  UserProfileController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 24/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate
{
    
    var user: User?
    
    let cellId = "cellId"
    let headerId = "headerId"
    var posts = [Post]()
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .bgColor()
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.rightBarButtonItem = tweetButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
        
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        collectionView?.reloadData()
        fetchUser()
        fetchPosts()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        posts.removeAll()
        collectionView?.reloadData()
        fetchPosts()
    }
    
    lazy var tweetButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "compose"), for: .normal)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        button.addTarget(self, action: #selector(handleShowCreateTweet), for: .touchUpInside)
        return barButton
    }()
    
    @objc func handleShowCreateTweet(){
        print("Create new tweet")
        let postController = PostController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(postController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let post = posts[indexPath.item]
        let size = CGSize(width: view.frame.width - 82, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        
        let estimatedFrame = NSString(string: post.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.user = self.user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 225)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func fetchUser(){
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        print("Current User: " + uid)
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.collectionView?.reloadData()
        }
    }
    
    func didTapLogOut() {
        print("Logging out")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func fetchPosts(){
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) {(user) in
            Database.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView?.refreshControl?.endRefreshing()
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach({ (key, value) in
                    guard let dictionary = value as? [String: Any] else { return }
                    let post = Post(user: user, dictionary: dictionary)
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                })
                
            }, withCancel: { (err) in
                print("Failed to fetch post")
                return
            })
        }
    }
}

