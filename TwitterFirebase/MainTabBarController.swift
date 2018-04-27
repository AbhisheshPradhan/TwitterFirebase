//
//  MainTabBarViewController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 20/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        if Auth.auth().currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        view.backgroundColor = .white
        setupViewControllers()
        
    }
    
    func setupViewControllers(){
        let homeNavController = templateNavController(unselected_image:#imageLiteral(resourceName: "home").withRenderingMode(.alwaysOriginal), selected_image: #imageLiteral(resourceName: "home"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchNavController = templateNavController(unselected_image: #imageLiteral(resourceName: "navSearch").withRenderingMode(.alwaysOriginal), selected_image: #imageLiteral(resourceName: "navSearch"),rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        let notificationNavController = templateNavController(unselected_image: #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal), selected_image: #imageLiteral(resourceName: "bell"), rootViewController: NotificationController())
        let messageNavController = templateNavController(unselected_image: #imageLiteral(resourceName: "messages").withRenderingMode(.alwaysOriginal), selected_image: #imageLiteral(resourceName: "messages"), rootViewController: MessageController())
        
        viewControllers = [homeNavController, searchNavController, notificationNavController, messageNavController]
        guard let items = tabBar.items else { return }
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselected_image: UIImage, selected_image: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected_image.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selected_image
        return navController
    }
}
