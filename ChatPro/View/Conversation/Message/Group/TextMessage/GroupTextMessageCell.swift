//
//  GroupTextMessageCell.swift
//  ChatPro
//
//  Created by Kacper on 01/12/2022.
//

import UIKit

class GroupTextMessageCell: GroupMessageCell {

    var viewModel: GroupTextMessageViewModel? {
        didSet { configureUI() }
    }
    let messageView = UIView()
    
    weak var delegate: URLDelegate?
    
    let messageTextLabel = MessageTextLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(messageView)
        addSubview(messageTextLabel)

        configureMessage(with: messageTextLabel,
                         dateLabel: messageDateLabel,
                         textMessageView: messageView,
                         nicknameLabel: senderNicknameLabel)
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
        senderNicknameLabel.text = viewModel.nickname
        self.profileImages = viewModel.profileImages
        self.setCollectionViewForMessage(for: messageView, dataSource: self)
    }
    @objc func urlPressed() {
        guard let url = messageTextLabel.text else { return }
        self.delegate?.urlPressed(url)
    }
}

