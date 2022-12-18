//
//  FriendChatCell.swift
//  ChatPro
//
//  Created by Kacper on 17/05/2022.
//

import UIKit
import SDWebImage

class FriendChatCell: UITableViewCell {
    var friend: Friend? {
        didSet { configureChat() }
    }
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 22
        profileImage.clipsToBounds = true
        return profileImage
    }()
    var usernameLabel: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 18)
        return username
    }()
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(messageLabel)
        
        profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureChat() {
        guard let friend = friend else { return }

        let viewModel = FriendChatViewModel(friend: friend)
        messageLabel.text = viewModel.lastMessageText
        profileImageView.sd_setImage(with: viewModel.profileImage)
        usernameLabel.text = viewModel.username
        usernameLabel.font = viewModel.setUsernameFont
        messageLabel.font = viewModel.setMessageFont
    }
}

