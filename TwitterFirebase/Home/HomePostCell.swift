//
//  HomePostCell.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 21/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit


protocol HomePostCellDelegate {
    func didTapUserProfileImageFromHomePage(post: Post)
}


class HomePostCell: UICollectionViewCell
{
    
    var delegate: HomePostCellDelegate?
    var user: User?
    
    var post: Post? {
        didSet{
            guard let imageUrl = post?.user.profileImageUrl else { return }
            guard let fullname = post?.user.fullname else { return }
            guard let username = post?.user.username else { return }
            
            userProfileImage.loadImage(urlString: imageUrl)
            
            setupUsername(with: fullname, with: username )
            tweetText.text = post?.text
        }
    }
    
    func setupUsername(with fullname: String, with username: String){
        let attributedText = NSMutableAttributedString(string: fullname, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " @" + username, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        usernameLabel.attributedText = attributedText
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        setupTweet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    func setupTweet(){
        
        let stackView = UIStackView(arrangedSubviews: [replyButton, retweetButton, likeButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        addSubview(userProfileImage)
        addSubview(usernameLabel)
        addSubview(tweetText)
        addSubview(stackView)
        addSubview(bottomDividerView)
        
        userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        userProfileImage.layer.cornerRadius = 50/2
        
        userProfileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16, width: 50, height: 50)
        usernameLabel.anchor(top: topAnchor, left: userProfileImage.rightAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, height: 14)
        
        tweetText.anchor(top: usernameLabel.bottomAnchor, left: userProfileImage.rightAnchor, bottom: stackView.topAnchor, right: rightAnchor, paddingLeft: 8, paddingBot: 8, paddingRight: 8)
        
        stackView.anchor(left: userProfileImage.rightAnchor, bottom: bottomDividerView.topAnchor, right: rightAnchor, paddingLeft: -16, paddingBot: 8, paddingRight: 32)
        
        bottomDividerView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    lazy var userProfileImage: CustomImageButton = {
        let button = CustomImageButton()
        button.addTarget(self, action: #selector(handleOpenUserProfile), for: .touchUpInside)
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 0.5
        return button
    }()
    
    @objc func handleOpenUserProfile(){
        delegate?.didTapUserProfileImageFromHomePage(post: post!)
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let tweetText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.text = "Here is a sample caption to test dafasd fdas fd safds afsda fsda fsda fdsa fsda fsd afsad f sad"
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    lazy var replyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCommentButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCommentButtonPressed(){
        print("Comment Button Pressed")
    }
    
    lazy var retweetButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleRetweetButtonButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRetweetButtonButtonPressed(){
        print("Retweet Button Pressed")
    }
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLikeButtonPressed(){
        print("Like Button Pressed")
    }
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "message").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShareButtonPressed(){
        print("ShareButton Pressed")
    }
    
}
