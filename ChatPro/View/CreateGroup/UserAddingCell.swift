//
//  UserAddingCell.swift
//  ChatPro
//
//  Created by Kacper on 21/08/2022.
//
import UIKit

class UserAddingCell: UITableViewCell {
    var user: User? {
        didSet { configureUser() }
    }
    private var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        return image
    }()
    private var usernameLabel: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 18)
        return username
    }()
    var addUserButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 13
        view.backgroundColor = .none
        view.widthAnchor.constraint(equalToConstant: 26).isActive = true
        view.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(addUserButton)
     
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        
        addUserButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        addUserButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
    func toggleUser(isAdded: @escaping(Bool) -> Void) {
        addUserButton.isSelected = !addUserButton.isSelected
        
        let viewModel = CreateGroupViewModel(isUserSelected: addUserButton.isSelected)
        addUserButton.backgroundColor = viewModel.setBackground
        addUserButton.setImage(viewModel.setImage, for: .normal)
        isAdded(viewModel.isUserSelected)
    }
}
