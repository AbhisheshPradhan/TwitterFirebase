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
    
    func didTapUserProfileImageFromHomePage(post: Post) {
        print("Going to User's Profile from home controller")
        //        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        //        userProfileController.user = post.user
        //        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    let cellId = "cellId"
    
    private let homePostCell = HomePostCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .bgColor()
        self.navigationItem.title = "Home"
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName: UIFont.boldSystemFont(ofSize: 18)] as [NSAttributedStringKey : Any]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
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
        fetchFollowingUserIds()
    }
    
    func setupNavBarButtons(){
        self.navigationItem.leftBarButtonItem = userProfileImageButton
        self.navigationItem.rightBarButtonItem = tweetButton
    }
    
    lazy var userProfileImageButton: UIBarButtonItem = {
        let button = CustomImageButton()
        let uid = Auth.auth().currentUser?.uid ?? ""
        Database.fetchUserWithUID(uid: uid, completion: { (user) in
            let imageUrl = user.profileImageUrl
            button.loadImage(urlString: imageUrl)
            button.clipsToBounds = true
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 0.5
            button.addTarget(self, action: #selector(self.handleShowMenu), for: .touchUpInside)
        })
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return barButton
    }()
    
    lazy var tweetButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "compose"), for: .normal)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        button.addTarget(self, action: #selector(handleShowCreateTweet), for: .touchUpInside)
        return barButton
    }()
    
    lazy var menuLauncher: MenuLauncher = {
        let launcher = MenuLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleShowMenu(){
        print("Showing menu")
        menuLauncher.showMenu()
    }
    
    func showUserProfile(){
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    @objc func handleShowCreateTweet(){
        print("Showing Tweet page")
        let postController = PostController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(postController, animated: true)
    }
    
    func didLike(for cell: HomePostCell){
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else{ return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = [uid: post.hasLiked == true ? 0 : 1 ]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { (err, _) in
            return
        }
        
        post.hasLiked = !post.hasLiked
        self.posts[indexPath.item] = post
        self.collectionView?.reloadItems(at: [indexPath])
        
        let value2 = [uid:1]
        
        if value == [uid : 1] {
            Database.database().reference().child("post-likes").child(postId).updateChildValues(value2){ (err, ref) in
                if let err = err {
                    print("Failed to add post like", err)
                    return
                }
            }
        } else {
            Database.database().reference().child("post-likes").child(postId).removeValue() {(err, ref) in
                if let err = err {
                    print("Failed to remove post like", err)
                    return
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let post = posts[indexPath.item]
        let size = CGSize(width: view.frame.width - 82, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: post.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 75)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.delegate = self
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = posts[indexPath.row].user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) {(user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1{
                        post.hasLiked = true
                    }
                    else{
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post")
                })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key,value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
}
