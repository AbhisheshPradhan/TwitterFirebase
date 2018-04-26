//
//  LoginController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 20/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //bottom half color
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(tophalfView)
        tophalfView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  paddingBot: view.frame.height / 2)
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100,  width: 80, height: 80)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        setupSignUpButton()
        self.hideKeyboardWhenTappedAround() 
    }
    
    let logoImageView: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "twitter_logo").withRenderingMode(.alwaysOriginal))
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .center
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .center
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.hasText &&
            passwordTextField.hasText
        
        if isFormValid{
            loginButton.backgroundColor = .textBlue()
            loginButton.isEnabled = true
        }
        else {
            loginButton.backgroundColor = .mainBlue()
            loginButton.isEnabled = false
        }
    }
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        //button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.textBlue()]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let tophalfView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue()
        return view
    }()
    
    @objc func handleLogin(){
        print("handling login")
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err{
                print("Failed to login", err)
                self.loginButton.shake()
                self.passwordTextField.text = ""
                self.loginButton.backgroundColor = .mainBlue()
                return
            }
            print("Successfully logged in")
            print("Current User:", uid)
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp(){
        print("Moving to Sign Up View")
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        tophalfView.addSubview(stackView)
        //        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: (view.frame.height / 4), paddingLeft: 60, paddingRight: 60, height: 140)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 60, paddingRight: 60, height: 140)
    }
    
    fileprivate func setupSignUpButton(){
        view.addSubview(signUpButton)
        signUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 50)
    }
}
