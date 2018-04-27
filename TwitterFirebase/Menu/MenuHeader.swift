//
//  MenuHeader.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 22/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

protocol MenuHeaderDelegate {
    func didTapUserProfileImage()
}

class MenuHeader: UICollectionViewCell
{
    
    var delegate: MenuHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let fullname = user?.fullname else { return }
            guard let username = user?.username else { return }
            
            let attributedText = NSMutableAttributedString(string: fullname + "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "@" + username, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            usernameLabel.attributedText = attributedText
            
            guard let imageUrl = user?.profileImageUrl else { return }

            userProfileImage.loadImage(urlString: imageUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        
        addSubview(userProfileImage)
        userProfileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16, width: 50, height: 50)
        userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        userProfileImage.layer.cornerRadius = 50/2
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        addSubview(followingLabel)
        addSubview(followersLabel)
        
        followingLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, right: followersLabel.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 8)
        followersLabel.anchor(top: usernameLabel.bottomAnchor, left: followingLabel.rightAnchor, paddingTop: 16, paddingLeft: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userProfileImage: CustomImageButton = {
        let button = CustomImageButton()
        button.addTarget(self, action: #selector(handleOpenUserProfile), for: .touchUpInside)
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 0.5
        return button
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "Full Name\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "@username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "115", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " Following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "11", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " Followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        return label
    }()
    
    @objc func handleOpenUserProfile(){
        delegate?.didTapUserProfileImage()
    }
}
