//
//  ChatLogController.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 3/5/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "chat log"
        collectionView?.backgroundColor = .white
        setupInputComponents()
    }
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Start a message"
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTextInputChange(){
        
        if inputTextField.hasText {
            sendButton.isEnabled = true
        }
        else {
            sendButton.isEnabled = false
        }
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = true
        
        view.addSubview(containerView)
        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBot: 80, height: 50)
        
        
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, right: containerView.rightAnchor,  width: 60, height: 50)
        
        containerView.addSubview(inputTextField)
        inputTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor,  right: sendButton.leftAnchor,   paddingLeft: 8, paddingRight: 4,  height: 50)
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .bgColor()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        separatorLine.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, height: 0.5)
    }
    
    @objc func handleSend(){
        
        let ref = Database.database().reference().child("messages").childByAutoId()
        let values = ["text" : inputTextField.text!]
        
        ref.updateChildValues(values)
        
    }
}
