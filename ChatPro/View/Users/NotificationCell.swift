//
//  NotificationCell.swift
//  ChatPro
//
//  Created by Kacper on 16/05/2022.
//


import UIKit
import SDWebImage

protocol RequestDelegate: AnyObject {
    func addFriend(_ friend: User, _ numberOfRow: Int)
    func rejectFriend(_ friend: User, _ numberOfRow: Int)
}

class NotificationCell: UITableViewCell {
    
    var user: User? {
        didSet { configure() }
    }
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 18
        profileImage.clipsToBounds = true
        return profileImage
    }()
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    let addFriendButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.layer.borderWidth = 3
        btn.setTitle("Add", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.cornerRadius = 17
        btn.addTarget(self, action: #selector(addFriend(sender:)), for: .touchUpInside)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    let rejectFriendButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.layer.borderWidth = 2
        btn.setTitle("Reject", for: .normal)
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 17
        btn.addTarget(self, action: #selector(rejectFriend(sender:)), for: .touchUpInside)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    weak var delegate: RequestDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(notificationLabel)
        
        profileImageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [addFriendButton, rejectFriendButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        addFriendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        rejectFriendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        rejectFriendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        notificationLabel.rightAnchor.constraint(equalTo: stack.leftAnchor, constant: 4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    @objc func addFriend(sender: UIButton) {
        guard let user = user else {
            return
        }
        delegate?.addFriend(user, sender.tag)
    }
    @objc func rejectFriend(sender: UIButton) {
        guard let user = user else {
            return
        }
        delegate?.rejectFriend(user, sender.tag)
    }
    func configure() {
        guard let user = user else { return }
        
        let viewModel = NotificationViewModel(viewModel: UserViewModel(user: user))
        
        profileImageView.sd_setImage(with: viewModel.profileImage)
        
        notificationLabel.attributedText = viewModel.notificationAttributedText
    }
}
