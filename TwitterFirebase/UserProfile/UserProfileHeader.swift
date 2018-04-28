//
//  UserProfileHeader.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 24/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didTapSettings()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    var isCurrentUser = false
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profileImageUrl else { return }
            userProfileImage.loadImage(urlString: imageUrl)
            
            guard let fullname = user?.fullname else { return }
            guard let username = user?.username else { return }
            
            let attributedText = NSMutableAttributedString(string: fullname + "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            attributedText.append(NSAttributedString(string: "@" + username, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            usernameLabel.attributedText = attributedText
            
            setupFollowButton()
            setupTotalFollowers()
            setupTotalFollowing()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        addSubview(userProfileImage)
        addSubview(usernameLabel)
        addSubview(followingLabel)
        addSubview(followersLabel)
        
        addSubview(followingLabel)
        addSubview(followersLabel)
        addSubview(menuBar)
        addSubview(bottomDividerView)
        
        userProfileImage.anchor(top: topAnchor, left: leftAnchor,  paddingTop: 16, paddingLeft: 16, width: 80, height: 80)
        userProfileImage.layer.cornerRadius = 80 / 2
        userProfileImage.contentMode = .scaleAspectFill
        usernameLabel.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        followingLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, right: followersLabel.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 8)
        followersLabel.anchor(top: usernameLabel.bottomAnchor, left: followingLabel.rightAnchor, paddingTop: 16, paddingLeft: 16)
        menuBar.anchor(top: followingLabel.bottomAnchor, left: leftAnchor, bottom: bottomDividerView.topAnchor, right: rightAnchor, paddingTop: 8)
        bottomDividerView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    func setupLogoutOrFollowButton(){
        if isCurrentUser == true {
            addSubview(settingsButton)
            settingsButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16, width: 30, height: 30)
        }
        else {
            addSubview(followButton)
            followButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16, width: 100, height: 30)
        }
    }
    
    let menuBar: UserProfileMenuBar = {
        let mb = UserProfileMenuBar()
        return mb
    }()
    
    lazy var userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = iv.frame.width / 2
        iv.layer.masksToBounds = true
        iv.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        iv.layer.borderWidth = 1.5
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "fullname\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "@username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var userBio: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.text = "Some Bio Text"
        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var followingLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    func setupTotalFollowing(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        var total = 0
        var currentUserPage = ""
        if currentLoggedInUserId == userId {
            currentUserPage = currentLoggedInUserId
        }
        else {
            currentUserPage = userId
        }
        
        Database.database().reference().child("following").child(currentUserPage).observe(.value, with: { (snapshot) in
            total = Int(snapshot.childrenCount)
            let attributedText = NSMutableAttributedString(string: "\(total)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedText.append(NSAttributedString(string: " Following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            self.followingLabel.attributedText = attributedText
        }) { (err) in
            print("error counting total following")
        }
    }
    
    lazy var followersLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        return label
    }()
    
    func setupTotalFollowers(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        var currentUserPage = ""
        var total = 0
        if currentLoggedInUserId == userId {
            currentUserPage = currentLoggedInUserId
        }
        else {
            currentUserPage = userId
        }
        
        Database.database().reference().child("followers").child(currentUserPage).observe(.value, with: { (snapshot) in
            total = Int(snapshot.childrenCount)
            let attributedText = NSMutableAttributedString(string: "\(total)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedText.append(NSAttributedString(string: " Followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            self.followersLabel.attributedText = attributedText
        }) { (err) in
            print("error counting total Followers")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    func setupFollowButton(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            addSubview(settingsButton)
            settingsButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16, width: 30, height: 30)
        } else {
            addSubview(followButton)
            followButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16, width: 100, height: 30)
        }
        Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                self.followButton.setTitle("Unfollow", for: .normal)
            } else {
                self.followButton.setTitle("Follow", for: .normal)
            }
        }) { (err) in
            print("Failed to check if following:", err)
        }
    }
    
    @objc func handleFollow(){
        print("Following user")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        //unfollow
        if followButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("followers").child(userId).child(currentLoggedInUserId).removeValue {(err, ref) in
                if let err = err{
                    print("Failed to unfollow user:", err)
                    return
                }
                Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                    if let err = err{
                        print("Failed to unfollow user:", err)
                        return
                    }
                    print("Successfully unfollowed user:", self.user?.username ?? "")
                    
                    self.followButton.setTitle("Follow", for: .normal)
                    //                self.followButton.backgroundColor = .white
                    //                self.followButton.setTitleColor(.black, for: .normal)
                }
            }
        }else {
            let ref1 = Database.database().reference().child("following").child(currentLoggedInUserId)
            let ref2 = Database.database().reference().child("followers").child(userId)
            let values1 = [userId: 1]
            let values2 = [currentLoggedInUserId: 1]
            
            ref2.updateChildValues(values2) { (err, ref) in
                if let err = err{
                    print("Failed to follow user", err)
                    return
                }
                ref1.updateChildValues(values1) { (err, ref) in
                    if let err = err{
                        print("Failed to follow user", err)
                        return
                    }
                    print("Successfully followed user", self.user?.username ?? "")
                    self.followButton.setTitle("Unfollow", for: .normal)
                    //                self.followButton.backgroundColor = .white
                    //                self.followButton.setTitleColor(.black, for: .normal)
                }
            }
        }
    }
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSettings(){
        print("logout pressed from user profile")
        delegate?.didTapSettings()
    }
}
