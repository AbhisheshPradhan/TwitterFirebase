//
//  UserProfileHeader.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 24/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit


protocol UserProfileHeaderDelegate {
    func didTapLogOut()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profileImageUrl else { return }
            userProfileImage.loadImage(urlString: imageUrl)
            
            guard let fullname = user?.fullname else { return }
            guard let username = user?.username else { return }
            print("username: \(username) & fullname: \(fullname)")
            
            let attributedText = NSMutableAttributedString(string: fullname + "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            attributedText.append(NSAttributedString(string: "@" + username, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            usernameLabel.attributedText = attributedText
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
        addSubview(logoutButton)
        
        userProfileImage.anchor(top: topAnchor, left: leftAnchor,  paddingTop: 16, paddingLeft: 16, width: 80, height: 80)
        userProfileImage.layer.cornerRadius = 80 / 2
        userProfileImage.contentMode = .scaleAspectFill
        
        logoutButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16, width: 30, height: 30)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        addSubview(followingLabel)
        addSubview(followersLabel)
        addSubview(bottomDividerView)
        addSubview(menuBar)
        
        followingLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, right: followersLabel.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 8)
        followersLabel.anchor(top: usernameLabel.bottomAnchor, left: followingLabel.rightAnchor, paddingTop: 16, paddingLeft: 16)
        
        menuBar.anchor(top: followingLabel.bottomAnchor, left: leftAnchor, bottom: bottomDividerView.topAnchor, right: rightAnchor, paddingTop: 8)
        
        bottomDividerView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
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
    
    let followingLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "115", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    let followersLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "11", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "logout").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogout(){
        print("logout pressed from user profile")
        delegate?.didTapLogOut()
    }
}
