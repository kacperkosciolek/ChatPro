//
//  FriendRightTextCell.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import UIKit

class FriendRightTextCell: FriendTextMessageCell {
    
    var message: FriendTextMessage? { didSet { configure() } }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageTextLabel.textColor = .white
        messageView.backgroundColor = .systemBlue
        
        setMessagePosition(with: messageTextLabel,
                           topConstant: 40,
                           leftConstant: 140,
                           bottomConstant: -40,
                           rightConstant: -40)
    }
    func configure() {
        guard let message = message else { return }
        
        self.viewModel = FriendTextMessageViewModel(message: message)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
