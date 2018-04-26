//
//  SetupProfileController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 25/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class SetupProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tophalfView)
        tophalfView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  paddingBot: view.frame.height / 2)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, paddingTop: 100, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        self.hideKeyboardWhenTappedAround()
    }
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignUp", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    let plusPhotoButton: UIButton = {
        let button = UIButton (type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal  )
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        plusPhotoButton.layer.borderWidth = 1.5
        
        dismiss(animated: true, completion: nil)
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "@username"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .center
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Full Name"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .center
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = fullnameTextField.hasText && usernameTextField.hasText
        
        if isFormValid{
            signUpButton.backgroundColor = .textBlue()
            signUpButton.isEnabled = true
        }
        else {
            signUpButton.backgroundColor = .mainBlue()
            signUpButton.isEnabled = false
        }
    }
    
    let tophalfView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue()
        return view
    }()
    
    @objc func handleSignUp(){
        print("handling Sign up")
        guard let image = self.plusPhotoButton.imageView?.image else { return }
        guard let username = usernameTextField.text else { return }
        guard let fullname = fullnameTextField.text, fullname.count > 0  else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil
            , completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload Profile image:", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded Profile image:", profileImageUrl)
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let dictionaryValues = ["username": username, "fullname" : fullname , "profileImageUrl": profileImageUrl] as [String : Any]
                let values = [uid: dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user info into Database", err)
                        return
                    }
                    print("Successfully saved user info into Database")
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                })
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [fullnameTextField, usernameTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        tophalfView.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 60, paddingRight: 60, height: 130)
    }
}
