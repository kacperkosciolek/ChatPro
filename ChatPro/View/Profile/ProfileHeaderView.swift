//
//  ProfileHeaderView.swift
//  ChatPro
//
//  Created by Kacper on 06/05/2022.
//

import UIKit
import SDWebImage
import Firebase

class ProfileHeaderView: UIView {
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    private var profileImageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 32
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var usernameLabel = UILabel()
    var emailLabel = UILabel()
    var friendsLabel = UILabel()
    var addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(friendsLabel)
        
        [usernameLabel, friendsLabel].forEach {
            $0.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .medium)
            $0.textColor = .black.withAlphaComponent(0.8)
        }
        profileImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    
        friendsLabel.translatesAutoresizingMaskIntoConstraints = false
        friendsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        friendsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImage)
        usernameLabel.text = viewModel.username
        friendsLabel.text = "friends: \(viewModel.friends ?? 0)"
    }
}
