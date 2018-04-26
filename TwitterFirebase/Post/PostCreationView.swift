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
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    //textView supports multiline ..textField doesn't
    fileprivate let postTextView: PostTextView = {
        let tv = PostTextView()
        //textField.placeholder = "Enter Comment"
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Resizing Comment box : Step 1
        autoresizingMask = .flexibleHeight
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 12, width: 50, height: 50)
        
        addSubview(postTextView)
        //Resizing Comment box : Step 3..safeAreaLayoutGuide.bottomAnchor
        postTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBot: 8)
        setupLineSeparatorView()
    }
    
    //Resizing Comment box : Step 2
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBot: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    @objc func handleSubmit(){
        guard let postText = postTextView.text else { return }
        delegate?.didSubmit(for: postText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
