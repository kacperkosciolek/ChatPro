//
//  FriendRightImageCell.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import UIKit

private let cellIdentifier = "UserImageCell"

class FriendRightImageCell: FriendImageMessageCell {
    var message: FriendImageMessage? { didSet { configure() } }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setMessagePosition(with: imageMessageView,
                           topConstant: 40,
                           leftConstant: 150,
                           bottomConstant: -20,
                           rightConstant: -30)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        guard let message = message else { return }
        
        self.viewModel = FriendImageMessageViewModel(message: message)
    }
}
