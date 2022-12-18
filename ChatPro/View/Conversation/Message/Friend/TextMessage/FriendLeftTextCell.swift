//
//  FriendLeftTextCell.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import UIKit

class FriendLeftTextCell: FriendTextMessageCell {
    
    var message: FriendTextMessage? { didSet { configure() } }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        setMessagePosition(with: messageTextLabel,
                           topConstant: 40,
                           leftConstant: 40,
                           bottomConstant: -40,
                           rightConstant: -140)
    }
    func configure() {
        guard let message = message else { return }
        
        self.viewModel = FriendTextMessageViewModel(message: message)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

