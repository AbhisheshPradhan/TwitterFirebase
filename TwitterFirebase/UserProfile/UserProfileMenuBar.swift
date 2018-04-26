//
//  UserProfileMenuBar.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 24/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

class UserProfileMenuBar: UIView, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(UserProfileMenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
//        let selectedIndexPath = IndexPath(item: 0, section: 0)
//        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
    
    let menuOptions = ["Tweets", "Replies", "Media", "Likes"]
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileMenuCell
        cell.textLabel.text = menuOptions[indexPath.item]
        cell.textLabel.textColor = .lightGray
      //  cell.backgroundColor = .yellow
        collectionView.selectItem(at: IndexPath(item:0, section:0), animated: false, scrollPosition:[])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4 , height: frame.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
