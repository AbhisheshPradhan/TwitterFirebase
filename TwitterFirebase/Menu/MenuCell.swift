//
//  MenuCell.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 22/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit


class MenuCell: UICollectionViewCell {
    
    var option: MenuOption? {
        didSet{
            iconImage.image = option?.image
            nameLabel.text = option?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImage)
        addSubview(nameLabel)
        
        iconImage.clipsToBounds = true
        iconImage.anchor(top: topAnchor, left: leftAnchor,  right: nameLabel.leftAnchor, paddingTop: 8, paddingLeft: 16,  paddingRight: 16, width: 25, height: 25)
        nameLabel.anchor(top: topAnchor, left: iconImage.rightAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 16)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

}
