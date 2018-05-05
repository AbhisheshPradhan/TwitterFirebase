//
//  PostInputView.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 26/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

protocol PostCreationViewDelegate{
    func didSubmit(for post: String)
}

class PostCreationView: UIView {
    
    var delegate: PostCreationViewDelegate?
    
    let submitButton: UIButton = {
      //  let barButton = UIBarButtonItem()
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
      //  barButton.customView = button
        return button
    }()
    
    //textView supports multiline ..textField doesn't
    fileprivate let postTextView: PostTextView = {
        let tv = PostTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Resizing Comment box : Step 1
        autoresizingMask = .flexibleHeight
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8, width: 60, height: 50)
        addSubview(postTextView)
        //Resizing Comment box : Step 3..safeAreaLayoutGuide.bottomAnchor
        postTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBot: 8, paddingRight: 8)
      //  setupLineSeparatorView()
        guard let postText = postTextView.text else { return }
        delegate?.didSubmit(for: postText)
    }
    
    //Resizing Comment box : Step 2
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    @objc func handleSubmit(){
        guard let postText = postTextView.text else { return }
        delegate?.didSubmit(for: postText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
