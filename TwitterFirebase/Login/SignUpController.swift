//
//  SignUpController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 20/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //bottom half color
        
        view.addSubview(tophalfView)
        tophalfView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  paddingBot: view.frame.height / 2)
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100,  width: 80, height: 80)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        setupAlreadyHaveAccountButton()
        self.hideKeyboardWhenTappedAround()
    }
    
    let logoImageView: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "twitter_logo").withRenderingMode(.alwaysOriginal))
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    let emalTextField: UITextField = {
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
        let isFormValid = passwordTextField.hasText && emalTextField.hasText
        
        if isFormValid{
            nextButton.backgroundColor = .textBlue()
            nextButton.isEnabled = true
        }
        else {
            nextButton.backgroundColor = .mainBlue()
            nextButton.isEnabled = false
        }
    }
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        //button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.textBlue()]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLoginPage), for: .touchUpInside)
        return button
    }()
    
    let tophalfView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue()
        return view
    }()
    
    @objc func handleNext(){
        print("Showing Next Page")
        
        guard let email = emalTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err{
                print("Failed to perform Sign Up", err)
                self.nextButton.shake()
                return
            }
            let setupProfileController = SetupProfileController()
            self.navigationController?.pushViewController(setupProfileController, animated: false)
        }
    }
    
    @objc func handleShowLoginPage(){
        print("Moving to Login View")
        navigationController?.popToRootViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emalTextField, passwordTextField, nextButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        tophalfView.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 60, paddingRight: 60, height: 140)
    }
    
    fileprivate func setupAlreadyHaveAccountButton(){
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 50)
    }
}
