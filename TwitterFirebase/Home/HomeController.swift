//
//  HomeController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 21/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate
{
    
    func didTapUserProfileImageFromHomePage() {
        print("Going to User's Profile from home controller")
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    let cellId = "cellId"
    
    private let homePostCell = HomePostCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .lightGray
        self.navigationItem.title = "Home"
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName: UIFont.boldSystemFont(ofSize: 18)] as [NSAttributedStringKey : Any]
        setupNavBarButtons()
        fetchAll()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        posts.removeAll()
        collectionView?.reloadData()
        fetchAll()
    }
    
    fileprivate func fetchAll(){
        fetchPosts()
    }
    
    func setupNavBarButtons(){
        self.navigationItem.leftBarButtonItem = userProfileImageButton
        self.navigationItem.rightBarButtonItem = tweetButton
    }
    
    lazy var userProfileImageButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "happy"), for: .normal)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        button.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        return barButton
    }()
    
    lazy var tweetButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        button.addTarget(self, action: #selector(handleShowCreateTweet), for: .touchUpInside)
        return barButton
    }()
    
    lazy var menuLauncher: MenuLauncher = {
        let launcher = MenuLauncher()
        launcher.homeController = self
        print("launcher homeController set")
        return launcher
    }()
    
    @objc func handleShowMenu(){
        print("Showing menu")
        menuLauncher.showMenu()
    }
    
    func showUserProfile(){
        print("Showing User Profile")
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    @objc func handleShowCreateTweet(){
        print("Showing Tweet page")
        let postController = PostController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(postController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.delegate = self
        cell.post = posts[indexPath.item]
        return cell
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) {(user) in
            // self.fetchPostsWithUser(user: user)
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
