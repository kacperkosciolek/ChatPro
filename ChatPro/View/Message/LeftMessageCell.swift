//
//  MessageAnotherUserCell.swift
//  ChatPro
//
//  Created by Kacper on 18/05/2022.
//


import UIKit
import Firebase
import SDWebImage

class LeftMessageCell: UITableViewCell {
    var message: Message? {
        didSet { configure() }
    }
    var user: User?
    
    private let messageView = UIView()
    weak var delegate: URLDelegate?
    
    private let messageTextLabel: UILabel = {
         let label = UILabel()
         label.contentMode = .scaleToFill
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.systemFont(ofSize: 18)
         return label
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
        
        addSubview(messageView)
        addSubview(messageTextLabel)
        addSubview(messageDateLabel)
        addSubview(profileImageView)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        messageTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        messageTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -140).isActive = true
        messageTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        messageView.topAnchor.constraint(equalTo: messageTextLabel.topAnchor, constant: -10).isActive = true
        messageView.leftAnchor.constraint(equalTo: messageTextLabel.leftAnchor, constant: -12).isActive = true
        messageView.bottomAnchor.constraint(equalTo: messageTextLabel.bottomAnchor, constant: 10).isActive = true
        messageView.rightAnchor.constraint(equalTo: messageTextLabel.rightAnchor, constant: 12).isActive = true
        messageView.layer.cornerRadius = 15
        
        messageDateLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor).isActive = true
        messageDateLabel.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -5).isActive = true
        
        profileImageView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        messageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        guard let message = message else { return }
        
        let viewModel = MessageViewModel(message: message)
        
        messageDateLabel.text = viewModel.dateOfMessage
        messageTextLabel.attributedText = viewModel.attributedText
        
        if viewModel.isURL! {
            messageTextLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(urlPressed))
            messageTextLabel.addGestureRecognizer(tap)
        } else {
            messageTextLabel.isUserInteractionEnabled = false
        }
        if message.timestamp == user?.timestampOfRevealed {
            profileImageView.sd_setImage(with: user?.profileImage)
            profileImageView.isHidden = false
        } else {
            profileImageView.isHidden = true
        }
    }
    @objc func urlPressed() {
        guard let url = messageTextLabel.text else { return }
        self.delegate?.urlPressed(url)
    }
}

