//
//  GroupImageMessageCell.swift
//  ChatPro
//
//  Created by Kacper on 01/12/2022.
//

import UIKit

class GroupImageMessageCell: GroupMessageCell {
    var viewModel: GroupImageMessageViewModel? {
        didSet { configureUI() }
    }
    let imageMessageView = ImageMessageView()

    weak var delegate: ImageDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(imageMessageView)
        
        configureMessage(with: imageMessageView,
                         dateLabel: messageDateLabel,
                         nicknameLabel: senderNicknameLabel)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        imageMessageView.addGestureRecognizer(tap)
        imageMessageView.isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        guard let viewModel = viewModel else { return }
        imageMessageView.sd_setImage(with: viewModel.image)
        messageDateLabel.text = viewModel.messageDate
        senderNicknameLabel.text = viewModel.nickname
        self.profileImages = viewModel.profileImages
        self.setCollectionViewForMessage(for: imageMessageView, dataSource: self)
    }
    @objc func handleImageTapped() {
        guard let image = viewModel?.image else { return }
        self.delegate?.imagePressed(image: image)
    }
}

