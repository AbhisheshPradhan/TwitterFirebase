//
//  LaunchScreenViewController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 2/5/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import RevealingSplashView

class LaunchScreenViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "twitter_logo"), iconInitialSize: CGSize(width: 125, height: 125), backgroundColor: #colorLiteral(red: 0, green: 0.6705882353, blue: 0.8705882353, alpha: 1))
}
