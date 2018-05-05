//
//  MessageCell.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 2/5/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor,  paddingLeft: 16,  width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
}
