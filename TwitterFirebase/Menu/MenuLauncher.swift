//
//  ManuLauncher.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 22/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class MenuOption: NSObject {
    
    var name: String
    let image: UIImage
    
    
    init(name: String, image: UIImage){
        self.name = name
        self.image = image
    }
}

class MenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MenuHeaderDelegate
{
    var user: User?
    var homeController: HomeController?
    let headerId = "headerId"
    let cellId = "cellId"
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    func didTapUserProfileImage() {
        print("Going to user's profile from Home Controller")
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                let width: CGFloat = window.frame.width - (window.frame.width / 5)
                self.collectionView.frame = CGRect(x: -width, y: 0, width: width, height: self.collectionView.frame.height)
            }
        }) { (bool) in
            self.homeController?.showUserProfile()
        }
    }
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let width: CGFloat = window.frame.width - (window.frame.width / 5)
            collectionView.frame = CGRect(x: -width, y: 0, width: width, height: window.frame.height)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionFlipFromLeft, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                let width: CGFloat = window.frame.width - (window.frame.width / 5)
                
                self.collectionView.frame = CGRect(x: -width, y: 0, width: width, height: self.collectionView.frame.height)
            }
        }
    }
    
    let menuOptions: [MenuOption] = {
        return [MenuOption(name: "Profile", image: #imageLiteral(resourceName: "profile_unselected").withRenderingMode(.alwaysOriginal)),
                MenuOption(name: "Lists", image: #imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal)),
                MenuOption(name: "Bookmarks", image: #imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal))]
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        //send value to cell from here
        let option = menuOptions[indexPath.item]
        cell.option = option
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MenuHeader
        header.delegate = self
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = menuOptions[indexPath.item]
        
        if option.name == "Profile"{
            didTapUserProfileImage()
        }
        
        handleDismiss()
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("Current User: " + uid)
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.collectionView.reloadData()
            
            print("self.user values: ", self.user ?? "")
        }
    }
    
    override init() {
        super.init()
        fetchUser()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
    }
}
