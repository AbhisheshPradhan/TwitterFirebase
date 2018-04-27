//
//  SearchController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 27/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//


import UIKit
import Firebase

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    
    let cellId = "cellId"
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filteredUsers = users
        }
        else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true     //make it scrollable even if the item list fits on the screen
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()    //hides keyboard when selecting a row
        
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileController.userId = user.uid
        
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers(){
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                
                //remove current user from the user filter list
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
                
            })
            
            //Alphabetical sort
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch users for search: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}








