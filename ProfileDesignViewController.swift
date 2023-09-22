//
//  ProfileDesignViewController.swift
//  Todo
//
//  Created by 김도윤 on 2023/09/15.
//

import SnapKit
import UIKit

class ProfileDesignViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let statusBarView = UIView()
        statusBarView.backgroundColor = .white
        self.view.addSubview(statusBarView)
        
        statusBarView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(44)
            make.top.leading.equalToSuperview()
        }
        
        let statusBarHeight: CGFloat = 44
        
        let menuImageView = UIImageView(image: UIImage(named: "Menu.svg"))
        menuImageView.contentMode = .scaleAspectFit
        self.view.addSubview(menuImageView)
        
        menuImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58 + statusBarHeight)
            make.left.equalToSuperview().offset(338)
            make.width.equalTo(21)
            make.height.equalTo(17.5)
        }
        
        let usernameLabel = UILabel()
        usernameLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usernameLabel.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "nabaecamp", attributes: [NSAttributedString.Key.kern: -1])
        usernameLabel.attributedText = attributedString
        self.view.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(25)
            make.leading.equalToSuperview().offset(139)
            make.top.equalToSuperview().offset(54 + statusBarHeight)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logged-in-rtan.png")
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(88)
            make.left.equalTo(usernameLabel).offset(-14 - 88)
            make.top.equalTo(usernameLabel.snp.bottom).offset(37)
        }
       
        let sevenLabel = UILabel()
        sevenLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        sevenLabel.font = UIFont.boldSystemFont(ofSize: 16.5)
        sevenLabel.textAlignment = .center
        sevenLabel.text = "7"
        self.view.addSubview(sevenLabel)
        
        sevenLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).offset(50)
        }
        
        let zerooneLabel = UILabel()
        zerooneLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        zerooneLabel.font = UIFont.boldSystemFont(ofSize: 16.5)
        zerooneLabel.textAlignment = .center
        zerooneLabel.text = "0"
        self.view.addSubview(zerooneLabel)
        
        zerooneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).offset(130)
        }
        
        let zerotwoLabel = UILabel()
        zerotwoLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        zerotwoLabel.font = UIFont.boldSystemFont(ofSize: 16.5)
        zerotwoLabel.textAlignment = .center
        zerotwoLabel.text = "0"
        self.view.addSubview(zerotwoLabel)
        
        zerotwoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).offset(212)
        }
        
        let postLabel = UILabel()
        postLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        postLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        postLabel.textAlignment = .center
        postLabel.attributedText = NSMutableAttributedString(string: "post", attributes: [NSAttributedString.Key.kern: -0.3])
        self.view.addSubview(postLabel)

        postLabel.snp.makeConstraints { make in
            make.top.equalTo(sevenLabel.snp.bottom).offset(10)
            make.left.equalTo(imageView.snp.right).offset(41)
        }

        let followerLabel = UILabel()
        followerLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followerLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        followerLabel.textAlignment = .center
        followerLabel.attributedText = NSMutableAttributedString(string: "follower", attributes: [NSAttributedString.Key.kern: -0.3])
        self.view.addSubview(followerLabel)

        followerLabel.snp.makeConstraints { make in
            make.top.equalTo(zerooneLabel.snp.bottom).offset(10)
            make.centerX.equalTo(zerooneLabel)
        }

        let followingLabel = UILabel()
        followingLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followingLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        followingLabel.textAlignment = .center
        followingLabel.attributedText = NSMutableAttributedString(string: "following", attributes: [NSAttributedString.Key.kern: -0.3])
        self.view.addSubview(followingLabel)

        followingLabel.snp.makeConstraints { make in
            make.top.equalTo(zerotwoLabel.snp.bottom).offset(10)
            make.centerX.equalTo(zerotwoLabel)
        }
    }
}
