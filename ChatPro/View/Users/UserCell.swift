//
//  UserCell.swift
//  ChatPro
//
//  Created by Kacper on 04/05/2022.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    var user: User? {
        didSet { configureUser() }
    }
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 18
        profileImage.clipsToBounds = true
        return profileImage
    }()
    private var usernameLabel: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 18)
        return username
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
     
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUser() {
        guard let user = user else { return }
        
        let viewModel = UserViewModel(user: user)
        
        profileImageView.sd_setImage(with: viewModel.profileImage)
        usernameLabel.text = viewModel.username
    }
}
