//
//  UserProfileMenuCell.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 24/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

class UserProfileMenuCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            textLabel.textColor = isHighlighted ? .mainBlue() : .lightGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            textLabel.textColor = isSelected ? .mainBlue() : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Tweet"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
