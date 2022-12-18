//
//  FriendTextMessageCell.swift
//  ChatPro
//
//  Created by Kacper on 01/12/2022.
//

import UIKit

class FriendTextMessageCell: FriendMessageCell {
    
    var viewModel: FriendTextMessageViewModel? {
        didSet { configureUI() }
    }
    let messageView = UIView()
    let messageTextLabel = MessageTextLabel()
    
    weak var delegate: URLDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(messageView)
        addSubview(messageTextLabel)
        
        configureMessage(with: messageTextLabel,
                         dateLabel: messageDateLabel,
                         textMessageView: messageView,
                         profileImageView: profileImageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        guard let viewModel = viewModel else { return }
        messageTextLabel.attributedText = viewModel.attributedText
        messageDateLabel.text = viewModel.messageDate
        messageTextLabel.isUserInteractionEnabled = viewModel.isURL
        let tap = UITapGestureRecognizer(target: self, action: #selector(urlPressed))
        messageTextLabel.addGestureRecognizer(tap)
        profileImageView.sd_setImage(with: viewModel.profileImage)
    }
    @objc func urlPressed() {
        guard let url = messageTextLabel.text else { return }
        self.delegate?.urlPressed(url)
    }
}
