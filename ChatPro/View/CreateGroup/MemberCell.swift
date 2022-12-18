//
//  MemberCell.swift
//  ChatPro
//
//  Created by Kacper on 04/11/2022.
//
import UIKit
import SDWebImage

class MemberCell: UITableViewCell {
    
    var member: Member? {
        didSet { configureMember() }
    }
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 18
        profileImage.clipsToBounds = true
        return profileImage
    }()
    private var nicknameLabel: UILabel = {
        let nickname = UILabel()
        nickname.font = UIFont.systemFont(ofSize: 18)
        return nickname
    }()
    private var setNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(setNicknameLabel)
     
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [nicknameLabel, setNicknameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureMember() {
        guard let member = member else { return }
        
        let viewModel = MemberViewModel(member: member)
        profileImageView.sd_setImage(with: viewModel.profileImage)
        nicknameLabel.text = viewModel.nickname
        setNicknameLabel.text = viewModel.setANickname
    }
}
