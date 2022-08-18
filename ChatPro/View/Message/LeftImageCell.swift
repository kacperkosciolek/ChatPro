//
//  LeftImageCell.swift
//  ChatPro
//
//  Created by Kacper on 19/05/2022.
//

import Foundation
import UIKit
import SDWebImage

class LeftImageCell: UITableViewCell {
    
    var message: Message? {
        didSet { configure() }
    }
    var user: User?
    
    weak var delegate: ImageDelegate?
    
    private let leftImageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.widthAnchor.constraint(equalToConstant: 74).isActive = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 37
        return image
    }()
    private let messageDateLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 14)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .lightGray
         return label
    }()
    private var profileImageView: UIImageView = {
        var view = UIImageView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(leftImageView)
        addSubview(messageDateLabel)
        addSubview(profileImageView)
        
        leftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
      
        leftImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -150).isActive = true
        leftImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        messageDateLabel.leftAnchor.constraint(equalTo: leftImageView.leftAnchor).isActive = true
        messageDateLabel.bottomAnchor.constraint(equalTo: leftImageView.topAnchor, constant: -5).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        leftImageView.addGestureRecognizer(tap)
        leftImageView.isUserInteractionEnabled = true
        
        profileImageView.bottomAnchor.constraint(equalTo: leftImageView.bottomAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        guard let message = message else {
            return
        }
        let viewModel = MessageViewModel(message: message)
        
        messageDateLabel.text = viewModel.dateOfMessage
        leftImageView.sd_setImage(with: viewModel.image)
        
        if message.timestamp == user?.timestampOfRevealed {
            profileImageView.sd_setImage(with: user?.profileImage)
            profileImageView.isHidden = false
        } else {
            profileImageView.isHidden = true
        }
    }
    @objc func handleImageTapped() {
        self.delegate?.imagePressed(image: (message?.image)!)
    }
}
