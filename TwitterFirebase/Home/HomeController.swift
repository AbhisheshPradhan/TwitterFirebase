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
     //   navigationController?.hidesBarsOnSwipe = false
    }
    
    let cellId = "cellId"
    
    private let homePostCell = HomePostCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .bgGray()
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
    
    var user: User?
    let uid = Auth.auth().currentUser?.uid ?? ""
    
    
    lazy var userProfileImageButton: UIBarButtonItem = {
        let button = CustomImageButton()
        
        Database.fetchUserWithUID(uid: uid, completion: { (user) in
            let imageUrl = user.profileImageUrl
            button.loadImage(urlString: imageUrl)
            button.clipsToBounds = true
            // button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        // navigationController?.navigationBar.transparentNavigationBar()
    }
    
    @objc func handleShowCreateTweet(){
        print("Showing Tweet page")
        let postController = PostController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(postController, animated: true)
        //  navigationController?.navigationBar.transparentNavigationBar()
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
        return 0
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
