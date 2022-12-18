//
//  GroupChatCell.swift
//  ChatPro
//
//  Created by Kacper on 08/10/2022.
//

import UIKit
import SDWebImage

class GroupChatCell: UITableViewCell {
    
    var group: Group? {
        didSet { configureChat() }
    }
    private var firstProfileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        image.widthAnchor.constraint(equalToConstant: 36).isActive = true
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        return image
    }()
    private var secondProfileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        image.widthAnchor.constraint(equalToConstant: 36).isActive = true
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        return image
    }()
    private var profileImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        return view
    }()
    var groupnameLabel: UILabel = {
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
        
        addSubview(groupnameLabel)
        addSubview(messageLabel)
        addSubview(profileImageContainerView)
        addSubview(secondProfileImageView)
        addSubview(firstProfileImageView)
        
        profileImageContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        profileImageContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        firstProfileImageView.leftAnchor.constraint(equalTo: profileImageContainerView.leftAnchor).isActive = true
        firstProfileImageView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor).isActive = true
        secondProfileImageView.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor).isActive = true
        secondProfileImageView.rightAnchor.constraint(equalTo: profileImageContainerView.rightAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [groupnameLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: profileImageContainerView.rightAnchor, constant: 13).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureChat() {
        guard let group = group else { return }

        let viewModel = GroupChatViewModel(group: group)
        messageLabel.text = viewModel.lastMessageText
        firstProfileImageView.sd_setImage(with: viewModel.profileGroupImage?.first)
        secondProfileImageView.sd_setImage(with: viewModel.profileGroupImage?.last)
        groupnameLabel.text = viewModel.name
        groupnameLabel.font = viewModel.setUsernameFont
        messageLabel.font = viewModel.setMessageFont
    }
}

