//
//  SearchCell.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 27/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//


import UIKit

class SearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet{
            userNameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .black
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(left: userNameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor,  height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
