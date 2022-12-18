//
//  FriendImageMessageCell.swift
//  ChatPro
//
//  Created by Kacper on 01/12/2022.
//

import UIKit

class FriendImageMessageCell: FriendMessageCell {
    var viewModel: FriendImageMessageViewModel? {
        didSet { configureUI() }
    }
    var imageMessageView = ImageMessageView()

    weak var delegate: ImageDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(imageMessageView)
        
        configureMessage(with: imageMessageView,
                         dateLabel: messageDateLabel,
                         profileImageView: profileImageView)
        
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
        profileImageView.sd_setImage(with: viewModel.profileImage)
    }
    @objc func handleImageTapped() {
        guard let image = viewModel?.image else { return }
        self.delegate?.imagePressed(image: image)
    }
}

