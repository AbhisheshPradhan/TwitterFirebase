//
//  MessageController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 27/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//


import UIKit
import Firebase

class MessageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        collectionView?.backgroundColor = .bgColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.leftBarButtonItem = userProfileImageButton
        self.navigationItem.rightBarButtonItem = newMessageButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func showUserProfile(){
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    lazy var menuLauncher: MenuLauncher = {
        let launcher = MenuLauncher()
        launcher.messageController = self
        return launcher
    }()
    
    @objc func handleShowMenu(){
        menuLauncher.showMenu()
    }
    
    lazy var newMessageButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "new_message").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        return barButton
    }()
    
    @objc func handleNewMessage(){
        print("Creating New Message")
        let newMessageController = NewMessageController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
       
        self.navigationController?.pushViewController(newMessageController, animated: false)
        
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
}
